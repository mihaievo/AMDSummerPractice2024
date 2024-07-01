`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 01.07.2024 11:36:20
// Design Name: Practica_Day1
// Module Name: top
// Project Name: Practica_Day1
// Target Devices: --//--
// Tool Versions: --//--
// Description: 1 bit adder with carry.
// 
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
        input A,
        input B, 
        output OUT,
        output CY
    );
    assign {CY, OUT} = {A&B, A^B};
endmodule

module tb_top;
    reg At, Bt;
    wire OUTt;
    wire CYt;
    
    top dut(
        .A(At),
        .B(Bt),
        .OUT(OUTt),
        .CY(CYt)
        );
        
    initial
        #40 $finish;
        
    initial
        begin
        #0 At = 1'b0; Bt = 1'b0;
        #10 Bt = 1'b1;
        #10 At = 1'b1; Bt = 1'b0;
        #10 Bt = 1'b1;
        end
endmodule
