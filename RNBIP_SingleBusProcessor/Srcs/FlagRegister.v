`timescale 1ns / 1ps

module FlagRegister(
        input clk,
        input   [2:0]   opCode, //From IR
        input   [3:0]   inArray,//From ALU
        input           S_AL,   //Control bit, meaningful operation
        output carry,           //Output to ALU
        output FL               //Output to Control Code Generator
    );  
    reg [7:0]   flagArray;
    
    // Startup
    initial
        begin
            flagArray=0;
        end
    
    // End Startup
    always@(negedge S_AL)
       //if(S_AL) 
        begin
            flagArray[0] <= inArray[0];  //ZERO          Z
            flagArray[1] <= ~inArray[0]; //NOT ZERO      NZ
            flagArray[2] <= inArray[1];  //Carry         C
            flagArray[3] <= ~inArray[1]; //NOT Carry     NC
            flagArray[4] <= inArray[2];  //Positive      P
            flagArray[5] <= ~inArray[2]; //Negative      N
            flagArray[6] <= inArray[3];  //Parity Odd    PO
            flagArray[7] <= ~inArray[3]; //Parity Even   PE
        end

        
    assign carry = flagArray[2];
    assign FL = flagArray[opCode];

endmodule
