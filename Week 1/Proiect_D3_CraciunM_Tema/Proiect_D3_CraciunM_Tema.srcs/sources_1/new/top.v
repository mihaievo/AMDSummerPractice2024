`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2024 07:26:36 PM
// Design Name: Day 3's homework
// Module Name: top
// Project Name: D Flip-flops: PIPO, SISO, PISO, SIPO registers 
// Target Devices: --//--
// Tool Versions: --//--
// Description: 
// 
// Dependencies: None
// 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// type D flip-flops are just always@ posedge clk -> q <= d, so we will not
// implement separate modules, for simplicity.

// a PIPO register has a parallel loaded input and a parallel loaded output.
module PIPO_regD #(parameter DATA_WIDTH = 8)(
        input CLK,
        input RS,
        input PL, //parallel load
        input [DATA_WIDTH - 1:0] D,
        output reg [DATA_WIDTH - 1:0] Q
        );
        always@(posedge CLK)
            if(RS)
                Q <= {DATA_WIDTH{1'b0}};
            else if (PL)
                Q <= D;
endmodule

// a SISO register uses one bit as data in (D), and shifts the rest to the left,
// resulting a single bit as data out (Q).
module SISO_regD #(parameter DATA_WIDTH = 8)(
        input CLK,
        input RS,
        input SL, //serial load
        input D,
        output Q
        );
         // we will have {DATA_WIDTH} type D flip flops.
         // the output of each is the input of the next one.
         // so, we will use a shift register for easier logic (and less modules).
        reg [DATA_WIDTH - 1:0] sh_reg;
        always@(posedge CLK)
            if(RS)
                sh_reg <= {DATA_WIDTH{1'b0}};
            else if (SL) begin
                sh_reg <= {sh_reg[DATA_WIDTH - 2:0], D};
                end
            else // we rotate through sh_reg to print the value in it.
                sh_reg <= {sh_reg[DATA_WIDTH - 2:0], sh_reg[DATA_WIDTH - 1]};
         // we take only the last bit from the shift register as output.       
         assign Q = (SL == 1'b0) ? sh_reg[DATA_WIDTH - 1] : 1'bx;
endmodule

// a PISO register has parallel loaded data in, and serial loaded data out.
// so, we will have a single output bit.
module PISO_regD #(parameter DATA_WIDTH = 8)(
        input CLK,
        input RS,
        input PL, //parallel load
        input [DATA_WIDTH - 1:0] D,
        output Q
        );
        
        // again, we will have {DATA_WIDTH} type D flip flops.
        // logic is explained in previous module.
        reg [DATA_WIDTH - 1:0] sh_reg;
        always@(posedge CLK)
            if(RS)
                sh_reg <= {DATA_WIDTH{1'b0}};
            else if (PL)
                sh_reg <= D;
            else // if we are not loading, we will output the data in the register.
                // we will output from MSB to LSB, by rotating left.
                sh_reg <= {sh_reg[DATA_WIDTH - 2:0], sh_reg[DATA_WIDTH - 1]};
                
        assign Q = sh_reg[DATA_WIDTH - 1];
endmodule

// a SIPO register has serial loaded data in, and parallel loaded data out.
// so, we will have {DATA_WIDTH} output bits, and a single input bit.
module SIPO_regD #(parameter DATA_WIDTH = 8)(
        input CLK,
        input RS,
        input SL, //serial load
        input D,
        output [DATA_WIDTH - 1:0] Q
        );
         // we will have {DATA_WIDTH} type D flip flops.
         // the output of each is the input of the next one.
         // so, we will use a shift register for easier logic (and less modules).
        reg [DATA_WIDTH - 1:0] sh_reg;
        always@(posedge CLK)
            if(RS)
                sh_reg <= {DATA_WIDTH{1'b0}};
            else if (SL)
                sh_reg <= {sh_reg[DATA_WIDTH - 2:0], D};
                
            assign Q = (SL == 1'b0) ? sh_reg : {DATA_WIDTH{1'bx}};
endmodule


module tb_top;
    parameter DATA_WIDTHt = 8; // we use parameter for easier testing
    
    // declare necessary variables for each register type
    reg CLKt;
    reg RSt;
    reg PLt;
    reg SLt;
    reg [DATA_WIDTHt - 1:0]D_PIPO_PISO;
    reg D_SISO_SIPO;
    wire [DATA_WIDTHt - 1:0] Q_PIPO;
    wire Q_SISO;
    wire Q_PISO;
    wire [DATA_WIDTHt - 1:0] Q_SIPO;
    
    // instantiate registers
    PIPO_regD#(DATA_WIDTHt) dut_PIPO(
        .CLK(CLKt),
        .RS(RSt),
        .PL(PLt),
        .D(D_PIPO_PISO),
        .Q(Q_PIPO)
        );
        
    SISO_regD#(DATA_WIDTHt) dut_SISO(
        .CLK(CLKt),
        .RS(RSt),
        .SL(SLt),
        .D(D_SISO_SIPO),
        .Q(Q_SISO)
        );
        
    PISO_regD#(DATA_WIDTHt) dut_PISO(
        .CLK(CLKt),
        .RS(RSt),
        .PL(PLt),
        .D(D_PIPO_PISO),
        .Q(Q_PISO)
        );
        
    SIPO_regD#(DATA_WIDTHt) dut_SIPO(
        .CLK(CLKt),
        .RS(RSt),
        .SL(SLt),
        .D(D_SISO_SIPO),
        .Q(Q_SIPO)
        );
        
    // we end testing after 100ns
    initial 
        #200 $finish;
    
    // we generate the clock signal
    initial
    begin
        #0 CLKt = 1'b0;
        forever #5 CLKt = ~CLKt;
    end
    
    //we test with actual data
    initial
    begin
        #0 RSt = 1'b1; D_SISO_SIPO = 1'b1; D_PIPO_PISO = {{DATA_WIDTHt-8{1'b0}}, 8'b0000_1111};
           PLt = 1'b0; SLt = 1'b0;
        #10 RSt = 1'b0; PLt = 1'b1; SLt = 1'b1;
        #10 PLt = 1'b0;
        #30 SLt = 1'b0;
    end
    
endmodule