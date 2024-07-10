`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 10.07.2024 11:53:55
// Design Name: RAM & ROM
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

module RAM(
        input clk,
        input [31:0] DIN,
        input [7:0] ADDR,
        input RW,
        output reg [31:0] OUT
        );
        reg [31:0] ram_content [99:0]; // ONE-HOT lines.
        
        initial begin
            ram_content[0] = 0;
            ram_content[1] = 0;
            ram_content[2] = 0;
            ram_content[3] = 0;
            ram_content[4] = 0;
            ram_content[5] = 0;
            ram_content[6] = 0;
            ram_content[7] = 0;
            ram_content[8] = 0;
            ram_content[9] = 0;
            ram_content[10] = 0;
            ram_content[11] = 0;
            ram_content[12] = 0;
            ram_content[13] = 0;
            ram_content[14] = 0;
            ram_content[15] = 0;
            ram_content[16] = 0;
            ram_content[17] = 0;
            ram_content[18] = 0;
            ram_content[19] = 0;
            ram_content[20] = 0;
            ram_content[21] = 0;
            ram_content[22] = 0;
            ram_content[23] = 0;
            ram_content[24] = 0;
            ram_content[25] = 0;
            ram_content[26] = 0;
            ram_content[27] = 0;
            ram_content[28] = 0;
            ram_content[29] = 0;
            ram_content[30] = 0;
            ram_content[31] = 0;
            ram_content[32] = 0;
            ram_content[33] = 0;
            ram_content[34] = 0;
            ram_content[35] = 0;
            ram_content[36] = 0;
            ram_content[37] = 0;
            ram_content[38] = 0;
            ram_content[39] = 0;
            ram_content[40] = 0;
            ram_content[41] = 0;
            ram_content[42] = 0;
            ram_content[43] = 0;
            ram_content[44] = 0;
            ram_content[45] = 0;
            ram_content[46] = 0;
            ram_content[47] = 0;
            ram_content[48] = 0;
            ram_content[49] = 0;
            ram_content[50] = 0;
            ram_content[51] = 0;
            ram_content[52] = 0;
            ram_content[53] = 0;
            ram_content[54] = 0;
            ram_content[55] = 0;
            ram_content[56] = 0;
            ram_content[57] = 0;
            ram_content[58] = 0;
            ram_content[59] = 0;
            ram_content[60] = 0;
            ram_content[61] = 0;
            ram_content[62] = 0;
            ram_content[63] = 0;
            ram_content[64] = 0;
            ram_content[65] = 0;
            ram_content[66] = 0;
            ram_content[67] = 0;
            ram_content[68] = 0;
            ram_content[69] = 0;
            ram_content[70] = 0;
            ram_content[71] = 0;
            ram_content[72] = 0;
            ram_content[73] = 0;
            ram_content[74] = 0;
            ram_content[75] = 0;
            ram_content[76] = 0;
            ram_content[77] = 0;
            ram_content[78] = 0;
            ram_content[79] = 0;
            ram_content[80] = 0;
            ram_content[81] = 0;
            ram_content[82] = 0;
            ram_content[83] = 0;
            ram_content[84] = 0;
            ram_content[85] = 0;
            ram_content[86] = 0;
            ram_content[87] = 0;
            ram_content[88] = 0;
            ram_content[89] = 0;
            ram_content[90] = 0;
            ram_content[91] = 0;
            ram_content[92] = 0;
            ram_content[93] = 0;
            ram_content[94] = 0;
            ram_content[95] = 0;
            ram_content[96] = 0;
            ram_content[97] = 0;
            ram_content[98] = 0;
            ram_content[99] = 0;
            
            // or use for(integer i = 0; i < 100; i = i + 1) ram_content[i] = 0;
            // but synthesis will not be possible!!!
        end
        
        always@(posedge clk)
            if(RW)
                OUT <= ram_content[ADDR];
            else begin
                OUT <= {32{1'b0}};
                ram_content[ADDR] <= DIN;
            end
endmodule

module ROM(
        input clk,
        input EN,
        output reg [31:0] OUT
        );
        reg [31:0] rom_content [99:0];
        reg [7:0] addr;
        
        initial begin
        addr = 0;
        $readmemb ("rom_content.mem", rom_content);
        end
        
        always@(posedge clk)
            if(EN) begin
                OUT <= rom_content[addr];
                if(addr <= 99)
                    addr = addr + 1;
                else
                    addr = 0;
            end
endmodule

module tb_mem;
    reg clkt;
    reg [31:0] DINt;
    reg [7:0] ADDRt;
    reg RWt;
    wire [31:0] RAMOUT;
    
    reg ENt;
    wire [31:0] ROMOUT;
    
    
    RAM dut_RAM(
        .clk(clkt),
        .DIN(DINt),
        .ADDR(ADDRt),
        .RW(RWt),
        .OUT(RAMOUT)
        );
        
    ROM dut_ROM(
        .clk(clkt),
        .EN(ENt),
        .OUT(ROMOUT)
        );
        
    initial
        #100 $finish;
        
    initial
    begin
        #0 clkt = 1'b0;
        forever #5 clkt = ~clkt;
    end
    
    initial
    begin
        #0 DINt = 0; ADDRt = 100; RWt = 1'b0;
        #10 ADDRt = 1; DINt = 94954;
        #10 RWt = 1'b1;
        #10 ADDRt = 0;
    end
    
    initial
    begin
        #0 ENt = 0;
        #5 ENt = 1;
    end   
endmodule
