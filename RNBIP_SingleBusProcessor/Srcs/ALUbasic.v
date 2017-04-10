`timescale 1ns / 1ps

module ALUbasic(
	output      [7:0]   Out,           // Output 8 bit
	output      [3:0]   flagArray,     // not holding only driving EDI
	input 			    Cin,          // Carry input bit
	input 		[7:0] 	A_IN,
	input       [7:0]   B_IN,     // 8-bit data input
	input 		[3:0] 	S_AF        // Most significant 4 bits of the op code
	);
	//legacy def
	//Unary Operations
    parameter   [3:0]   ZERO        =4'h0;     //Output 0(ZERO)
    parameter	[3:0]	A	   	    =4'h1;     //Output A
	parameter	[3:0]	NOT	   	    =4'h2;     //~A
	parameter	[3:0]	B	   	    =4'h3;     //Output B
	parameter	[3:0]	INC_A		=4'h4;     //A + 1
	parameter	[3:0]	DCR_A		=4'h5;     //A - 1
	parameter	[3:0]	SLC_A 		=4'h6;     //Shift Left & C <- MSB
	parameter	[3:0]	SRC_A		=4'h7;     //Shift Right & C <- LSB
	
	//Binary and ternary operations - Arithmetic
	parameter	[3:0]	ADD_AB		=4'h8;     //A + B
	parameter	[3:0]	SUB_AB		=4'h9;     //A - B
	parameter	[3:0]	ADD_ABC  	=4'hA;     //A + B + C
	parameter	[3:0]	SUB_ABC     =4'hB;     //A - B - C
	
	//Binary and ternary operations - Logical 
	parameter	[3:0]	AND_AB      =4'hC;     //A AND B
	parameter	[3:0]	OR_AB		=4'hD;     //A OR B      
	parameter	[3:0]	XOR_AB		=4'hE;     //A XOR B
	parameter	[3:0]	XNA_AB		=4'hF;     //A' XOR B
    // end legacy def
    wire Cout;
    wire Zero;
    wire OddParity;
    wire Positive;
    
    assign {Cout,Out} = (S_AF== ZERO )?        9'h00         : (
                        (S_AF== A )?           A_IN          : (
                        (S_AF== NOT )?         ~A_IN         : (
                        (S_AF== B )?           B_IN          : (
                        (S_AF== INC_A )?       A_IN+1        : (
                        (S_AF== DCR_A )?       A_IN-1        : (
                        (S_AF== SLC_A )?       {A_IN,Cin}    : (        //Rotate
                        (S_AF== SRC_A )?       {A_IN[0],Cin,A_IN[7:1]}    : (      //Rotate
                        (S_AF== ADD_AB )?      A_IN+B_IN     : (
                        (S_AF== SUB_AB )?      B_IN-A_IN     : (
                        (S_AF== ADD_ABC )?     A_IN+B_IN+Cin : (
                        (S_AF== SUB_ABC )?     B_IN-A_IN-Cin : (
                        (S_AF== AND_AB )?      A_IN&B_IN     : (
                        (S_AF== OR_AB )?       A_IN|B_IN     : (
                        (S_AF== XOR_AB )?      A_IN^B_IN     : (
                        (S_AF== XNA_AB )?      ~(A_IN^B_IN)  : 9'hzz )))))))))))))));
    
    assign  OddParity = ^Out;
    assign  Zero = ~(|Out);
    assign  Positive = ~(Out[7]);
    assign  flagArray = {OddParity,Positive,Cout,Zero};
    
endmodule