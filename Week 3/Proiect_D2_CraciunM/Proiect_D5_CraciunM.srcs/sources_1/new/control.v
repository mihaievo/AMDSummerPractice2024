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
        output reg PCSRC
        );
        always@(OPCODE or FUNCT or ZERO)
            casex({OPCODE, FUNCT}) // add ZERO here for use with branch instructions later
            // ADD
            12'b000000_100000: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b1_1_0_0_0000_0_1_x;
            // SUB
            12'b000000_100010:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b1_1_0_0_0001_0_1_x;  
            // AND
            12'b000000_100100: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b1_1_0_0_0011_0_1_x;
            // OR
            12'b000000_100101: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b1_1_0_0_0100_0_1_x;
            // SLT
            12'b000000_101010: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b1_1_0_0_0101_0_1_x;
            // ADDI - we take imm from instruction so we need extension.
            12'b001000_xxxxxx: 
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b0_1_1_1_0000_0_1_x;
            // SW instruction: SW $source register's address, offset($destination register's address).
            12'b101011_xxxxxx:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b0_0_0_1_0000_1_x;
            // LW instruction: LW $destination register's address, offset($source register's address).
            12'b100011_xxxxxx:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'b0_1_0_1_0000_0_0_x;
            // BEQ instruction: BEQ $first source register's address, $second source register's address, branch value.
            12'b000100_xxxxxx:
                 {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = {10'b0_0_1_0_0110_0_1, ZERO};
            default:
                {REGDST, REGWRITE, EXTOP, ALUSRC, ALUOP, MEMWRITE, MEM2REG, PCSRC} = 11'bx_x_x_x_xxxx_x_x_x;
            endcase
endmodule