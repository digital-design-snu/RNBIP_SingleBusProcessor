`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2016 06:41:59
// Design Name: 
// Module Name: Io_GPIB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Io_GPIB(
    input Eip,
    input Lop,
    input Clk,
    input [2:0] ioSel,
    output [15:0] io0,
    output [15:0] io1,
    output [15:0] io2,
    output [15:0] io3,
    output [15:0] io4,
    output [15:0] io5,
    output [15:0] io6,
    output [15:0] io7,  
    input [15:0] io0I,
    input [15:0] io1I,
    input [15:0] io2I,
    input [15:0] io3I,
    input [15:0] io4I,
    input [15:0] io5I,
    input [15:0] io6I,
    input [15:0] io7I,  
    input [15:0] dataBusIn,
    output [15:0] dataBusOut
    );
    
    
reg [15:0] outRegs [7:0];
initial begin
outRegs[0] = 0 ;
outRegs[1] = 0 ;
outRegs[2] = 0 ;
outRegs[3] = 0 ;
outRegs[4] = 0 ;
outRegs[5] = 0 ;
outRegs[6] = 0 ;
outRegs[7] = 0 ;
end

assign io0 =outRegs[0];
assign io1 =outRegs[1];
assign io2 =outRegs[2];
assign io3 =outRegs[3];
assign io4 =outRegs[4];
assign io5 =outRegs[5];
assign io6 =outRegs[6];
assign io7 =outRegs[7];


always @(posedge Clk) begin
    if(Lop) outRegs[ioSel] = dataBusIn;
    end

assign dataBusOut =     (ioSel== 3'b000 & (Eip ) )?      io0I    : (
                        (ioSel== 3'b001 & (Eip ) )?      io1I    : (
                        (ioSel== 3'b010 & (Eip ) )?      io2I    : (
                        (ioSel== 3'b011 & (Eip ) )?      io3I    : (
                        (ioSel== 3'b100 & (Eip ) )?      io4I    : (
                        (ioSel== 3'b101 & (Eip ) )?      io5I    : (
                        (ioSel== 3'b110 & (Eip ) )?      io6I    : (       
                        (ioSel== 3'b111 & (Eip ) )?      io7I    : 16'h0000 )))))));
                        
endmodule