`timescale 1ns / 1ps

module ProgramCounter(
    input				E_PC,I_PC,L_PC,
    input				CLK,
    input       [7:0]   OR,
    input		[7:0]	dataBus_in,
    output      [7:0]   dataBus_out,
    output      [7:0]   toAS
);

wire	[7:0]	PC_in_Bus;
wire	[7:0]	PC_out_Bus;
reg		[7:0]	PC_reg;			// = [PC]  
//reg     [7:0]   tempReg;                      
initial
PC_reg = 8'b0000_0000;

assign dataBus_out = PC_out_Bus;
assign  PC_in_Bus = dataBus_in;
assign toAS = PC_reg;


initial
begin 
	PC_reg = 8'h00;
end

assign PC_out_Bus = PC_reg;
// PC_out_Bus = [PC] if E_PC = 1 and not driven by PC if E_PC = 0

always@(posedge CLK)
begin
	case({I_PC,L_PC})
	2'b00:	PC_reg <= PC_reg;
	2'b10:	PC_reg <= PC_reg+1;
	2'b01:	PC_reg <= PC_in_Bus;
	2'b11:	PC_reg <= OR;//PC_reg + PC_in_Bus; 
	endcase
end                                         
/*always@(posedge CLK) begin
PC_reg = tempReg;
end*/
endmodule