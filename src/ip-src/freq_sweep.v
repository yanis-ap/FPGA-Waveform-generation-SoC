`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2026 15:24:17
// Design Name: 
// Module Name: freq_sweep
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


module sweep_controller(
    input clk,
    input en,
    input rst,
    input commit,                    // 1-cycle pulse: mem_write && addr==CONTROL_ADDR, fed in from top
    input [25:0] start_freq,
    input [25:0] stop_freq,
    input [25:0] step_size,
    output reg [25:0] current_freq
);
    reg [19:0] timer;
    wire tick;
    wire clear;

    assign tick  = (timer == 20'd20 - 1);//for simulation only. otherwise 1,000,000
    assign clear = rst | commit;      // en_rise removed - commit is now the sole "new instruction" signal

    // Timer
    always @(posedge clk) begin
        if (clear) begin
            timer <= 20'd0;
        end
        else if (en) begin
            if (tick)
                timer <= 20'd0;
            else
                timer <= timer + 1'b1;
        end
    end

    // Frequency sweep
    always @(posedge clk) begin
        if (clear) begin
            current_freq <= start_freq;
        end
        else if (en && tick) begin
            if ((current_freq + step_size) >= stop_freq)
                current_freq <= start_freq;
            else
                current_freq <= current_freq + step_size;
        end
    end
endmodule
