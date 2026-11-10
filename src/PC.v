`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 03:26:56 PM
// Design Name: 
// Module Name: PC
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


module PC(
input clk, rst,stall,
input  [31:0] pc_next,
output reg [31:0] pc_out

    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) 
            pc_out<=32'h0;
            
        else if(!stall)
            pc_out<=pc_next;
    
    end
endmodule
