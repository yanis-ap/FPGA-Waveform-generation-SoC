`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2026 19:53:58
// Design Name: 
// Module Name: SOC_top
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


module SOC_top(
    input clk,
    input rst
);
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire        mem_read;
    wire        mem_write;
    wire [31:0] mem_rdata;

    processor_core core (
        .clk(clk),
        .rst(rst),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_rdata(mem_rdata) ///////what
    );

    mmio_decoder #(
        .MMIO_BASE(32'h1000_0000),
        .MMIO_MASK(32'hFFFF_FFE0)
    ) mmio (
        .clk(clk),
        .rst(rst),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(mem_addr), //address calculated by ALU
        .write_data(mem_wdata),
        .read_data(mem_rdata)
    );

endmodule
