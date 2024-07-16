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

module dec_debug( // this module will act as a selection for debug
        input [2:0] ain,
        output reg [1:0] aout
        );
        
        always@(ain)
        begin
            case(ain)
                3'b000: aout = 2'b00; // alu_out
                3'b100: aout = 2'b01; // a
                3'b010: aout = 2'b10; // b
                3'b001: aout = 2'b11; // op
                default: aout = 2'b00; // defaults to alu_out
            endcase
        end 
endmodule

module dec_errf( // this module will act as SEGMENT 0 from the LED display
        input [2:0] ain,
        output reg [3:0] aout
        );
        always@(ain)
            case(ain)
                3'b100: aout = 4'b1110; // 14 (E)
                3'b010: aout = 4'b1000; // 8 (OF)
                3'b001: aout = 4'b0010; // 2 (Z)
                default: aout = 4'b0000; // 0 (OK)
            endcase
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