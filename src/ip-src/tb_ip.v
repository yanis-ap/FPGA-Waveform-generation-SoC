`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2026 05:48:58 PM
// Design Name: 
// Module Name: tb_ip
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

module tb_top;

    // Inputs to UUT
    reg clk;
    reg en;
    reg rst;
    reg commit;
    reg [25:0] target_freq;
    reg [25:0] start_freq, stop_freq;
    reg [25:0] step_size;
    reg [2:0] type;
    reg [1:0] tx_symbol;

    // Output from UUT
    wire [31:0] waveform;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .commit(commit),
        .target_freq(target_freq),
        .start_freq(start_freq),
        .stop_freq(stop_freq),
        .step_size(step_size),
        .type(type),
        .tx_symbol(tx_symbol),
        .waveform(waveform)
    );

    // 1. Clock Generation: 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    // 2. Stimulus Sequence
    initial begin
        // Initialize Inputs
        clk         = 0;
        en          = 0;
        rst         = 1;
        commit      = 0;
        target_freq = 26'd0;
        start_freq  = 26'd0;
        stop_freq   = 26'd0;
        step_size   = 26'd0;
        type        = 3'd0; // Default: Fixed Sine Wave
        tx_symbol   = 2'b00;

        // Apply Global Reset
        #20;
        rst = 0;
        #20;

        // --- Configure DDS Parameters ---
        // Setting a target frequency (tuning increment)
        target_freq = 26'h040000; 
        type        = 3'd0;        // 3'd0 = Fixed Sine Wave
        tx_symbol   = 2'b00;

        // Enable the DDS core
        en          = 1;

        // Pulse the commit line to lock in the config (if needed by submodules)
        #10;
        commit = 1;
        #10;
        commit = 0;

        // Let the simulation run to generate multiple sine wave periods
        #50000;

        // --- Optional Test: Change to Sawtooth Wave ---
        // type = 3'd2; // Assuming 2 maps to sawtooth in your waveform_mux
        // #1000;

        $finish;
    end

    // 3. Monitor Waveform in Terminal
    initial begin
        $monitor("Time: %0t ns | en: %b | type: %d | waveform (Hex): %h | (Signed Dec): %d", 
                 $time, en, type, waveform, $signed(waveform));
    end

endmodule
