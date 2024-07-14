module REG_BANK(
        input clk,
        input REGWRITE,
        input [4:0] RA1, // rs1
        input [4:0] RA2, // rs2
        input [4:0] WA, // rd (write address, in this case addr of reg)
        input [31:0] WD, // write data (what we take from memory)
        output [31:0] RD1, // output of RD1
        output [31:0] RD2 // output of RD2
        );
        
        // we will use these as parallel load for each register.
        
        reg [31:0] REGCONTENT[31:0]; // 32 registers
        
        initial begin
            REGCONTENT[0] = 0; // zero
            REGCONTENT[1] = 0; // at 
            REGCONTENT[2] = 0; // v0
            REGCONTENT[3] = 0; // v1
            REGCONTENT[4] = 0; // a0
            REGCONTENT[5] = 0; // a1
            REGCONTENT[6] = 0; // a2
            REGCONTENT[7] = 0; // a3
            REGCONTENT[8] = 0; // t0
            REGCONTENT[9] = 0; // t1
            REGCONTENT[10] = 0; // t2
            REGCONTENT[11] = 0; // t3
            REGCONTENT[12] = 0; // t4
            REGCONTENT[13] = 0; // t5
            REGCONTENT[14] = 0; // t6
            REGCONTENT[15] = 0; // t7
            REGCONTENT[16] = 0; // t8
            REGCONTENT[17] = 0; // t9
            REGCONTENT[18] = 0; // s0
            REGCONTENT[19] = 0; // s1
            REGCONTENT[20] = 0; // s2
            REGCONTENT[21] = 0; // s3
            REGCONTENT[22] = 0; // s4
            REGCONTENT[23] = 0; // s5
            REGCONTENT[24] = 0; // s6
            REGCONTENT[25] = 0; // s7
            REGCONTENT[26] = 0; // k0
            REGCONTENT[27] = 0; // k1
            REGCONTENT[28] = 0; // gp
            REGCONTENT[29] = 0; // sp
            REGCONTENT[30] = 0; // fp
            REGCONTENT[31] = 0; // ra
        end
        
        always@(posedge clk)
            if(WA >= 5'b00001)
                REGCONTENT[WA] <= WD;
        
        assign RD1 = REGCONTENT[RA1];
        assign RD2 = REGCONTENT[RA2];
                
endmodule