`timescale 1ns / 1ps

module Topmodule(
    input   clk,
    output  [15:0] led
	);

// WIRES FOR CONTROL SIGNALS
    wire S_SP, S_PC, RD, WR;    //Address Selector and Memory
    wire E_PC, I_PC, L_PC;      //PC
    wire E_SP, D_SP, I_SP;//SP
    wire L_IR;                  //IR
    wire S_AL, L_R0, L_RN, E_R0, E_RN;  //Register Array
    wire E_OR, L_OR;            //Operand Register
    wire E_IP, L_OP;            //Input-Output
    wire E_FL, S_IF;            //Control Code Generator
    wire [15:0]  dataBus;        //Data Bus
// END OF WIRES FOR CONTROL SIGNALS


// HARDCODED WIRES
    wire [15:0]  OR_ALU;
    wire [15:0]  SP_AS;
    wire [15:0]  PC_AS;
    wire [15:0]  R0_AS;
    wire [15:0]  ALU_RN;
    wire [7:0]  opcode;
    wire [15:0]  OR_PC;
    wire [3:0]  ALU_FR;
    wire        ALU_FR_Carry;
    wire        FR_CG;
    wire [15:0]  Address_Bus;
    wire        E_FLi;
    wire        S_IFi;
    wire [15:0] PCOut;
    wire [15:0] MEMOut;
    wire [15:0] OROut;
    wire [15:0] SPOut;
    wire [15:0] RAOut;
    wire [15:0] IOOut;
// END OF HARDCODED WIRES


    wire [15:0] ioOut0;



assign E_FLi = E_FL;
assign S_IFi = S_IF;


// DEBUG
/*
   reg [31:0] sClk;
    wire CLK = sClk[25];
    
initial begin
    sClk=32'b0000_0000_0000_0000_0000_0000_0000_0000;
end    
    
always@(posedge clk)begin
    sClk = sClk+1;
end
 */
assign CLK = clk;
    
    
    
    //assign led[0] = out;
    /*reg [7:0] temp;
    always@(posedge clk)
        temp = ALU_RN;*/
    //assign led[15:8] = temp;
    //assign led[15:8]    = PC_AS;
    assign led[15:8] = ioOut0;
    //assign led[7:0]     = dataBus;
    //assign IOOut = 8'h00; // till the io is not integrated
// DEBUG ENDSk

// Instantiate the IPs here 

busArbitrator busArbT(
     dataBus,
     RD,
     E_PC,
     E_SP,
     E_IP,
     E_OR,
     E_R0,
     E_RN,
     PCOut,
     MEMOut,
     OROut,
     SPOut,
     RAOut,
     IOOut
    );
    

ProgramCounter my_pc (

    .E_PC(E_PC),
    .I_PC(I_PC),
    .L_PC(L_PC),
    .CLK(CLK),
    .OR(OR_PC),
    .dataBus_in(dataBus),
    .dataBus_out(PCOut),
    .toAS(PC_AS)
);

AddressSelector my_as (
    .PC_address_in(PC_AS),
    .SP_address_in(SP_AS),
    .R0_address_in(R0_AS),
    .S_PC(S_PC),
    .S_SP(S_SP),
    .Address_Bus_out(Address_Bus)
);

ALUbasic my_ALU (

    .flagArray(ALU_FR),
    .Cin(ALU_FR_Carry),
    .A_IN(dataBus),
    .B_IN(OR_ALU),
    .S_AF(opcode[7:4]),
    .Out(ALU_RN)    
);

Io_GPIB my_IO(
   .Eip(E_IP),
   .Lop(L_OP),
   .Clk(CLK),
   .ioSel(opcode[2:0]),
   .dataBusIn(dataBus),
   .dataBusOut(IOOut)
   ,.io0(ioOut0)
    );
    
OperandRegister my_OR (
    .dataBusIn(dataBus), 
    .databusOut(OROut),
    .E_OR(E_OR),
    .toALU(OR_ALU),
    .OR_PC(OR_PC),
    .L_OR(L_OR),
    .CLK(CLK)
);

InstructionRegister my_IR (
    .CLK(CLK),
    .L_IR(L_IR),
    .dataBus_in(dataBus),
    .OC_out(opcode)
);

RegisterArray my_RA (
    .dataBus_in(dataBus),
    .dataBus_out(RAOut),   
    .R0_out(R0_AS),	  
    .ALU_out(ALU_RN),   
    .RN_Reg_Sel(opcode[2:0]), 
    .Control_in({S_AL, E_R0, L_R0, E_RN, L_RN}),
    .clk1(CLK)
);

StackPointer my_SP (
    .I_SP(I_SP),
    .D_SP(D_SP),
    .E_SP(E_SP),
    .CLK(CLK),
    .SP_address(SP_AS),
    .SP_input_Bus(dataBus),
    .SP_output_Bus(SPOut)
);
FlagRegister my_FR  (
    .opCode(opcode[2:0]),
    .inArray(ALU_FR),
    .carry(ALU_FR_Carry),
    .FL(FR_CG),
    .S_AL(S_AL)  
); 
MemCache my_Mem(
    .Address(Address_Bus),
    .dataBusIn(dataBus), 
    .dataBusOut(MEMOut),
    .RD(RD),          
    .WR(WR),          
    .sClk(CLK)         
); 

red_CCD my_CCG(
    opcode,                
    CLK,FR_CG,                         
    E_FLi,    S_IFi,                
    E_FL,    S_IF,                 
    S_SP,    S_PC, RD, WR,          
    E_PC,    I_PC, L_PC,            
    E_SP,    D_SP, I_SP,            
    L_IR,                           
    S_AL,    L_R0, L_RN, E_R0, E_RN,
    E_OR,    L_OR,                  
    E_IP,    L_OP                                     
);  

endmodule