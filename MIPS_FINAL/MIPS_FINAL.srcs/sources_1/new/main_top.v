`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2024 10:28:41 PM
// Design Name: MIPS microprocessor on xc7z007sclg400-1 with display
// Module Name: main_top
// Project Name: MIPS microprocessor on xc7z007sclg400-1 with display 
// Target Devices: xc7z007sclg400-1 (Zynq7000)
// Tool Versions: --//--
// Description: 
// 
// Dependencies: 
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_top(
        input clk,
        input STEP_BTN, // we use a button as a step instruction debug for the MIPS processor
        input [11:0] SW_IN, // this is the input from the switches, also known as IO(FD0 - IN)
        output [11:0] IO_LED_OUT, // this is the output to LEDs, also known as IO(FD1 - OUT)
        output a, // a, b, c, d, e, f, g will set the segment display.
        output b,
        output c,
        output d,
        output e,
        output f,
        output g,
        output A1, // the anodes of each display digit.
        output A2,
        output A3, 
        output A4
    );
    
    wire [31:0] DISPLAY_IN;
    wire STEP;
    
    one_period op(
        .clk(clk),
        .in(STEP_BTN),
        .out(STEP)
        );
    
    MIPS_PROC MIPS_PROC_dut(
        .clk(clk & STEP),
        .SW_VALUES(SW_IN),
        .RD_LADDR(IO_LED_OUT),
        .VMEM(DISPLAY_IN)
        );
    
    display_top display_inst(
        .clk(clk),
        .di(DISPLAY_IN),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4)
        );     
    
endmodule

/*module tb_main_top;

    reg clk;
    reg STEP_BTN; // Button input for stepping the MIPS processor
    reg [11:0] SW_IN; // Switch input
    wire [11:0] IO_LED_OUT; // Output to LEDs
    wire a, b, c, d, e, f, g; // 7-segment display segments
    wire A1, A2, A3, A4; // 7-segment display digit anodes

    // Instantiate the design under test (DUT)
    main_top dut (
        .clk(clk),
        .STEP_BTN(STEP_BTN),
        .SW_IN(SW_IN),
        .IO_LED_OUT(IO_LED_OUT),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4)
    );
    
    initial begin
        #0 clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        #0 STEP_BTN = 0;
        forever #40 STEP_BTN = ~STEP_BTN;
    end

    initial begin
        SW_IN = 12'hfff;
        
    end
    
    initial 
        #1000 $finish;
    
endmodule*/