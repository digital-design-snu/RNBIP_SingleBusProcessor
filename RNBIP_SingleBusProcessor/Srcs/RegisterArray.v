`timescale 1ns / 1ps

module RegisterArray(
	input 	 	[15:0] 		dataBus_in,
	output      [15:0]       dataBus_out,
	output 	 	[15:0] 		R0_out,	
	input 		[15:0] 	 	ALU_out,
	input 		[2:0] 		RN_Reg_Sel,
	input   	[4:0] 		Control_in,
	input					clk1
	);

	reg 		[15:0]		Reg_Array	[7:0];
    reg 		[15:0] 		RN_out_Bus;

	reg 		[15:0]		Reg_Array	[7:0];
    reg         [15:0]       RN_out_Bus;
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
