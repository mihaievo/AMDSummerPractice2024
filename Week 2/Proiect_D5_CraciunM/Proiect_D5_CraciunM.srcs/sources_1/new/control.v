module control(
        input [5:0] OPCODE,
        input [5:0] FUNCT,
        input ZERO,
        output reg REGDST,
        output reg REGWRITE,
        output reg EXTOP,
        output reg ALUSRC,
        output reg [3:0] ALUOP,
        output reg MEMWRITE,
        output reg MEM2REG
        );
        always@(OPCODE or FUNCT or ZERO)
            case({OPCODE, FUNCT, ZERO}) // add ZERO here for use with branch instructions later
            // ADD
            13'b000000_100000_x: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_0_0_0000_0_1;
            // SUB
            13'b000000_100010_x:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_0_0_0001_0_1;  
            // AND
            13'b000000_100100_x: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_0_0_0011_0_1;
            // OR
            13'b000000_100101_x: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_0_0_0100_0_1;
            // SLT
            13'b000000_101010_x: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_0_0_0101_0_1;
            // ADDI - we take imm from instruction so we need extension.
            13'b001000_xxxxxx_x: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG} = 10'b1_1_1_1_0000_0_1;    
            endcase
endmodule