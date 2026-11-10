`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2026 05:41:34 PM
// Design Name: 
// Module Name: sin_lut_wrapper
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

module sin_lut_wrapper (
    input wire [11:0] addra_0,
    input wire clka_0,
    input wire ena_0,
    output wire [13:0] douta_0
);

    // Directly instantiate the IP block name!
    blk_mem_gen_0 sin_lut_i (
        .clka(clka_0),
        .ena(ena_0),
        .addra(addra_0),
        .douta(douta_0)
    );

endmodule
