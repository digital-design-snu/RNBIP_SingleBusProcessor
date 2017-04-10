`timescale 1ns / 1ps

module RegisterArray(
	inout 	 	[15:0] 		DataBus,
	output 	 	[15:0] 		R0_out,	
	input 		[15:0] 	 	ALU_out,
	input 		[2:0] 		RN_Reg_Sel,
	input   	[4:0] 		Control_in,
	input					clk1
	);

	reg 		[15:0]		Reg_Array	[7:0];
    reg 		[15:0] 		RN_out_Bus;
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
		Reg_Array[0]= (S_AL)?ALU_out:DataBus;
	end

	else if (L_RN)
	begin	
		
		case({RN_Reg_Sel[2:0]})
		3'b000: Reg_Array[0]= (S_AL)?ALU_out:DataBus;
		3'b001: Reg_Array[1]= (S_AL)?ALU_out:DataBus;
		3'b010: Reg_Array[2]= (S_AL)?ALU_out:DataBus;
		3'b011: Reg_Array[3]= (S_AL)?ALU_out:DataBus;
		3'b100: Reg_Array[4]= (S_AL)?ALU_out:DataBus;
		3'b101: Reg_Array[5]= (S_AL)?ALU_out:DataBus;
		3'b110: Reg_Array[6]= (S_AL)?ALU_out:DataBus;
		3'b111: Reg_Array[7]= (S_AL)?ALU_out:DataBus;
		endcase
	end
end

always @ (E_R0 or E_RN)
begin
    if(E_R0)
    begin
    RN_out_Bus = Reg_Array[0];
    end
    
    else if(E_RN) begin
    RN_out_Bus = Reg_Array[RN_Reg_Sel];
    end
    
	else 
	begin
		RN_out_Bus = 16'hZZZZ;
	end
end

assign R0_out = Reg_Array[0];
assign DataBus = RN_out_Bus;

endmodule

