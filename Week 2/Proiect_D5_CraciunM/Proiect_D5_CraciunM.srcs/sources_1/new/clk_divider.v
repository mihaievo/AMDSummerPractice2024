module clk_divider(
    input clk,
    output reg clk_out
);
    // we want 60hz, if clock is 33.33MHz we divide this value by 60 * 4 to reduce flicker
    localparam di = 138875; // 33.33 MHz * 1 second -> faster: divide this value
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