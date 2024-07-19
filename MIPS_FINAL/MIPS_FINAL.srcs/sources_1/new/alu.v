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
            // 4'b0010 - we will reserve for multiplication implementation.
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
                        ZERO = (A < B) ? 1'b1 : 1'b0; // SLT - set less than
                        O = {{31{1'b0}}, ZERO};
                        ERR_RESERVED = 1'b0;
                    end
            4'b0110: begin
                        ZERO = (A == B) ? 1'b1 : 1'b0; // SEQ - set if equal
                        O = {{31{1'b0}}, ZERO};
                        ERR_RESERVED = 1'b0;
                    end
            4'b0111: begin
                        ZERO = (A != B) ? 1'b1 : 1'b0; // SNE - set if not equal
                        O = {{31{1'b0}}, ZERO};
                        ERR_RESERVED = 1'b0;
                    end
            4'b1000: begin
                        ZERO = 1'b0;
                        {OF, O} = A << B; // SHL - shift left
                        ERR_RESERVED = 1'b0;
                    end
            4'b1001: begin
                        ZERO = 1'b0;
                        O = A >> B; // SHR - shift right
                        ERR_RESERVED = 1'b0;
                    end
            /*4'b1010: begin
                        ZERO = 1'b0;
                        O = ~(A | B); // NOR
                        ERR_RESERVED = 1'b0;
                    end*/                             
            default:  begin
                            ERR_RESERVED = 1'b1;
                            ZERO = 1'b0;
                            OF = 1'b0;
                            O = {DATA_WIDTH{1'b0}};
                      end
        endcase
endmodule