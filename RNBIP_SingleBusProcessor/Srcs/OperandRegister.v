`timescale 1ns / 1ps

module OperandRegister(
	inout  [7:0]   dataBus,
	output [7:0]   toALU,
	output [7:0]   OR_PC,
	input 			E_OR,
	input 			L_OR,
	input 			CLK
);
	//reg [7:0]	OR_out_Bus;
	reg [7:0] 	OR_data;
	wire [7:0] OR_in_Bus;
    
	assign dataBus = (E_OR)?OR_data:8'hzz;
	assign OR_in_Bus = dataBus;
    assign toALU = OR_data;
    assign OR_PC = OR_data;
    
    initial
        OR_data = 0;
    
	always @ (posedge CLK)
	begin		
		if (L_OR == 1'b1)
			OR_data = OR_in_Bus;
	end
			
	/*always @(E_OR)
	begin
		if (E_OR == 1'b1)
		begin
			OR_out_Bus = OR_data;			
		end
		else 
		begin
			OR_out_Bus = 8'hzz;
	    end	
	end	*/
	

endmodule
