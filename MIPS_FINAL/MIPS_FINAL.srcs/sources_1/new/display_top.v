module display_top(
        input clk,
        input [31:0] di,
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
        
        reg [31:0] rot_reg; // this will be the value to be displayed, but we will rotate it continuously.
        reg [2:0] rotation_counter; // this will be the counter at which the the register will be updated with di.
        
        wire [3:0] dig_dec_in; // this will be the input to the digital decoder for the display.
                               // this sets the active segments of the 7-segment display digit.
                               
        wire [1:0] cnt2_out; // this will be the output of the 2 bit counter.
                             // this cycles through the selected display segment to be updated.
        
        wire clk_div_display; // this will determine the refresh rate of the display.
        wire clk_div_rotate; // this will determine the rotation speed of the display, since we can only display 16 bits at a time.
        
        wire [15:0] din_main; // this will be the input to the leds at the current posedge of the divided clock.
        
        // we want 60hz, if board internal clock is 33.33MHz we divide this value by 60 * 4 to reduce flicker
        localparam disp_div_amount = 138875; // 33.33 MHz * 1 second -> faster: divide this value -> currently about 240hz - SIM WITH 1 or so.
        
        // the display will be rotated at about 60hz.
        localparam rot_div_amount = 555500; // 4 times slower than the display refresh rate : SIMULATE WITH 4x disp_div_amount
        
        initial
            rotation_counter = 0;
        
        clk_divider clkdiv_disp(
            .clk(clk),
            .di(disp_div_amount),
            .clk_out(clk_div_display)
            );    
        
        clk_divider clkdiv_rot(
            .clk(clk),
            .di(rot_div_amount),
            .clk_out(clk_div_rotate)
            );
               
        cnt2 cnt(
            .clk(clk_div_display),
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
        
        always @(posedge clk_div_rotate) begin
            if (rotation_counter <= 3'd0) begin
                rotation_counter <= 3'd4; // Reset counter after full rotation cycle
                rot_reg <= di; // update with new input data - only after rotation is complete
            end else begin
                rotation_counter <= rotation_counter - 1; // decrement counter
                rot_reg <= {rot_reg[3:0], rot_reg[31:4]}; // rotate right by 4 bits
            end
        end
        
        assign din_main = rot_reg[15:0]; // this is the current display value.
            
        assign dig_dec_in = (cnt2_out == 2'b00) ? din_main[3:0] :
                            (cnt2_out == 2'b01) ? din_main[7:4] :
                            (cnt2_out == 2'b10) ? din_main[11:8] :
                            (cnt2_out == 2'b11) ? din_main[15:12] : 4'bxxxx;
        
endmodule

/*`timescale 1ns/1ps

module tb_display_top;

    reg clk;
    reg [31:0] di;
    wire a, b, c, d, e, f, g;
    wire A1, A2, A3, A4;
    
    display_top dut (
        .clk(clk),
        .di(di),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial
        #1000 $finish;
    
    initial begin
        di = 32'h12345678;
        #355 di = 32'hdeadbeef;
    end
    
endmodule*/
