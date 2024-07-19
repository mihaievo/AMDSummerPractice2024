`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 12.07.2024 12:30:55
// Design Name: MIPS microprocessor
// Module Name: MIPS_PROC
// Project Name: MIPS microprocessor
// Target Devices: --//--
// Tool Versions: --//--
// Description: 
// 
// Dependencies: None 
// 
// Revision: 1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MIPS_PROC(
        input clk,
        input [11:0] SW_VALUES,
        output [11:0] RD_LADDR,
        output [31:0] VMEM
        );
        
        wire [31:0] IM_CONTENT;
        
        wire [31:0] sign_ext_imm;
        
        wire REGDST, REGWRITE, EXTOP, ALUSRC, MEMWRITE, MEM2REG, PCSRC, PCLOAD;
        wire [3:0] ALUOP;
        
        wire [4:0] REGBNK_RA1;
        wire [4:0] REGBNK_RA2;
        wire [4:0] REGBNK_WA_IN;
        wire [31:0] REGBNK_RD1;
        wire [31:0] REGBNK_RD2;
        wire [31:0] REGBNK_WD;
        
        wire [31:0] ALU_B_IN;
        wire ERR_RESERVED, OF;
        wire ZERO;
        wire [31:0] ALU_OUT;
        
        wire [31:0] DM_OUT; 
        
        // PROGRAM COUNTER LOGIC
        reg [31:0] PC;
        reg RESET_SYS = 1'b0;
        always@(posedge clk) begin
            if(RESET_SYS <= 1'b0) begin
                PC = 0;
                RESET_SYS = 1'b1;
            end
            else begin
            if(PCSRC >= 1'b1)
                PC = PC + 4 + (sign_ext_imm << 2);
            else if (PCLOAD >= 1'b1)
                PC = {PC[31:28], {IM_CONTENT[25:0] << 2}};
            else
                PC = PC + 4;
            end
        end        
       // END PROGRAM COUNTER LOGIC
       
       im im_inst(
            .clk(clk),
            .ADDR(PC),
            .INSTRUCTION(IM_CONTENT)
            );
       
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
            .MEM2REG(MEM2REG),
            .PCSRC(PCSRC),
            .PCLOAD(PCLOAD)
            );     
       
       assign REGBNK_RA1 = IM_CONTENT[25:21];
       assign REGBNK_RA2 = IM_CONTENT[20:16];
       assign REGBNK_WA_IN = (REGDST == 1'b0) ? IM_CONTENT[20:16] : IM_CONTENT[15:11];
       assign REGBNK_WD = (MEM2REG == 1'b0) ? DM_OUT : ALU_OUT;
            
       REG_BANK REG_BANK_inst(
            .clk(clk),
            .REGWRITE(REGWRITE),
            .RA1(REGBNK_RA1),
            .RA2(REGBNK_RA2),
            .WA(REGBNK_WA_IN),
            .WD(REGBNK_WD),
            .RD1(REGBNK_RD1),
            .RD2(REGBNK_RD2)
            ); 
        
        // SIGN EXTENDER LOGIC    
        assign sign_ext_imm = (EXTOP == 1'b1) ? {{16{IM_CONTENT[15]}}, IM_CONTENT[15:0]} : {{16{1'b0}}, IM_CONTENT[15:0]};
        
        assign ALU_B_IN = (ALUSRC == 1'b0) ? REGBNK_RD2 : sign_ext_imm;
        
        ALU ALU_inst(
                .A(REGBNK_RD1),
                .B(ALU_B_IN),
                .OP(ALUOP),
                .ERR_RESERVED(ERR_RESERVED),
                .OF(OF),
                .ZERO(ZERO),
                .O(ALU_OUT)
                );
                        
       dm dm_inst(
            .clk(clk),
            .WD(REGBNK_RD2),
            .SW_LADDR_WD(SW_VALUES),
            .ADDR(ALU_OUT),
            .MEMWRITE(MEMWRITE),
            .RD(DM_OUT),
            .RD_LADDR(RD_LADDR),
            .VMEMORY_CONTENT(VMEM)
            );
endmodule

/*module tb_MIPS_PROC;
    reg clkt;
    reg [11:0] sw_in;
    wire [11:0] led_out;
    
    MIPS_PROC top_dut(
        .clk(clkt),
        .SW_VALUES(sw_in),
        .RD_LADDR(led_out)
        );
        
    initial
        #100 $finish;
    
    initial begin
        #0 clkt = 1'b0;
        forever #5 clkt = ~clkt;
        end
        
    initial begin
        #0 sw_in = 12'b0000_0000_0000;
        forever #10 sw_in = sw_in + 1;
        end
endmodule*/