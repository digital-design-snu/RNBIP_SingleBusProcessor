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



module RegisterArray(
	input 	 	[7:0] 		dataBus_in,
	output      [7:0]       dataBus_out,
	output 	 	[7:0] 		R0_out,	
	input 		[7:0] 	 	ALU_out,
	input 		[2:0] 		RN_Reg_Sel,
	input   	[4:0] 		Control_in,
	input				clk1
	);

	reg 		[7:0]		Reg_Array	[7:0];
    reg         [7:0]       RN_out_Bus;
//    wire        [7:0]       outBus;
	initial
	begin
		Reg_Array[0] = 0;
		Reg_Array[1] = 1;
		Reg_Array[2] = 2;
		Reg_Array[3] = 3;
		Reg_Array[4] = 4;
		Reg_Array[5] = 5;
		Reg_Array[6] = 6;
		Reg_Array[7] = 7;
		
		RN_out_Bus=0;
	end

assign S_AL= Control_in[4];
assign E_R0= Control_in[3];
assign L_R0= Control_in[2];
assign E_RN= Control_in[1];
assign L_RN= Control_in[0];
	
always @ (posedge clk1)
begin
    if(L_R0 & L_RN) begin
       Reg_Array[0]= 0; 
       Reg_Array[1]= 0; 
       Reg_Array[2]= 0; 
       Reg_Array[3]= 0; 
       Reg_Array[4]= 0; 
       Reg_Array[5]= 0; 
       Reg_Array[6]= 0; 
       Reg_Array[7]= 0; 
    end 
   	else if (L_R0)
	begin
		Reg_Array[0]= (S_AL)?ALU_out:dataBus_in;
	end

	else if (L_RN)
	begin	
		Reg_Array[RN_Reg_Sel] = (S_AL)?ALU_out:dataBus_in;
		
	end
end
/*assign outBus = (E_R0==1'b1 || E_RN == 1'b1 ) ?
                ((E_R0)?Reg_Array[0]:Reg_Array[RN_Reg_Sel]):
                8'hzz;*/
always @ (E_R0 or E_RN)
begin
    if(E_R0)
    begin
    RN_out_Bus = Reg_Array[0];
    end
    
    else if(E_RN) begin
    RN_out_Bus = Reg_Array[RN_Reg_Sel];
    end
    
	
end

assign R0_out = Reg_Array[0];
assign dataBus_out = RN_out_Bus;

endmodule


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


module OperandRegister(
	       //inout  [7:0]   dataBus,
	         input     [7:0]   dataBusIn, 
	         output    [7:0]   databusOut,
	
	output [7:0]   toALU,
	output [7:0]   OR_PC,
	input 			E_OR,
	input 			L_OR,
	input 			CLK
);
	//reg [7:0]	OR_out_Bus;
	reg [7:0] 	OR_data;
	wire [7:0] OR_in_Bus;
    
	           //assign dataBus = (E_OR)?OR_data:8'hzz;
	           //assign OR_in_Bus = dataBus;
                assign databusOut = OR_data;
                assign OR_in_Bus = dataBusIn;
    
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

