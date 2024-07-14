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
        
        // to actually index rom content by multiples of 4 
        // we must divide PC by 4, so we ignore bit 1 and 0
        // so, we index via multiples of 4.
        always@(posedge clk)
                if(ADDR[31:2] <= 255) // maximum of 255 instructions
                    INSTRUCTION <= rom_content[ADDR[31:2]];
                else
                    INSTRUCTION <= 32'hffff;
endmodule