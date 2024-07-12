// instruction memory (ROM)
module im(
        input clk,
        input [31:0] ADDR,
        output reg [31:0] INSTRUCTION
        );
        
        reg [31:0] rom_content [255:0];
        
        initial begin
            $readmemb ("rom_content.mem", rom_content);
        end
        
        always@(posedge clk)
                if(ADDR <= 255) // maximum of 255 instructions
                    INSTRUCTION <= rom_content[ADDR];
                else
                    INSTRUCTION <= 32'hffff;
endmodule