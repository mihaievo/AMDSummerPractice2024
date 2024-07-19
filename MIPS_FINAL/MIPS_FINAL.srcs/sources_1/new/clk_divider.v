module clk_divider(
    input clk,
    input [31:0] di,
    output reg clk_out
);

    reg [31:0] counter; 
    
    initial begin
        clk_out = 0;
        counter = 0;
    end
    
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