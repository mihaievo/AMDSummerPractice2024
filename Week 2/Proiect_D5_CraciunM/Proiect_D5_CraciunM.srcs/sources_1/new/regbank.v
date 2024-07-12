module reg_n#(parameter DATA_WIDTH=32) (
        input clk,
        input pl,
        input [DATA_WIDTH - 1:0] di,
        output reg [DATA_WIDTH - 1:0] do
        );
        always@(di)
            if(pl)
                do <= di;
endmodule

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
        
        wire pl_RD1 = (WA == 5'b00000) ? 1'b1 : 1'b0; 
        wire pl_RD2 = (WA == 5'b00001) ? 1'b1 : 1'b0;
        
        reg_n#(32) RD1_inst(
                .clk(clk),
                .pl(pl_RD1 & REGWRITE),
                .di(WD),
                .do(RD1)
                );
                
         reg_n#(32) RD2_inst(
                .clk(clk),
                .pl(pl_RD2 & REGWRITE),
                .di(WD),
                .do(RD2)
                );
                
endmodule