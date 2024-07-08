`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 08.07.2024 11:09:09
// Design Name: Digital Decoder
// Module Name: dig_dec
// Project Name: Day 1's work : week 2
// Target Devices: xc7z007sclg400-1
// Tool Versions: --/--
// Description: 
// 
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_divider(
    input clk,
    output reg clk_out
);
    localparam di = 33330000; // 33.33 MHz * 1 second
    reg [31:0] counter;  
    always @(posedge clk)
    begin
        if (counter >= di - 1) begin
            counter <= 0;
            clk_out <= ~clk_out; // toggle clk_out every di clock cycles
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module dig_dec(
        input [3:0] di,
        output reg a,
        output reg b,
        output reg c,
        output reg d,
        output reg e,
        output reg f,
        output reg g
    );
    // we code the led display (from left to right)
    //  __  a
    // |  | f and b
    //  --    g
    // |  |  e and c
    //  __    d
    always@(di)
    begin
            case(di)                              //abcdefg
                4'b0000: {a, b, c, d, e, f, g} = 7'b1111110; // 0 -> a, b, c, d, e, f
                4'b0001: {a, b, c, d, e, f, g} = 7'b0110000; // 1 -> b, c
                4'b0010: {a, b, c, d, e, f, g} = 7'b1101101; // 2 -> a, b, d, e, g
                4'b0011: {a, b, c, d, e, f, g} = 7'b1111001; // 3 -> a, b, c, d, g 
                4'b0100: {a, b, c, d, e, f, g} = 7'b0110011; // 4 -> b, c, f, g
                4'b0101: {a, b, c, d, e, f, g} = 7'b1011011; // 5 -> a, c, d, f, g
                4'b0110: {a, b, c, d, e, f, g} = 7'b1011111; // 6 -> a, f, g, c, d, e
                4'b0111: {a, b, c, d, e, f, g} = 7'b1110000; // 7 -> a, b, c
                4'b1000: {a, b, c, d, e, f, g} = 7'b1111111; // 8 -> a, b, c, d, e, f, g
                4'b1001: {a, b, c, d, e, f, g} = 7'b1111011; // 9 -> a, b, c, d, f, g
                4'b1010: {a, b, c, d, e, f, g} = 7'b1110111; // 10 (A) -> a, b, c, e, f, g
                4'b1011: {a, b, c, d, e, f, g} = 7'b0011111; // 11 (b) -> f, g, c, d, e
                4'b1100: {a, b, c, d, e, f, g} = 7'b0001101; // 12 (c) -> d, e, g
                4'b1101: {a, b, c, d, e, f, g} = 7'b0111101; // 13 (d) -> b, c, d, e, g
                4'b1110: {a, b, c, d, e, f, g} = 7'b1001111; // 14 (E) -> a, d, e, f, g
                4'b1111: {a, b, c, d, e, f, g} = 7'b1000111; // 15 (F) -> a, e, f, g 
                default: {a, b, c, d, e, f, g} = 7'b0000001; // - (err) -> g
        endcase
        {a, b, c, d, e, f, g} = ~{a, b, c, d, e, f, g};
    end
endmodule

module dec2_4(
        input [1:0] ain,
        output reg [3:0] aout
        );
        
        always@(ain)
        begin
            case(ain)
                2'b00: aout = 4'b0001;
                2'b01: aout = 4'b0010;
                2'b10: aout = 4'b0100;
                2'b11: aout = 4'b1000;
            endcase
            aout = ~aout;
        end
endmodule

module cnt2(
        input clk,
        output reg [1:0] do
        );       
        always@(posedge clk)
        begin
            if(do <= 2'b11)
                do <= do + 1;
            else
                do <= 2'b00;
        end
endmodule

module top(
        input clk,
        input [15:0] di,
        output a,
        output b,
        output c,
        output d,
        output e,
        output f,
        output g,
        output A1,
        output A2,
        output A3, 
        output A4
        );
        wire [3:0] dig_dec_in;
        wire [1:0] cnt2_out;
        wire clk_divided;
        
        clk_divider clkdiv(
            .clk(clk),
            .clk_out(clk_divided)
            );
        
        cnt2 cnt(
            .clk(clk_divided),
            .do(cnt2_out)
            );
            
        dig_dec digdec(
            .di(dig_dec_in),
            .a(a),
            .b(b),
            .c(c),
            .d(d),
            .e(e),
            .f(f),
            .g(g)
            );
        
        dec2_4 dec(
            .ain(cnt2_out),
            .aout({A1, A2, A3, A4})
            );
            
        assign dig_dec_in = (cnt2_out == 2'b00) ? di[3:0] :
                            (cnt2_out == 2'b01) ? di[7:4] :
                            (cnt2_out == 2'b10) ? di[11:8] :
                            (cnt2_out == 2'b11) ? di[15:12] : 4'bxxxx;
        
endmodule

/*
module tb_top;
    reg clkt;
    reg [15:0] dit;
    wire at, bt, ct, dt, et, ft, gt;
    wire A1t, A2t, A3t, A4t;
    
    top dut(
        .clk(clkt),
        .di(dit),
        .a(at),
        .b(bt),
        .c(ct),
        .d(dt),
        .e(et),
        .f(ft),
        .g(gt),
        .A1(A1t),
        .A2(A2t),
        .A3(A3t),
        .A4(A4t)
        );
        
    initial
        #160 $finish;
        
    initial
    begin
        #0 clkt = 1'b0;
        forever #5 clkt = ~clkt;
    end
    
    initial
        #0 dit = 16'b1000_0100_0010_0000;
        
endmodule
*/
