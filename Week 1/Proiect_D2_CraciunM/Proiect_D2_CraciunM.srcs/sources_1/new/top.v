`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 02.07.2024 11:40:40
// Design Name: ALU
// Module Name: top
// Project Name: Day 2 Work
// Target Devices: --//--
// Tool Versions: --//--
// Description: 
// 
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
    
    always@(A or B or OP)
        casex(OP)
            4'b00xx: begin
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
            4'b0001: {OF, O} = A + (~B + 1); // A - B
            4'b0010: {OF, O} = A << B; // we will consider OF as CY out
            4'b0011: O = A >> B; // we could do the same here
            4'b0100: ZERO = (A == B) ? 1'b1 : 1'b0; // if we want O = {{DATA_WIDTH - 1{1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};
            4'b0101: ZERO = (A > B) ? 1'b1 : 1'b0; 
            4'b0110: ZERO = (A < B) ? 1'b1 : 1'b0;
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
    ALU dut(
        .A(At),
        .B(Bt),
        .OP(OPt),
        .ERR_RESERVED(ERR_RESERVEDt),
        .OF(OFt),
        .ZERO(ZEROt),
        .O(Ot)
        );
        
    initial
        #100 $finish; // we end the simulation after 100ns
        
    initial
        begin
            #0 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0001};
            #10 OPt = 4'b0000; // we test the sum.
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0100};
                OPt = 4'b0001; //we test the difference. we want to get underflow.
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010};
                OPt = 4'b0010; // we test shifting left (*2)
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0001};
                OPt = 4'b0011; // we test shifting right (/2)
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010};
                OPt = 4'b0100; // we test equality.
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0001}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010};
                OPt = 4'b0101; // we test if A > B
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0100};
                OPt = 4'b0110; // we test if A < B
            #10 OPt = 4'b0111; //  we test that ERR_RESERVED is set.
            #10 At = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0010}; Bt = {{DATA_WIDTHt - 8{1'b0}}, 8'b0000_0001};
                OPt = 4'b0000; // we test that ERR_RESERVED is reset after a normal operation.
        end
endmodule
