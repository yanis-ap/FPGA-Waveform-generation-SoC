`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 03:48:18 PM
// Design Name: 
// Module Name: CU
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


module ctrl(
input [3:0] opcode,
output reg reg_write,
output reg mem_read,
output reg mem_write,
output reg mem_to_reg,
output reg alu_src,
output reg [1:0] alu_op
    );
always@(*) begin
    reg_write=0;
    mem_read=0;
    mem_write=0;
    mem_to_reg=0;
    alu_src=0;
    alu_op=0;
    case(opcode)
        4'b0000: begin
        reg_write=1;alu_op=2'b00; //r-type temporarily modified with reg_write = 0 so it functions as a NOP
        end                         //fixed again dont mind
        4'b0100:begin
        reg_write=1;mem_read=1;mem_to_reg=1;alu_src=1;alu_op=2'b00; //LW?
        end
        4'b0010:begin
        mem_write=1;alu_src=1;alu_op=2'b00; //SW?
        end
        4'b0001:begin
        reg_write=1;mem_read=1;mem_to_reg=1;alu_src=1;alu_op=2'b00;
        end
        4'b1111:begin
        reg_write=1;alu_op=2'b01;
        end
        default:begin
        end
    endcase
end
endmodule
