`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 04:14:17 PM
// Design Name: 
// Module Name: H
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


module Hazard(
input id_ex_mem_read,
input [3:0] id_ex_rd,
input [3:0] if_id_src1,if_id_src2,
output reg stall_pc,
output reg stall_if_id,
output reg flush_id_ex
    );
    
    always @(*) begin
    
    if (id_ex_mem_read && (id_ex_rd != 4'b0) && ((id_ex_rd == if_id_src1) || (id_ex_rd == if_id_src2))) begin
    stall_pc = 1'b1;
    stall_if_id = 1'b1;
    flush_id_ex = 1'b1;
    end
    else begin
    stall_pc = 1'b0;
    stall_if_id = 1'b0;//made a change
    flush_id_ex = 1'b0;
    end
    end
endmodule
