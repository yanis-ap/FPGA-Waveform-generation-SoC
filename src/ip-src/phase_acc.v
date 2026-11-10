`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 11:01:14
// Design Name: 
// Module Name: phase_acc
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


module phase_acc(
    input clk, en, rst, commit,
    input [31:0] m, 
    output reg [31:0] phase
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            phase <= 32'b0;
        end
        else if (commit) begin
            phase <= 32'b0;
        end
        else if (en) begin
            phase <= phase + m; 
        end
    end
endmodule
