`timescale 1ns / 1ps

module id_ex(
    input clk,
    input reset,
    input flush,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input alu_src_in,
    input [31:0]pc_in,
    input [1:0]alu_op_in,
    input [31:0]read_data1_in,
    input [31:0]read_data2_in,
    input [31:0]imm_in,
    input [3:0]rs1_in,
    input [3:0]rs2_in,
    input [3:0]rd_in,
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg alu_src_out,
    output reg [1:0]alu_op_out,
    output reg [31:0]pc_out,
    output reg [31:0]read_data1_out,
    output reg [31:0]read_data2_out,
    output reg [31:0]imm_out,
    output reg [3:0]rs1_out,
    output reg [3:0]rs2_out,
    output reg [3:0]rd_out
    );
    
    always @(posedge clk or posedge reset)
    begin
        if(reset || flush) begin
            reg_write_out<=0;
            mem_read_out<=0;
            mem_write_out<=0;
            mem_to_reg_out<=0;
            alu_src_out<=0;
            alu_op_out<=0;
            read_data1_out<=0;
            read_data2_out<=0;
            imm_out<=0;
            pc_out<=0;
            rs1_out<=0;
            rs2_out<=0;
            rd_out<=0;
         end
         else begin
            reg_write_out<=reg_write_in;
            mem_read_out<=mem_read_in;
            mem_write_out<=mem_write_in;
            mem_to_reg_out<=mem_to_reg_in;
            alu_src_out<=alu_src_in;
            alu_op_out<=alu_op_in;
            read_data1_out<=read_data1_in;
            read_data2_out<=read_data2_in;
            imm_out<=imm_in;
            rs1_out<=rs1_in;
            rs2_out<=rs2_in;
            rd_out<=rd_in;
            pc_out<=pc_in;
          end         
    end
endmodule
