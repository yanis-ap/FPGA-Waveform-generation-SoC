`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 03:38:59 PM
// Design Name: 
// Module Name: RF
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


module registers(
input clk, rst, write_enable,
input [3:0] read_reg1,read_reg2, write_reg,
input [31:0] write_data,
output [31:0] read_data1, read_data2
    );
    reg [31:0] reg_file [0:255];
    initial begin 
            reg_file[0]=32'h0;
            reg_file[1]=32'h0;
            reg_file[2]=32'h0;
            reg_file[3]=32'h0;
            reg_file[4]=32'h0;
            reg_file[5]=32'h0;
            reg_file[6]=32'h0;
            reg_file[7]=32'h0;
            reg_file[8]=32'h0;
            reg_file[9]=32'h0;
            reg_file[10]=32'h0;
            reg_file[11]=32'h0;
            reg_file[12]=32'h0;
        end
    
    always@(posedge clk) begin
        if( write_enable && write_reg !=0)
            reg_file[write_reg]<= write_data;
    end
    assign read_data1 = reg_file [read_reg1];
    assign read_data2 = reg_file [read_reg2];
endmodule
