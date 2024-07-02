`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 07/01/2024 07:48:05 PM
// Design Name: Day 1 Homework
// Module Name: top
// Project Name: Structural and behavioural MUX_2_1 
// Target Devices: --//--
// Tool Versions: --//--
// Description:  Structural and behavioural MUX_2_1 implementation, with
//                  parametrizable data width.
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mux_2_1_behav #(parameter DATA_WIDTH = 8)(
        input [DATA_WIDTH - 1:0] I0,
        input [DATA_WIDTH - 1:0] I1,
        input SEL,
        output reg [DATA_WIDTH - 1:0] O
    );
    always@(SEL)
        // can also be implemented using if, but I prefer using cases (looks cool!)
        case(SEL)
            1'b0: O = I0;
            1'b1: O = I1;
        endcase
endmodule

module mux_2_1_struc #(parameter DATA_WIDTH = 8) (
        input [DATA_WIDTH - 1:0] I0,
        input [DATA_WIDTH - 1:0] I1,
        input SEL,
        output [DATA_WIDTH - 1:0] O
    );
    // assign is cleaner and we do not use reg in this case.
      assign O = ({DATA_WIDTH{~SEL}} & I0) | ({DATA_WIDTH{SEL}} & I1);
endmodule

// we will not declare a top module, but we will test each multiplexer separately in the
// testbench. this is cleaner, however declaring an actual top module would not be hard.

module tb_top;
    parameter DATA_WIDTHt = 16; // we declare a constant for a custom data width.
    // used parameter for easier testing, but can be replaced with a numeric value
    // everywhere else (which is tedious). this will show up in simulation!
                               
    // declare the required variables for the two DUT.
    reg [DATA_WIDTHt - 1:0] I0t;
    reg [DATA_WIDTHt - 1:0] I1t;
    reg SELt;
    wire [DATA_WIDTHt - 1:0] Ot_behav;
    wire [DATA_WIDTHt - 1:0] Ot_struc;
    
    // we create instances of the two multiplexer types.
    mux_2_1_behav#(DATA_WIDTHt) dut_1(
            .I0(I0t),
            .I1(I1t),
            .SEL(SELt),
            .O(Ot_behav)
        );
    mux_2_1_struc#(DATA_WIDTHt) dut_2(
            .I0(I0t),
            .I1(I1t),
            .SEL(SELt),
            .O(Ot_struc)
        );
        
    initial
        #20 $finish;
        
    initial
        begin
            #0 I0t = {{DATA_WIDTHt-8 {1'b0}}, 8'b0000_1111}; // default value
    // is 8 bits, but I decided to pad it with zeroes until data width is achieved,
    // just for easier testing (and to be cooler). learned this at my Computer Architecture
    // class where a RISC-V microprocessor was implemented.
               I1t = {{DATA_WIDTHt-8 {1'b0}}, 8'hf0}; // did the same thing, but I used
    // hex value instead of binary value to test my skills.
               SELt = 1'b0; // expected I0t
            #10 SELt = 1'b1; // expected I1t
        end
endmodule
