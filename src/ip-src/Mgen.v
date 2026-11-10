`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 10:44:23
// Design Name: 
// Module Name: Mgen
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


module Mgen(
    input clk,
    input rst,          // <-- Add rst input
    input en,
    input [25:0] in_freq,
    output [31:0] m
);

    localparam [31:0] k = 32'd720575940;

    reg [63:0] full_p;

    always @(posedge clk or posedge rst) begin
        if (rst)
            full_p <= 64'd0;    // <-- Zero out full_p on reset!
        else if (en)
            full_p <= in_freq * k;
    end

    assign m = full_p[55:24];

endmodule
