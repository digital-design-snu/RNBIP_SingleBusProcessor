`timescale 1ns / 1ps

module red_CCD(
    input  [7:0]    opCode,
    input  clk,FL,
    input  E_FLi,    S_IFi,
    output  E_FL,    S_IF,                  //Control Code Generator
    output S_SP,    S_PC, RD, WR,           //Address Selector and Memory 
    output E_PC,    I_PC, L_PC,             //PC                          
    output E_SP,    D_SP, I_SP,             //SP                  bye bye lsp        
    output L_IR,                            //IR                          
    output S_AL,    L_R0, L_RN, E_R0, E_RN,  //Register Array      
    output E_OR,    L_OR,                       //Operand Register            
    output E_IP,    L_OP                    //Input-Output  
    );
    // Register declaritions
    reg State;
    reg [21:0] controlBits;
    // wire assignments to The Control bit registers
    
    /*always @(*) begin
    controlBits = {RD, WR, S_PC, S_SP, E_PC, I_PC, L_PC, E_SP, D_SP,I_SP, 
                   L_SP, L_IR, S_SF, E_FL, S_IF, E_IP, L_OP, E_OR, L_OR, S_AL,
                   L_R0, L_RN, E_R0, E_RN};                    
    end*/
    assign {RD, WR, S_PC, S_SP, E_PC, I_PC, L_PC, E_SP, D_SP,I_SP, 
           L_IR, E_FL, S_IF, E_IP, L_OP, E_OR, L_OR, S_AL,L_R0, E_R0, 
           L_RN, E_RN} = controlBits;
   
   // Sys init Conditions
   
   initial begin
        controlBits = 22'b0000_0000_0000_1000_0000_00;
        State = 1'b0;                       // instruction register should be set to drive 0x00 as output at init
    end
    
   // control bit path flow 
    wire GoFetch = ((~(E_FLi && FL)) && S_IFi);
   // wire GoFetch = S_IFi;
    wire [8:0] FiniteStateMux = (GoFetch)?  9'b0000_0000_0 :(opCode==8'h00)?{opCode,1'b1}:{opCode,State};
 
     always @ (posedge clk)begin
        if(GoFetch) 
            State = 1'b0;
        else 
            State = State + 1;
    end
        
    always @ (posedge clk)
    begin
    
        casex(FiniteStateMux)
           
            9'b00000_000_0 : controlBits = 22'b1010010000100000000000;
            9'b00000_000_1 : controlBits = 22'b0000000000001000000000;//nop
            9'b00000_001_0 : controlBits = 22'b0000000000001000011010;
            9'b00000_010_0 : controlBits = 22'b0000000000001000010000;
            9'b00000_011_0 : controlBits = 22'b1010000000000000100000;
            9'b00000_011_1 : controlBits = 22'b0000001000001001000000;
            9'b00000_100_0 : controlBits = 22'b0000001000001000000100;
            9'b00000_101_0 : controlBits = 22'b0101100010000000000000;
            9'b00000_101_1 : controlBits = 22'b1010001000001000000000;
            9'b00000_110_0 : controlBits = 22'b0101100010000000000000;
            9'b00000_110_1 : controlBits = 22'b0000001000001000000100;
            9'b00000_111_0 : controlBits = 22'b1001001001001000000000;
            
            //9'b00001_xxx_0 : controlBits = 22'b1010011000011000000000;
            9'b00001_xxx_0 : controlBits = 22'b1010010000011000100000;
            9'b00001_xxx_1 : controlBits = 22'b0000001000001001000000;
            
                    
            9'b00010_000_0 : controlBits = 22'b0000000011001000000100;
            /*9'b00010_001_0 : controlBits = 22'b0000000000001000000110;
            9'b00010_01x_0 : controlBits = 22'b0000000000001000000110;
            9'b00010_1xx_0 : controlBits = 22'b0000000000001000000110;*/
            9'b00010_xxx_0 : controlBits = 22'b0000000000001000000110;
            9'b00011_000_0 : controlBits = 22'b0000000100001000001000;
            /*9'b00011_001_0 : controlBits = 22'b0000000000001000001001;
            9'b00011_01x_0 : controlBits = 22'b0000000000001000001001;
            9'b00011_1xx_0 : controlBits = 22'b0000000000001000001001;*/
            9'b00011_xxx_0 : controlBits = 22'b0000000000001000001001;
            9'b00100_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b00100_xxx_1 : controlBits = 22'b0000000000001001010010;
            
            //9'b00101_xxx_0 : controlBits = 22'b0000010000011000000100;
            9'b00101_xxx_0 : controlBits = 22'b0000000000011000100100;
            9'b00101_xxx_1 : controlBits = 22'b0000011000001000000000;
            
            9'b00110_xxx_0 : controlBits = 22'b1010010000011000100000;
            9'b00110_xxx_1 : controlBits = 22'b0101111010001000000000;
            
            9'b00111_xxx_0 : controlBits = 22'b0000000000011000100100;
            9'b00111_xxx_1 : controlBits = 22'b0101111010001000000000;
                        
            //9'b00111_xxx_1 : controlBits = 22'b1010000000001000000100;
            
            9'b01000_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b01000_xxx_1 : controlBits = 22'b0000000000001001010010;
            
            
            //9'b01001_xxx_0 : controlBits = 22'b1001010001011000000000;
            9'b01001_xxx_0 : controlBits = 22'b1001000000011000100000;
            9'b01001_xxx_1 : controlBits = 22'b0000011001001000000000;
            
            9'b01010_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b01010_xxx_1 : controlBits = 22'b0000000000001001010010;
            9'b01011_xxx_0 : controlBits = 22'b1010010000001000000010;
            
            9'b01100_000_0 : controlBits = 22'b0000000000000000100100;
            9'b01100_000_1 : controlBits = 22'b0000000000001001011000;           
           /*9'b01100_001_0 : controlBits = 22'b0100000000001000000001;
            9'b01100_01x_0 : controlBits = 22'b0100000000001000000001;
            9'b01100_1xx_0 : controlBits = 22'b0100000000001000000001;*/
           
            9'b01100_xxx_0 : controlBits = 22'b0100000000001000000001;
            9'b01101_xxx_0 : controlBits = 22'b0101000010001000000001;
            
           
            9'b01110_000_0 : controlBits = 22'b0000000000000000100100;
            9'b01110_000_1 : controlBits = 22'b0000000000001001011000;            
            /*9'b01110_001_0 : controlBits = 22'b1000000000001000000010;
            9'b01110_01x_0 : controlBits = 22'b1000000000001000000010;
            9'b01110_1xx_0 : controlBits = 22'b1000000000001000000010;
            */
            
            9'b01110_xxx_0 : controlBits = 22'b1000000000001000000010;
            9'b01111_xxx_0 : controlBits = 22'b1001000001001000000010;
            9'b10000_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b10000_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b10001_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b10001_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b10010_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b10010_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b10011_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b10011_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b10100_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b10100_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b10101_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b10101_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b10110_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b10110_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b10111_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b10111_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b11000_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b11000_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b11001_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b11001_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b11010_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b11010_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b11011_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b11011_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b11100_xxx_0 : controlBits = 22'b0000000000000000100100;
            9'b11100_xxx_1 : controlBits = 22'b0000000000001000011001;
            9'b11101_xxx_0 : controlBits = 22'b0000000000000000100001;
            9'b11101_xxx_1 : controlBits = 22'b1010010000001000010010;
            9'b11110_xxx_0 : controlBits = 22'b0000000000000100001000;
            9'b11111_xxx_0 : controlBits = 22'b0000000000001010000100;       
//            9'b00000_000_0 : controlBits = 22'b1010010000100000000000;
//            9'b00000_001_0 : controlBits = 22'b0000000000001000011010;
//            9'b00000_010_0 : controlBits = 22'b0000000000000000010000;
//            9'b00000_011_0 : controlBits = 22'b1010000000000000100000;
//            9'b00000_011_1 : controlBits = 22'b0000001000001001000000;
//            9'b00000_100_0 : controlBits = 22'b0000001000001000000100;
//            9'b00000_101_0 : controlBits = 22'b0101100010000000000000;
//            9'b00000_101_1 : controlBits = 22'b1010010000001000000000;
//            9'b00000_110_0 : controlBits = 22'b0101100010000000000000;
//            9'b00000_110_1 : controlBits = 22'b1010000000001000000100;
//            9'b00000_111_0 : controlBits = 22'b1001010001001000000000;
//            9'b00001_xxx_0 : controlBits = 22'b1010010000011000000000;
            
//            9'b00010_000_0 : controlBits = 22'b0000000011001000000100;
//            /*9'b00010_001_0 : controlBits = 22'b0000000000001000000110;
//            9'b00010_01x_0 : controlBits = 22'b0000000000001000000110;
//            9'b00010_1xx_0 : controlBits = 22'b0000000000001000000110;*/
//            9'b00010_xxx_0 : controlBits = 22'b0000000000001000000110;
//            9'b00011_000_0 : controlBits = 22'b0000000100001000001000;
//            /*9'b00011_001_0 : controlBits = 22'b0000000000001000001001;
//            9'b00011_01x_0 : controlBits = 22'b0000000000001000001001;
//            9'b00011_1xx_0 : controlBits = 22'b0000000000001000001001;*/
//            9'b00011_xxx_0 : controlBits = 22'b0000000000001000001001;
//            9'b00100_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b00100_xxx_1 : controlBits = 22'b0000000000001001010010;
//            9'b00101_xxx_0 : controlBits = 22'b0000010000011000000100;
//            9'b00110_xxx_0 : controlBits = 22'b0101100010011000000000;
//            9'b00110_xxx_1 : controlBits = 22'b1010001000001000000000;
//            9'b00111_xxx_0 : controlBits = 22'b0101100010011000000000;
//            9'b00111_xxx_1 : controlBits = 22'b1010000000001000000100;
//            9'b01000_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b01000_xxx_1 : controlBits = 22'b0000000000001001010010;
//            9'b01001_xxx_0 : controlBits = 22'b1001010001011000000000;
//            9'b01010_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b01010_xxx_1 : controlBits = 22'b0000000000001001010010;
//            9'b01011_xxx_0 : controlBits = 22'b1010010000001000000010;
            
//            9'b01100_000_0 : controlBits = 22'b0000000000000000000000;
//            /*9'b01100_001_0 : controlBits = 22'b0100000000001000000001;
//            9'b01100_01x_0 : controlBits = 22'b0100000000001000000001;
//            9'b01100_1xx_0 : controlBits = 22'b0100000000001000000001;*/
//            9'b01100_xxx_0 : controlBits = 22'b0100000000001000000001;
//            9'b01101_xxx_0 : controlBits = 22'b0101000010001000000001;
            
//            9'b01110_000_0 : controlBits = 22'b0000000000000000000000;
//            /*9'b01110_001_0 : controlBits = 22'b1000000000001000000010;
//            9'b01110_01x_0 : controlBits = 22'b1000000000001000000010;
//            9'b01110_1xx_0 : controlBits = 22'b1000000000001000000010;
//            */
//            9'b01110_xxx_0 : controlBits = 22'b1000000000001000000010;
//            9'b01111_xxx_0 : controlBits = 22'b1001000001001000000010;
//            9'b10000_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b10000_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b10001_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b10001_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b10010_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b10010_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b10011_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b10011_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b10100_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b10100_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b10101_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b10101_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b10110_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b10110_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b10111_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b10111_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b11000_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b11000_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b11001_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b11001_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b11010_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b11010_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b11011_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b11011_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b11100_xxx_0 : controlBits = 22'b0000000000000000100100;
//            9'b11100_xxx_1 : controlBits = 22'b0000000000001000011001;
//            9'b11101_xxx_0 : controlBits = 22'b0000000000000000100001;
//            9'b11101_xxx_1 : controlBits = 22'b1010010000001000010010;
//            9'b11110_xxx_0 : controlBits = 22'b0000000000000100001000;
//            9'b11111_xxx_0 : controlBits = 22'b0000000000001010000100;
        endcase
    end    
endmodule
