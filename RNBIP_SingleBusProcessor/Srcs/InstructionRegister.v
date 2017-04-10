`timescale 1ns / 1ps

module InstructionRegister(
    input             CLK,
    input             L_IR,
    input       [7:0] dataBus_in,
    output reg  [7:0] OC_out
    );
    initial 
        OC_out = 8'h00;
    always @(*)
    begin
        if(L_IR)
            OC_out = dataBus_in;
    end
endmodule
