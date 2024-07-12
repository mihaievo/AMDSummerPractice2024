`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: AMD
// Engineer: Craciun Mihai
// 
// Create Date: 08.07.2024 11:09:09
// Design Name: Calculator with ROM
// Module Name: top
// Project Name: Day 4's work : week 2
// Target Devices: xc7z007sclg400-1
// Tool Versions: --/--
// Description: 
// 
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_divider(
    input clk,
    output reg clk_out
);
    // we want 60hz, if clock is 33.33MHz we divide this value by 60 * 4 to reduce flicker
    localparam di = 138875; // 33.33 MHz * 1 second -> faster: divide this value
    reg [31:0] counter;  
    always @(posedge clk)
    begin
        if (counter >= di - 1) begin
            counter <= 0;
            clk_out <= ~clk_out; // toggle clk_out every di clock cycles
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module reg_n#(parameter DATA_WIDTH=12) (
        input pl,
        input [DATA_WIDTH - 1:0] di,
        output reg [DATA_WIDTH - 1:0] do
        );
        always@(di)
            if(pl)
                do <= di;
endmodule

module ALU #(parameter DATA_WIDTH = 12)(
        input [DATA_WIDTH - 1:0] A,
        input [DATA_WIDTH - 1:0] B,
        input [3:0] OP,
        output reg ERR_RESERVED,
        output reg OF, // overflow / underflow bit : if set such error happened
        output reg ZERO, // returns 1 if logical expression is true
        output reg [DATA_WIDTH - 1:0] O
    );
    
    always@(A or B or OP)
        case(OP)
            4'b0000: begin 
                        {OF, O} = A + B;
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0001: begin
                        {OF, O} = A + (~B + 1); // A - B
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0010: begin
                        {OF, O} = A << B; // we will consider OF as CY out
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0011: begin
                        O = A >> B; // we could do the same here
                        ZERO = 1'b0;
                        ERR_RESERVED = 1'b0;
                     end
            4'b0100: begin 
                        ZERO = (A == B) ? 1'b1 : 1'b0; // if we want O = {{DATA_WIDTH - 1{1'b0}}, 1'b1} : {DATA_WIDTH{1'b0}};
                        OF = 1'b0;
                        ERR_RESERVED = 1'b0;
                        O = {DATA_WIDTH{1'b0}};
                     end
            4'b0101: begin
                        ZERO = (A > B) ? 1'b1 : 1'b0; 
                        OF = 1'b0;
                        ERR_RESERVED = 1'b0;
                        O = {DATA_WIDTH{1'b0}};
                     end
            4'b0110: begin
                        ZERO = (A < B) ? 1'b1 : 1'b0;
                        OF = 1'b0;
                        ERR_RESERVED = 1'b0;
                        O = {DATA_WIDTH{1'b0}};
                     end
            default:  begin
                            ERR_RESERVED = 1'b1;
                            ZERO = 1'b0;
                            OF = 1'b0;
                            O = {DATA_WIDTH{1'b0}};
                      end
        endcase
endmodule

module dig_dec(
        input [3:0] di,
        output reg a,
        output reg b,
        output reg c,
        output reg d,
        output reg e,
        output reg f,
        output reg g
    );
    // we code the led display (from left to right)
    //  __  a
    // |  | f and b
    //  --    g
    // |  |  e and c
    //  __    d
    always@(di)
    begin
            case(di)                              //abcdefg
                4'b0000: {a, b, c, d, e, f, g} = 7'b1111110; // 0 -> a, b, c, d, e, f
                4'b0001: {a, b, c, d, e, f, g} = 7'b0110000; // 1 -> b, c
                4'b0010: {a, b, c, d, e, f, g} = 7'b1101101; // 2 -> a, b, d, e, g
                4'b0011: {a, b, c, d, e, f, g} = 7'b1111001; // 3 -> a, b, c, d, g 
                4'b0100: {a, b, c, d, e, f, g} = 7'b0110011; // 4 -> b, c, f, g
                4'b0101: {a, b, c, d, e, f, g} = 7'b1011011; // 5 -> a, c, d, f, g
                4'b0110: {a, b, c, d, e, f, g} = 7'b1011111; // 6 -> a, f, g, c, d, e
                4'b0111: {a, b, c, d, e, f, g} = 7'b1110000; // 7 -> a, b, c
                4'b1000: {a, b, c, d, e, f, g} = 7'b1111111; // 8 -> a, b, c, d, e, f, g
                4'b1001: {a, b, c, d, e, f, g} = 7'b1111011; // 9 -> a, b, c, d, f, g
                4'b1010: {a, b, c, d, e, f, g} = 7'b1110111; // 10 (A) -> a, b, c, e, f, g
                4'b1011: {a, b, c, d, e, f, g} = 7'b0011111; // 11 (b) -> f, g, c, d, e
                4'b1100: {a, b, c, d, e, f, g} = 7'b0001101; // 12 (c) -> d, e, g
                4'b1101: {a, b, c, d, e, f, g} = 7'b0111101; // 13 (d) -> b, c, d, e, g
                4'b1110: {a, b, c, d, e, f, g} = 7'b1001111; // 14 (E) -> a, d, e, f, g
                4'b1111: {a, b, c, d, e, f, g} = 7'b1000111; // 15 (F) -> a, e, f, g 
                default: {a, b, c, d, e, f, g} = 7'b0000001; // - (err) -> g
        endcase
        {a, b, c, d, e, f, g} = ~{a, b, c, d, e, f, g};
    end
endmodule

module dec2_4(
        input [1:0] ain,
        output reg [3:0] aout
        );
        
        always@(ain)
        begin
            case(ain)
                2'b00: aout = 4'b0001;
                2'b01: aout = 4'b0010;
                2'b10: aout = 4'b0100;
                2'b11: aout = 4'b1000;
            endcase
            aout = ~aout;
        end
endmodule

module dec_debug( // this module will act as a selection for debug
        input [2:0] ain,
        output reg [1:0] aout
        );
        
        always@(ain)
        begin
            case(ain)
                3'b000: aout = 2'b00; // alu_out
                3'b100: aout = 2'b01; // a
                3'b010: aout = 2'b10; // b
                3'b001: aout = 2'b11; // op
                default: aout = 2'b00; // defaults to alu_out
            endcase
        end 
endmodule

module dec_errf( // this module will act as SEGMENT 0 from the LED display
        input [2:0] ain,
        output reg [3:0] aout
        );
        always@(ain)
            case(ain)
                3'b100: aout = 4'b1110; // 14 (E)
                3'b010: aout = 4'b1000; // 8 (OF)
                3'b001: aout = 4'b0010; // 2 (Z)
                default: aout = 4'b0000; // 0 (OK)
            endcase
endmodule

module cnt2(
        input clk,
        output reg [1:0] do
        );       
        always@(posedge clk)
        begin
            if(do <= 2'b11)
                do <= do + 1;
            else
                do <= 2'b00;
        end
endmodule

module RAM(
        input clk,
        input [31:0] DIN,
        input [7:0] ADDR,
        input RW,
        output reg [31:0] OUT
        );
        reg [31:0] ram_content [99:0]; // ONE-HOT lines.
        
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
            
            // or use for(integer i = 0; i < 100; i = i + 1) ram_content[i] = 0;
            // but synthesis will not be possible!!!
        end
        
        always@(posedge clk)
            if(RW)
                OUT <= ram_content[ADDR];
            else begin
                OUT <= {32{1'b0}};
                ram_content[ADDR] <= DIN;
            end
endmodule

module ROM(
        input clk,
        input EN,
        output reg [31:0] OUT
        );
        reg [31:0] rom_content [99:0];
        reg [7:0] addr;
        
        initial begin
        addr = 0;
        $readmemb ("rom_content.mem", rom_content);
        end
        
        always@(posedge clk)
            if(EN) begin
                OUT <= rom_content[addr];
                if(addr <= 99) // maximum of 100 instructions
                    addr = addr + 1;
                else
                    addr = 0;
            end
endmodule

module one_period(
        input clk,
        input in,
        output out
        );
        
   reg [1:0] cs;
   reg [1:0] ns;
   
   always@(posedge clk)
        cs <= ns;
        
   always@(cs or in)
        case({cs, in}) // we treat the case in which the clock is very fast.
            3'b00_0 : ns = 2'b00; // state 0: button is not pressed
            3'b00_1 : ns = 2'b01; // we press the button, we enter the state in which we should execute
            3'b01_0 : ns = 2'b00; // if we release, we return in state 0
            3'b01_1 : ns = 2'b10; // if we hold, we enter the hold state
            3'b10_0 : ns = 2'b00; // if we release, we exit hold state
            3'b10_1 : ns = 2'b10; // if we hold the button, we stay here
        endcase
        
   assign out = (cs == 2'b01) ? 1'b1 : 1'b0;
   
endmodule

module control(
        input [7:0] cmd,
        output reg RW,
        output reg MEM_OR_ALU
        );
        always@(cmd)
            casex(cmd)
                8'bxxxx_00xx,
                8'bxxxx_010x,
                8'bxxxx_0110: begin
                                RW = 1'b1; 
                                MEM_OR_ALU = 1'b0; // alu operations
                              end
               8'bxxxx_0111: begin
                                RW = 1'b0; // write
                                MEM_OR_ALU = 1'b1; // memory operation
                             end
               8'bxxxx_1000: begin
                                RW = 1'b1; // read
                                MEM_OR_ALU = 1'b1; // memory operation
                             end
               default: begin
                            RW = 1'b1;
                            MEM_OR_ALU = 1'b0;
                        end 
            endcase
endmodule

module top(
        input clk,
        input STEP_INSTRUCTION,
        //input BTN4_PL,
        input BTN0,
        input BTN1,
        input BTN2,
        output a,
        output b,
        output c,
        output d,
        output e,
        output f,
        output g,
        output A1,
        output A2,
        output A3, 
        output A4
        );
        
        parameter operand_size = 12;
        
        wire [31:0] ROM_OUT;
        
        wire oneperiod_out;
        
        // control variables
        wire MEMorALU;
        wire MEM_RW;
        
        // ram variables
        wire [31:0] RAM_OUT;
        
        wire [3:0] dig_dec_in;
        wire [1:0] cnt2_out;
        wire clk_divided;
        
        
        // register variables
        /*wire [operand_size - 1:0] rega_in;
        wire [operand_size - 1:0] regb_in;
        wire [operand_size - 1:0] regop_in;*/
        
        wire [operand_size - 1:0] rega_out;
        wire [operand_size - 1:0] regb_out;
        wire [3:0] regop_out;
        
        wire [operand_size - 1:0] alu_out;
        wire alu_err;
        wire alu_of;
        wire alu_zero;
        
        wire [1:0] debug_cmd;
        
        wire [3:0] errf_out;
        
        wire [operand_size - 1:0] mux_dbg;
        
        wire [15:0] din_main; // this will be the input to the leds
        
        clk_divider clkdiv(
            .clk(clk),
            .clk_out(clk_divided)
            );
            
        one_period onep_inst(
            .clk(clk),
            .in(STEP_INSTRUCTION),
            .out(oneperiod_out)
            );
            
        control control_inst(
            .cmd(ROM_OUT[31:2 * operand_size]),
            .RW(MEM_RW),
            .MEM_OR_ALU(MEMorALU)
            );  
            
        ROM rom_inst(
            .clk(clk),
            .EN(oneperiod_out),
            .OUT(ROM_OUT)
            );    
        
        RAM RAM_inst(
            .clk(clk),
            .DIN({{16{1'b0}}, ROM_OUT[2 * operand_size - 1:8]}),
            .ADDR(ROM_OUT[7:0]), // 8 bit address
            .RW(MEM_RW),
            .OUT(RAM_OUT)
            ); 
            
        //assign rega_in = (MEMorALU & RW) ? RAM_OUT[operand_size - 1:0] : ROM_OUT[operand_size - 1:0]);
        
        reg_n#(operand_size) reg_a(
            .pl(1'b1),
            .di(ROM_OUT[operand_size - 1:0]),
            .do(rega_out)
            );
            
        reg_n#(operand_size) reg_b(
            .pl(1'b1),
            .di(ROM_OUT[2 * operand_size - 1:operand_size]),
            .do(regb_out)
            ); 
              
        reg_n#(4) reg_op(
            .pl(1'b1),
            .di(ROM_OUT[27:2 * operand_size]),
            .do(regop_out)
            );
           
         ALU#(operand_size) alu(
            .A(rega_out),
            .B(regb_out),
            .OP(regop_out),
            .ERR_RESERVED(alu_err),
            .OF(alu_of),
            .ZERO(alu_zero),
            .O(alu_out)
            );     
            
        dec_debug decdbg(
            .ain({BTN0, BTN1, BTN2}),
            .aout(debug_cmd)
            );
            
       dec_errf decerrf(
            .ain({alu_err, alu_of, alu_zero}),
            .aout(errf_out)
            );
            
       assign mux_dbg = (debug_cmd == 2'b00) ? alu_out :
                        (debug_cmd == 2'b01) ? rega_out :
                        (debug_cmd == 2'b10) ? regb_out :
                        (debug_cmd == 2'b11) ? {{operand_size - 4{1'b0}}, regop_out} :
                                                alu_out;
                                                
      assign din_main = (MEMorALU == 1'b1) ? RAM_OUT[15:0] : {errf_out, mux_dbg};        
        
        cnt2 cnt(
            .clk(clk_divided),
            .do(cnt2_out)
            );
            
        dig_dec digdec(
            .di(dig_dec_in),
            .a(a),
            .b(b),
            .c(c),
            .d(d),
            .e(e),
            .f(f),
            .g(g)
            );
        
        
        dec2_4 dec(
            .ain(cnt2_out),
            .aout({A4, A3, A2, A1})
            );
            
        assign dig_dec_in = (cnt2_out == 2'b00) ? din_main[3:0] :
                            (cnt2_out == 2'b01) ? din_main[7:4] :
                            (cnt2_out == 2'b10) ? din_main[11:8] :
                            (cnt2_out == 2'b11) ? din_main[15:12] : 4'bxxxx;
        
endmodule

/*
module tb_top;
    reg clkt;
    reg [15:0] dit;
    wire at, bt, ct, dt, et, ft, gt;
    wire A1t, A2t, A3t, A4t;
    
    top dut(
        .clk(clkt),
        .di(dit),
        .a(at),
        .b(bt),
        .c(ct),
        .d(dt),
        .e(et),
        .f(ft),
        .g(gt),
        .A1(A1t),
        .A2(A2t),
        .A3(A3t),
        .A4(A4t)
        );
        
    initial
        #160 $finish;
        
    initial
    begin
        #0 clkt = 1'b0;
        forever #5 clkt = ~clkt;
    end
    
    initial
        #0 dit = 16'b1000_0100_0010_0000;
        
endmodule
*/
