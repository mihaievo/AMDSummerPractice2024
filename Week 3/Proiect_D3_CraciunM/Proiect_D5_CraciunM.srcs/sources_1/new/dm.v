// data memory
module dm(
        input clk,
        input [31:0] WD,
        input [31:0] ADDR,
        input [11:0] SW_LADDR_WD, // will act as last address data in.
        input MEMWRITE,
        input BTN_LADDR_MEMWRITE, // this will act as MEMWRITE for the last address in memory.
        output [31:0] RD,
        output [11:0] RD_LADDR // will output last 12 bits of the content at the last address in memory.
        );
        reg [31:0] ram_content [255:0]; // ONE-HOT lines.
        
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
        ram_content[100] = 0;
        ram_content[101] = 0;
        ram_content[102] = 0;
        ram_content[103] = 0;
        ram_content[104] = 0;
        ram_content[105] = 0;
        ram_content[106] = 0;
        ram_content[107] = 0;
        ram_content[108] = 0;
        ram_content[109] = 0;
        ram_content[110] = 0;
        ram_content[111] = 0;
        ram_content[112] = 0;
        ram_content[113] = 0;
        ram_content[114] = 0;
        ram_content[115] = 0;
        ram_content[116] = 0;
        ram_content[117] = 0;
        ram_content[118] = 0;
        ram_content[119] = 0;
        ram_content[120] = 0;
        ram_content[121] = 0;
        ram_content[122] = 0;
        ram_content[123] = 0;
        ram_content[124] = 0;
        ram_content[125] = 0;
        ram_content[126] = 0;
        ram_content[127] = 0;
        ram_content[128] = 0;
        ram_content[129] = 0;
        ram_content[130] = 0;
        ram_content[131] = 0;
        ram_content[132] = 0;
        ram_content[133] = 0;
        ram_content[134] = 0;
        ram_content[135] = 0;
        ram_content[136] = 0;
        ram_content[137] = 0;
        ram_content[138] = 0;
        ram_content[139] = 0;
        ram_content[140] = 0;
        ram_content[141] = 0;
        ram_content[142] = 0;
        ram_content[143] = 0;
        ram_content[144] = 0;
        ram_content[145] = 0;
        ram_content[146] = 0;
        ram_content[147] = 0;
        ram_content[148] = 0;
        ram_content[149] = 0;
        ram_content[150] = 0;
        ram_content[151] = 0;
        ram_content[152] = 0;
        ram_content[153] = 0;
        ram_content[154] = 0;
        ram_content[155] = 0;
        ram_content[156] = 0;
        ram_content[157] = 0;
        ram_content[158] = 0;
        ram_content[159] = 0;
        ram_content[160] = 0;
        ram_content[161] = 0;
        ram_content[162] = 0;
        ram_content[163] = 0;
        ram_content[164] = 0;
        ram_content[165] = 0;
        ram_content[166] = 0;
        ram_content[167] = 0;
        ram_content[168] = 0;
        ram_content[169] = 0;
        ram_content[170] = 0;
        ram_content[171] = 0;
        ram_content[172] = 0;
        ram_content[173] = 0;
        ram_content[174] = 0;
        ram_content[175] = 0;
        ram_content[176] = 0;
        ram_content[177] = 0;
        ram_content[178] = 0;
        ram_content[179] = 0;
        ram_content[180] = 0;
        ram_content[181] = 0;
        ram_content[182] = 0;
        ram_content[183] = 0;
        ram_content[184] = 0;
        ram_content[185] = 0;
        ram_content[186] = 0;
        ram_content[187] = 0;
        ram_content[188] = 0;
        ram_content[189] = 0;
        ram_content[190] = 0;
        ram_content[191] = 0;
        ram_content[192] = 0;
        ram_content[193] = 0;
        ram_content[194] = 0;
        ram_content[195] = 0;
        ram_content[196] = 0;
        ram_content[197] = 0;
        ram_content[198] = 0;
        ram_content[199] = 0;
        ram_content[200] = 0;
        ram_content[201] = 0;
        ram_content[202] = 0;
        ram_content[203] = 0;
        ram_content[204] = 0;
        ram_content[205] = 0;
        ram_content[206] = 0;
        ram_content[207] = 0;
        ram_content[208] = 0;
        ram_content[209] = 0;
        ram_content[210] = 0;
        ram_content[211] = 0;
        ram_content[212] = 0;
        ram_content[213] = 0;
        ram_content[214] = 0;
        ram_content[215] = 0;
        ram_content[216] = 0;
        ram_content[217] = 0;
        ram_content[218] = 0;
        ram_content[219] = 0;
        ram_content[220] = 0;
        ram_content[221] = 0;
        ram_content[222] = 0;
        ram_content[223] = 0;
        ram_content[224] = 0;
        ram_content[225] = 0;
        ram_content[226] = 0;
        ram_content[227] = 0;
        ram_content[228] = 0;
        ram_content[229] = 0;
        ram_content[230] = 0;
        ram_content[231] = 0;
        ram_content[232] = 0;
        ram_content[233] = 0;
        ram_content[234] = 0;
        ram_content[235] = 0;
        ram_content[236] = 0;
        ram_content[237] = 0;
        ram_content[238] = 0;
        ram_content[239] = 0;
        ram_content[240] = 0;
        ram_content[241] = 0;
        ram_content[242] = 0;
        ram_content[243] = 0;
        ram_content[244] = 0;
        ram_content[245] = 0;
        ram_content[246] = 0;
        ram_content[247] = 0;
        ram_content[248] = 0;
        ram_content[249] = 0;
        ram_content[250] = 0;
        ram_content[251] = 0;
        ram_content[252] = 0;
        ram_content[253] = 0;
        ram_content[254] = 0;
        ram_content[255] = 0;
        end
        
        always@(posedge clk)
            if(MEMWRITE) begin
                ram_content[ADDR] <= WD;
                // we write in offsets of 32 bits, so
                // we ignore bits 0 and 1 (division by 4)
                // we can also store with offset using this instruction.
                // basically, RAM[OFFSET/4 << 2*OFFSET%4] = value. 
                //{ram_content[ADDR[31:2] + 1], ram_content[ADDR[31:2]]} <= ((WD << ADDR[1:0]) << ADDR[1:0]);
            end
                else if (BTN_LADDR_MEMWRITE) begin
                    ram_content[255] <= {20'b0, SW_LADDR_WD};
            end
        
        // we can also load with offset using this.
        //wire [63:0] auxreg_lwoffset;
        //assign auxreg_lwoffset = (({ram_content[ADDR[31:2] + 1], ram_content[ADDR[31:2]]} >> ADDR[1:0]) >> ADDR[1:0]); 
            
        assign RD = (MEMWRITE <= 1'b1) ? ram_content[ADDR]
                    //auxreg_lwoffset[31:0]
                    : {32{1'bx}};
                    
        assign RD_LADDR = ram_content[255][11:0];
endmodule

/*
module tb_dm;
    reg clk;
    reg [31:0] WD;
    reg [31:0] ADDR;
    reg MEMWRITE;
    wire [31:0] RD;
    
    dm dm_dut(
        .clk(clk),
        .WD(WD),
        .ADDR(ADDR),
        .MEMWRITE(MEMWRITE),
        .RD(RD)
        );
        
        initial
            #100 $finish;
            
        initial begin
            #0 clk = 1'b0;
            forever #5 clk = ~clk;
            end
endmodule*/

