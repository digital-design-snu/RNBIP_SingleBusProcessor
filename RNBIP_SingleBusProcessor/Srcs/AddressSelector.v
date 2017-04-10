`timescale 1ns / 1ps

module AddressSelector(
    input [7:0] PC_address_in,
    input [7:0] SP_address_in,
    input [7:0] R0_address_in,
    input S_PC,
    input S_SP,
    output /*reg */[7:0] Address_Bus_out
    );
    /*always @(S_PC or S_SP)
    begin
        case ({S_PC,S_SP})
            2'b00: Address_Bus_out = R0_address_in; //Address from R0 is selected
            2'b01: Address_Bus_out = SP_address_in; //Address from SP is selected
            2'b10: Address_Bus_out = PC_address_in; //Address from PC is selected
            2'b11: Address_Bus_out = R0_address_in; //Invalid :: Default: Address from R0 is selected
        endcase
    end*/
    assign Address_Bus_out = ({S_PC,S_SP} == 2'b01)?SP_address_in:
                             (({S_PC,S_SP} == 2'b10)?PC_address_in:
                             R0_address_in);
endmodule
