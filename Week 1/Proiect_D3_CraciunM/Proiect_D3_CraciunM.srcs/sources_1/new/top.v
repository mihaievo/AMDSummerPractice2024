`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 03.07.2024 11:41:08
// Design Name: Clock divider
// Module Name: top
// Project Name: Day 3's work
// Target Devices: --//--
// Tool Versions: --//--
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
        input pl,
        input [15:0] di,
        input EN,
        output reg clk_out,
        output reg [15:0] poscnt,
        output reg [15:0] holdclk
    );       
    
    reg [15:0] data_read;
    reg [15:0] posedge_cnt;
    reg [15:0] hold_clk;
    
    always@(clk or EN)
    begin
        if(pl)
            data_read <= di;
        if(EN)
            if(posedge_cnt >= data_read) begin
                clk_out <= 1'b1;
                hold_clk <= hold_clk + 1;
                if(hold_clk >= data_read - 1) begin
                    posedge_cnt <= 0;
                    hold_clk <= 0;
                end
            end
            else begin
                clk_out <= 1'b0;
                posedge_cnt <= posedge_cnt + 1;
            end
        else begin
            posedge_cnt <= 0;
            clk_out <= 0;
            hold_clk <= 0;
            end
      poscnt <= posedge_cnt;
      holdclk <= hold_clk;
      end           
endmodule

module tb_clkdiv;
        reg clkt;
        reg plt;
        reg [15:0] dit;
        reg ENt;
        wire clk_outt;
        
        wire [15:0] poscntt;
        wire [15:0] holdclkt;
        
        clk_divider dut(
            .clk(clkt),
            .pl(plt),
            .di(dit),
            .EN(ENt),
            .clk_out(clk_outt),
            .poscnt(poscntt),
            .holdclk(holdclkt)
            );
           
        
        initial
            #100 $finish;
        
        initial
        begin
            #0 clkt = 0;
            forever #5 clkt = ~clkt;
        end
        
        initial
        begin
            #0 dit = 16'h0003; plt = 1'b1; ENt = 1'b0;
            #10 plt = 1'b0; ENt = 1'b1;
        end
endmodule
