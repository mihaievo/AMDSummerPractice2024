// this module codificates the anodes of each display digit as a whole.
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