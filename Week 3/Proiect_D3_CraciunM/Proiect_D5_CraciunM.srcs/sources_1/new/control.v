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
        output reg MEM2REG,
        output reg PCSRC,
        output reg PCLOAD
        );
        always@(OPCODE or FUNCT or ZERO)
            casex({OPCODE, FUNCT}) // add ZERO here for use with branch instructions later
            // ADD
            12'b000000_100000: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b1_1_0_0_0000_0_1_0_0;
            // SUB
            12'b000000_100010:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b1_1_0_0_0001_0_1_0_0;  
            // AND
            12'b000000_100100: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b1_1_0_0_0011_0_1_0_0;
            // OR
            12'b000000_100101: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b1_1_0_0_0100_0_1_0_0;
            // SLT
            12'b000000_101010: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b1_1_0_0_0101_0_1_0_0;
            // ADDI - we take imm from instruction so we need extension.
            12'b001000_xxxxxx: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b0_1_1_1_0000_0_1_0_0;
            // SW instruction: SW $source register's address, offset($destination register's address).
            12'b101011_xxxxxx:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b0_0_0_1_0000_1_0_0_0;
            // LW instruction: LW $destination register's address, offset($source register's address).
            12'b100011_xxxxxx:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b0_1_0_1_0000_0_0_0_0;
            // BEQ instruction: BEQ $first source register's address, $second source register's address, branch value.
            12'b000100_xxxxxx:
                 {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = {10'b0_0_1_0_0110_0_1, ZERO, 1'b0};
            // J instruction: J address. (26 bits)
            12'b000010_xxxxxx:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b0_0_0_0_0000_0_0_0_1;
            default:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC, PCLOAD} = 12'b0_0_0_0_0000_0_0_0_0;
            endcase
endmodule