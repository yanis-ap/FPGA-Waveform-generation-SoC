`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 19:18:17
// Design Name: 
// Module Name: data_mem
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


module DataMemory(
    input clk, mem_write, mem_read,
    input [31:0] address, write_data,
    output [31:0] read_data //change to non reg
);
    parameter MEM_DEPTH = 1024;           // 1024 words = 4KB
    reg [31:0] mem [0:MEM_DEPTH-1];
    integer i;
    initial begin
        // Replaces all values with 0 initially
        
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            mem[i] = 32'd0;
        end
        // Load your hardware constants from a file
        $readmemh("../../../../dmem3.mem", mem);
    end
    
    wire [9:0] word_addr = address[11:2]; // word-aligned, drop byte offset bits

    always @(posedge clk) begin
        if (mem_write)
            mem[word_addr] <= write_data;
    end

//    always @(posedge clk) begin
//        if (mem_read)
//            read_data <= mem[word_addr];   // synchronous read
//    end

//Change test
assign read_data = mem_read ? mem[word_addr] : 32'd0; //avoids 1 cycle latency
endmodule
