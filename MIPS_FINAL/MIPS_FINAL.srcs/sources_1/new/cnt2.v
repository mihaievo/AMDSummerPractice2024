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