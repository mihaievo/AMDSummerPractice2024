module ALU #(parameter DATA_WIDTH = 32)(
        input [DATA_WIDTH - 1:0] A,
        input [DATA_WIDTH - 1:0] B,
        input [3:0] OP,
        output reg ERR_RESERVED,
        output reg OF, // overflow / underflow bit : if set such error happened
        output reg ZERO, // returns 1 if logical expression is true
        output reg [DATA_WIDTH - 1:0] O
    );
    
    always@(A or B or OP)
        case(OP)
            4'b0000: begin 
                        {OF, O} = A + B;
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0001: begin
                        {OF, O} = A + (~B + 1); // A - B
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0011: begin
                        O = A & B; // A and B
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0100: begin
                        O = A | B; // A or B
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                    end
            4'b0101: begin
                        ZERO = (A < B) ? 1'b1 : 1'b0; // SLT
                        O = {32{1'bx}};
                        ERR_RESERVED = 1'b0;
                    end
            default:  begin
                            ERR_RESERVED = 1'b1;
                            ZERO = 1'b0;
                            OF = 1'b0;
                            O = {DATA_WIDTH{1'b0}};
                      end
        endcase
endmodule