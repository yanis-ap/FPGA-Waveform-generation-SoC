`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 19:49:13
// Design Name: 
// Module Name: mmio_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mmio_decoder #(
    parameter MMIO_BASE = 32'h1000_0000,
    parameter MMIO_MASK = 32'hFFFF_FFE0    // 32-byte MMIO window
)(
    input clk, rst,
    input mem_write, mem_read,
    input [31:0] address, write_data,
    output [31:0] read_data
);
    localparam ADDR_CONTROL  = MMIO_BASE + 32'h00;
    localparam ADDR_PACKED   = MMIO_BASE + 32'h04;  // {en,type,tx_symbol,target_freq}
    localparam ADDR_START    = MMIO_BASE + 32'h08;
    localparam ADDR_STOP     = MMIO_BASE + 32'h0C;
    localparam ADDR_STEP     = MMIO_BASE + 32'h10;
    localparam ADDR_STATUS   = MMIO_BASE + 32'h14;  // RO
    localparam ADDR_WAVEFORM = MMIO_BASE + 32'h18;  // RO

    localparam TYPE_SWEEP = 3'd4;

    wire is_mmio = (address & MMIO_MASK) == MMIO_BASE;
    wire commit  = mem_write && is_mmio && (address == ADDR_CONTROL);

    // ---------------- Shadow registers ----------------
    reg [25:0] sh_target_freq, sh_start_freq, sh_stop_freq, sh_step_size;
    reg [2:0]  sh_type;
    reg [1:0]  sh_tx_symbol;
    reg        sh_en;

    reg ld_packed, ld_start, ld_stop, ld_step;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sh_target_freq <= 26'd0; sh_start_freq <= 26'd0;
            sh_stop_freq   <= 26'd0; sh_step_size  <= 26'd0;
            sh_type        <= 3'd0;  sh_tx_symbol  <= 2'd0; sh_en <= 1'b0;
            ld_packed <= 1'b0; ld_start <= 1'b0; ld_stop <= 1'b0; ld_step <= 1'b0;
        end else if (is_mmio && mem_write) begin
            case (address)
                ADDR_PACKED: begin
                    sh_en          <= write_data[31];
                    sh_type        <= write_data[30:28];
                    sh_tx_symbol   <= write_data[27:26];
                    sh_target_freq <= write_data[25:0];
                    ld_packed      <= 1'b1;
                end
                ADDR_START: begin sh_start_freq <= write_data[25:0]; ld_start <= 1'b1; end
                ADDR_STOP:  begin sh_stop_freq  <= write_data[25:0]; ld_stop  <= 1'b1; end
                ADDR_STEP:  begin sh_step_size  <= write_data[25:0]; ld_step  <= 1'b1; end
                default: ; // ADDR_CONTROL handled below
            endcase

            if (address == ADDR_CONTROL) begin
                ld_packed <= 1'b0; ld_start <= 1'b0; ld_stop <= 1'b0; ld_step <= 1'b0;
            end
        end
    end

    // ---------------- Completeness check ----------------
    wire needs_sweep_fields = (sh_type == TYPE_SWEEP);
    wire instr_complete = ld_packed &&
                          (!needs_sweep_fields || (ld_start && ld_stop && ld_step));

    wire dds_commit = commit && instr_complete;

    reg commit_error;
    always @(posedge clk or posedge rst) begin
        if (rst) commit_error <= 1'b0;
        else if (commit) commit_error <= ~instr_complete;
    end

    // ---------------- Active registers (what the DDS sees) ----------------
    reg [25:0] target_freq_r, start_freq_r, stop_freq_r, step_size_r;
    reg [2:0]  type_r;
    reg [1:0]  tx_symbol_r;
    reg        en_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            target_freq_r <= 26'd0; start_freq_r <= 26'd0;
            stop_freq_r   <= 26'd0; step_size_r  <= 26'd0;
            type_r <= 3'd0; tx_symbol_r <= 2'd0; en_r <= 1'b0;
        end else if (dds_commit) begin
            target_freq_r <= sh_target_freq;
            start_freq_r  <= sh_start_freq;
            stop_freq_r   <= sh_stop_freq;
            step_size_r   <= sh_step_size;
            type_r        <= sh_type;
            tx_symbol_r   <= sh_tx_symbol;
            en_r          <= sh_en;
        end
    end

    // ---------------- DDS instance ----------------
    wire [31:0] waveform;

    dds_top_0 dds_top (
        .clk(clk), .en(en_r), .rst(rst), .commit(dds_commit),
        .target_freq(target_freq_r),
        .start_freq(start_freq_r),
        .stop_freq(stop_freq_r),
        .step_size(step_size_r),
        .type(type_r),
        .tx_symbol(tx_symbol_r),
        .waveform(waveform)
    );

//    // ---------------- MMIO read mux (registered, 1-cycle latency) ----------------
//    reg [31:0] mmio_read_data;
//    always @(posedge clk) begin
//        if (mem_read && is_mmio) begin
//            case (address)
//                ADDR_STATUS:   mmio_read_data <= {31'd0, commit_error};
//                ADDR_WAVEFORM: mmio_read_data <= waveform;
//                default:       mmio_read_data <= 32'd0;
//            endcase
//        end
//    end

//    // ---------------- Backing memory ----------------
//    wire mem_sel = ~is_mmio;
//    wire [31:0] dmem_read_data;

//    DataMemory dmem (
//        .clk(clk),
//        .mem_write(mem_write && mem_sel),
//        .mem_read(mem_read && mem_sel),
//        .address(address),
//        .write_data(write_data),
//        .read_data(dmem_read_data)
//    );

//    // ---------------- Final read select ----------------
//    // is_mmio must be registered here too, since dmem/mmio_read_data are
//    // already 1-cycle delayed relative to the address that requested them.
//    reg is_mmio_d;
//    always @(posedge clk) begin
//        if (mem_read) is_mmio_d <= is_mmio;
//    end

//change test
// ---------------- MMIO read mux (Combinational, 0-cycle latency) ----------------
    wire [31:0] mmio_read_data_comb;
    
    assign mmio_read_data_comb = (address == ADDR_STATUS)   ? {31'd0, commit_error} :
                                 (address == ADDR_WAVEFORM) ? waveform : 
                                 32'd0;

    // ---------------- Backing memory ----------------
    wire mem_sel = ~is_mmio;
    wire [31:0] dmem_read_data;

    DataMemory dmem (
        .clk(clk),
        .mem_write(mem_write && mem_sel),
        .mem_read(mem_read && mem_sel),
        .address(address),
        .write_data(write_data),
        .read_data(dmem_read_data)
    );

    // ---------------- Final read select (Combinational) ----------------
    // No more registered is_mmio_d. We output the data instantly.
    assign read_data = is_mmio ? mmio_read_data_comb : dmem_read_data;

endmodule
