`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 02.07.2024 11:40:40
// Design Name: ALU
// Module Name: top
// Project Name: Day 2's homework - ALU
// Target Devices: --//--
// Tool Versions: --//--
// Description: Create a function that when called will implement the multiply
//                  operation of the ALU by adding for a number of times.
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU #(parameter DATA_WIDTH = 8)(
        input [DATA_WIDTH - 1:0] A,
        input [DATA_WIDTH - 1:0] B,
        input [3:0] OP,
        output reg ERR_RESERVED,
        output reg OF, // overflow / underflow bit : if set such error happened
        output reg ZERO, // returns 1 if logical expression is true
        output reg [DATA_WIDTH - 1:0] O
    );
    
    // DATA_WIDTH:0 because the last bit will be assigned to OF
    function [DATA_WIDTH:0] MUL_BY_SUM(
            input [DATA_WIDTH - 1:0] I0,
            input [DATA_WIDTH - 1:0] I1
        );
        integer i;
        begin
            MUL_BY_SUM = 0;
            // we iterate over each bit from data width in I1
            // if its 1, we will shift i0 by its position.
            // equivalent to I1 = 2^x + ...
            // (we decompose I1 in powers of 2)
            // we need I0 * (2^x + ...)
            for (i = 0; i < DATA_WIDTH; i = i + 1) begin
                if (I1[i] == 1'b1)
                    MUL_BY_SUM = MUL_BY_SUM + (I0 << i);
            end
            // longer, time consuming method...
/*                for(i = 0; i < I1; i = i + 1) begin
                    MUL_BY_SUM = MUL_BY_SUM + I0;
                end*/
        end
    endfunction
    
    always@(A or B or OP)
        casex(OP)
            4'b00xx,
            4'b0111: begin
                         ZERO = 1'bx;
                         ERR_RESERVED = 1'b0;
                     end
            4'b010x, 
            4'b0110: begin
                        OF = 1'bx;
                        ERR_RESERVED = 1'b0;
                        O = {DATA_WIDTH{1'bx}};
                     end
        endcase
    
    always@(A or B or OP)
        case(OP)
            4'b0000: {OF, O} = A + B;
            4'b0001: {OF, O} = A - B;
            4'b0010: {OF, O} = A << B; // we will consider OF as CY out
            4'b0011: O = A >> B; // we could do the same here
            4'b0100: ZERO = (A == B) ? 1'b1 : 1'b0; // if we want to not use ZERO bit we can use: O = {{DATA_WIDTH - 1{1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};
            4'b0101: ZERO = (A > B) ? 1'b1 : 1'b0; 
            4'b0110: ZERO = (A < B) ? 1'b1 : 1'b0;
            4'b0111: {OF, O} = MUL_BY_SUM(A, B); // multiply operation
            default:  begin
                            ERR_RESERVED = 1'b1;
                            ZERO = 1'bx;
                            OF = 1'bx;
                            O = {DATA_WIDTH{1'bx}};
                      end
        endcase
endmodule

module tb_ALU;
    parameter DATA_WIDTHt = 8; // we may modify this anytime to test with different data widths
    
    // declaration of variables to be tested in ALU
    reg [DATA_WIDTHt - 1:0] At;
    reg [DATA_WIDTHt - 1:0] Bt;
    reg [3:0] OPt;
    wire ERR_RESERVEDt;
    wire OFt;
    wire ZEROt;
    wire [DATA_WIDTHt - 1:0] Ot;
    
    // we instantiate the ALU module
    ALU#(DATA_WIDTHt) dut(
        .A(At),
        .B(Bt),
        .OP(OPt),
        .ERR_RESERVED(ERR_RESERVEDt),
        .OF(OFt),
        .ZERO(ZEROt),
        .O(Ot)
        );
    
    initial
        #20 $finish; // we end the simulation after 20ns
        
    initial
        begin
            #0 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b1000_0011}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0010_1001};
            OPt = 4'b0111; // testing multiply operation
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b1000_0011}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0010_1101};
            // this should generate overflow
        end
endmodule