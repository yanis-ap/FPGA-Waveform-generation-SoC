`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 03:30:25 PM
// Design Name: 
// Module Name: IM
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


module InstructionMemory(
    input [31:0] address,
    output [31:0] instruction
    );
    reg [31:0] mem [0:4095];//modified to make it larger
    initial
    $readmemh("../../../../program_qpsk.mem", mem);

    // Address is divided by 4 (shifted right by 2) for word alignment
    assign instruction = mem[address [13:2]];//modification
        
endmodule
