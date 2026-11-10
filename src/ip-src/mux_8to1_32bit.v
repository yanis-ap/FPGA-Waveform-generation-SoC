`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2026 11:32:35
// Design Name: 
// Module Name: mux_8to1_32bit
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


module waveform_mux(
    input  [2:0]  type,
    input  [31:0] sine,
    input  [31:0] square,
    input  [31:0] sawtooth,
    input  [31:0] triangle,
    output reg [31:0] waveform
);
    always @(*) begin
        case (type)
            3'd0: waveform = sine;      // Fixed Frequency Sine
            3'd1: waveform = square;    // Square Wave
            3'd2: waveform = sawtooth;  // Sawtooth Wave
            3'd3: waveform = triangle;  // Triangle Wave
            3'd4: waveform = sine;      // Sweep Mode (Sine base)
            3'd5: waveform = sine;      // QPSK Mode (Sine base)
            default: waveform = sine;   // Fallback to Sine
        endcase
    end
endmodule

