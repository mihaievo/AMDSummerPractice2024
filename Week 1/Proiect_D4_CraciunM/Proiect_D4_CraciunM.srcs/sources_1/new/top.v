`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 04.07.2024 12:29:21
// Design Name: LED blackboard testing
// Module Name: top
// Project Name: --//--
// Target Devices: xc7z007sclg400-1
// Tool Versions: --//--
// Description: --//--
// 
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CBB_D(
        input clk,
        input D,
        output reg Q
        );
        always@(posedge clk)
            Q <= D;
endmodule


/*module top(
        input clk,
        input SW,
        output LED
        );
        
        CBB_D dut(
            .clk(clk),
            .D(sw[0]),
            .Q(led[0])
            ); 
            
endmodule*/