`timescale 1ns / 1ps

module mem_wb(
    input clk,
    input reset,
    input reg_write_in,
    input mem_to_reg_in,
    input [31:0]alu_result_in,
    input [31:0]mem_data_in,
    input [3:0]rd_in,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg [31:0]alu_result_out,
    output reg [31:0]mem_data_out,
    output reg [3:0]rd_out
);

always @(posedge clk or posedge reset)
    begin
        if(reset) begin
            reg_write_out<=0;
            mem_to_reg_out<=0;
            alu_result_out<=0;
            mem_data_out<=0;
            rd_out<=0;
         end
         else begin
            reg_write_out<=reg_write_in;
            mem_to_reg_out<=mem_to_reg_in;
            alu_result_out<=alu_result_in;
            mem_data_out<=mem_data_in;
            rd_out<=rd_in;
          end         
    end
endmodule
