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
        output reg [15:0] poscnt
    );       
    
    reg [15:0] data_read;
    reg [15:0] posedge_cnt;
    
    always@(clk or EN)
    begin
        if(pl) begin
            data_read <= di;
            posedge_cnt <= 0; // we reset the counter
            clk_out <= 0; // we also reset clk_out (we want to start over)
        end
        else if(EN) begin
            // if we held the clock for data_read times, we reset it and negate clk.
            if(posedge_cnt >= (data_read - 1)) begin
                posedge_cnt <= 0;
                clk_out <= ~clk_out; // we switch the clock on or off when we reached data_read times.
            end
                else // otherwise, we increment the counter.
                    posedge_cnt <= posedge_cnt + 1;
         end
         // we add a debug option, however we could remove it and just add it in 
         // waveform view : scope > dut > poscnt(in objects window) > rclick >
         // add to wave window > relaunch simulation.
         poscnt = posedge_cnt;
    end           
endmodule

module tb_clkdiv;
        reg clkt;
        reg plt;
        reg [15:0] dit;
        reg ENt;
        wire clk_outt;
        
        wire [15:0] poscntt;
        
        clk_divider dut(
            .clk(clkt),
            .pl(plt),
            .di(dit),
            .EN(ENt),
            .clk_out(clk_outt),
            .poscnt(poscntt)
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
