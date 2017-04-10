`timescale 1ns / 1ps

module StackPointer(
input				I_SP,
input               D_SP,
input               E_SP,
//input               L_SP,
input				CLK,
input       [7:0]   SP_input_Bus,
output      [7:0]   SP_output_Bus,
output      [7:0]	SP_address// Input to Address Selector
);                        

reg [7:0] SP_address_reg;

initial
	SP_address_reg = 8'h00;

assign SP_output_Bus = SP_address_reg;
assign SP_address = D_SP?(SP_address_reg-1):SP_address_reg;
always @(posedge CLK)
begin
	case({I_SP,D_SP})
	2'b00:	SP_address_reg <= SP_address_reg;// No Stack operation
	2'b10:	SP_address_reg <= SP_address_reg+1;// I_SP =1 
	2'b01:	SP_address_reg <= SP_address_reg-1;// D_SP = 1
    2'b11: 	SP_address_reg <= SP_input_Bus;	//L_SP = 1
	endcase
end                                         

endmodule
