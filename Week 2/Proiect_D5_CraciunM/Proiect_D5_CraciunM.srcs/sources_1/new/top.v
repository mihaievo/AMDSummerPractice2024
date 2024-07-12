`timescale 1ns / 1ps

module top(
        input clk
        );
        
        wire [31:0] IM_CONTENT;
        
        // PROGRAM COUNTER LOGIC
        reg [31:0] PC = -4;
        always@(posedge clk)
            PC = PC + 4;        
       // END PROGRAM COUNTER LOGIC
       
       im im_inst(
            .clk(clk),
            .ADDR(PC),
            .INSTRUCTION(IM_CONTENT)
            );
            
       wire REGDST, REGWRITE, EXTOP, ALUSRC, MEMWRITE, MEM2REG;
       wire [3:0] ALUOP;
       
       wire ZERO;
       
       control MAIN_CONTROL_inst(
            .OPCODE(IM_CONTENT[31:26]),
            .FUNCT(IM_CONTENT[5:0]),
            .ZERO(ZERO),
            .REGDST(REGDST),
            .REGWRITE(REGWRITE),
            .EXTOP(EXTOP),
            .ALUSRC(ALUSRC),
            .ALUOP(ALUOP),
            .MEMWRITE(MEMWRITE),
            .MEM2REG(MEM2REG)
            );     
       
       wire [4:0] REGBNK_WA_IN = (REGDST == 1'b0) ? IM_CONTENT[20:16] : IM_CONTENT[15:11];
       wire [31:0] REGBNK_RD1;
       wire [31:0] REGBNK_RD2;
       wire [31:0] REGBNK_WD;
            
       REG_BANK REG_BANK_inst(
            .clk(clk),
            .REGWRITE(REGWRITE),
            .RA1(IM_CONTENT[25:21]),
            .RA2(IM_CONTENT[20:16]),
            .WA(REGBNK_WA_IN),
            .WD(REGBNK_WD),
            .RD1(REGBNK_RD1),
            .RD2(REGBNK_RD2)
            ); 
        
        // SIGN EXTENDER LOGIC    
        wire [31:0] sign_ext_imm = (EXTOP == 1'b1) ? {{16{IM_CONTENT[15]}}, IM_CONTENT[15:0]} : {{16{1'b0}}, IM_CONTENT[15:0]};
        
        wire [31:0] ALU_B_IN = (ALUSRC == 1'b0) ? REGBNK_RD2 : sign_ext_imm;
        
        wire ERR_RESERVED, OF;
        wire [31:0] ALU_OUT;
        
        ALU ALU_inst(
                .A(REGBNK_RD1),
                .B(ALU_B_IN),
                .OP(ALUOP),
                .ERR_RESERVED(ERR_RESERVED),
                .OF(OF),
                .ZERO(ZERO),
                .O(ALU_OUT)
                );
                
       wire [31:0] DM_OUT;         
       dm dm_inst(
            .clk(clk),
            .WD(REGBNK_RD2),
            .ADDR(ALU_OUT),
            .MEMWRITE(MEMWRITE),
            .RD(DM_OUT)
            );
            
      assign REGBNK_WD = (MEM2REG == 1'b0) ? DM_OUT : ALU_OUT;
      
endmodule

module tb_top;
    reg clkt;
    
    top top_dut(
        .clk(clkt)
        );
        
    initial
        #150 $finish;
    
    initial begin
        #0 clkt = 1'b0;
        forever #5 clkt = ~clkt;
        end
endmodule