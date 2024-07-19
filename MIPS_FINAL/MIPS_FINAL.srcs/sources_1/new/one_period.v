module one_period(
        input clk,
        input in,
        output out
        );
        
   reg [1:0] cs = 2'b0;
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