
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:00 12/31/2023 
// Design Name: 
// Module Name:    controller_verilog 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


// Code your design here
`timescale 1ns / 1ps


module controller_verilog(
    input [4:0] opcode,
    input Distination,
    input carryFlag,
    input zeroFlag,
    input Reset_in,
    output reg[3:0] Stat_tst_out,
    output reg Reset_out,
    output reg ALU_MUX,
    output reg [3:0] ALU_OP,
    output reg PC_INC,
    output reg PC_LOAD,
    output reg IR_WR_SIGNAL,
    output reg RAM_RD,
    output reg RAM_WR,
    output reg FLAG_WR_SIGNAL,
    output reg RAM_MUX,
    output reg MDR_WR_SIGNAL,
    output reg A_WR_SIGNAL,
    output reg ALU_EN,
    input clk
    );
reg [3:0] current_state, next_state;
    reg IR_WR, A_WR, MDR_WR, FLAG_WR;
    wire out_clk;
    clk_divider clk_d (.clk(clk),.out_clk(out_clk));
    
    // Constants for opcodes
    parameter MOVLA = 5'b00000;
    parameter MOVRA = 5'b00001;
    parameter ADDLA = 5'b00111;
    parameter SUBLA = 5'b01000;
    parameter ANDLA = 5'b01011;
    parameter ORLA  = 5'b01101;
    parameter XORLA = 5'b01111;
    parameter ADDAR = 5'b01001;
    parameter SUBAR = 5'b01010;
    parameter ANDAR = 5'b01100;
    parameter ORAR  = 5'b01110;
    parameter XORAR = 5'b10000;
    parameter MOVAR = 5'b00010;
    parameter INCR  = 5'b00101;
    parameter DECR  = 5'b00110;
    parameter NOTR  = 5'b10001;
    parameter ROLC  = 5'b10010;
    parameter RORC  = 5'b10011;
    parameter JMP   = 5'b10101;
    parameter JZ    = 5'b10110;
    parameter JNZ   = 5'b10111;
    parameter JC    = 5'b11000;
    parameter JNC   = 5'b11001;
    parameter MOVIRA= 5'b00011;
    parameter MOVIAR= 5'b00100;
    // Outputs
    
    
    
        always@(*) 
        begin
            case (opcode)
                5'b00000: ALU_OP = 4'b1000; // MOVLA
                5'b00001: ALU_OP = 4'b1000; // MOVRA
                5'b00111: ALU_OP = 4'b0000; // ADDLA
                5'b01000: ALU_OP = 4'b0001; // SUBLA
                5'b01011: ALU_OP = 4'b0100; // ANDLA
                5'b01101: ALU_OP = 4'b0101; // ORLA
                5'b01111: ALU_OP = 4'b0110; // XORLA
    
                5'b01001: ALU_OP = 4'b0000; // ADDAR
                5'b01010: ALU_OP = 4'b0001; // SUBAR
                5'b01100: ALU_OP = 4'b0100; // ANDAR
                5'b01110: ALU_OP = 4'b0101; // ORAR
                5'b10000: ALU_OP = 4'b0110; // XORAR
    
                5'b00010: ALU_OP = 4'b1001; // MOVAR
                5'b00101: ALU_OP = 4'b0010; // INCR
                5'b00110: ALU_OP = 4'b0011; // DECR
                5'b10001: ALU_OP = 4'b0111; // NOTR
                5'b10010: ALU_OP = 4'b1010; // ROLC
                5'b10011: ALU_OP = 4'b1011; // RORC
    
                5'b10101: ALU_OP = 4'b0000; // JMP
                5'b10110: ALU_OP = 4'b0000;// JZ
                5'b10111: ALU_OP = 4'b0000;// JNZ
                5'b11000: ALU_OP = 4'b0000;// JC
                5'b11001: ALU_OP = 4'b0000; // JNC
    
                5'b00011: ALU_OP = 4'b1000; // MOVIRA
                5'b00100: ALU_OP = 4'b1001; // MOVIAR
    
                default: ALU_OP = 4'b0000;
            endcase
        end
    
    always@(*)
    begin
        case(opcode)
            // GROUP A
            5'b00000: ALU_MUX = 1'b0; // MOVLA L
            5'b00001: ALU_MUX = 1'b1; // MOVRA R
            ADDLA: ALU_MUX = 1'b0; // ADDLA
            SUBLA: ALU_MUX = 1'b0; // SUBLA
            ANDLA: ALU_MUX = 1'b0; // ANDLA
            ORLA : ALU_MUX = 1'b0; // ORLA
            XORLA: ALU_MUX = 1'b0; // xORLA
            
            // GROUP A&B
            ADDAR: ALU_MUX = 1'b1; // ADDAR
            SUBAR: ALU_MUX = 1'b1; // SUBAR
            ANDAR: ALU_MUX = 1'b1; // ANDAR
            ORAR : ALU_MUX = 1'b1; // ORAR
            XORAR: ALU_MUX = 1'b1; // XORAR
            
            // GROUP B
            MOVAR: ALU_MUX = 1'b1; // MOVAR
            INCR : ALU_MUX = 1'b1; // INCR
            DECR : ALU_MUX = 1'b1; // DECR
            NOTR : ALU_MUX = 1'b1; // NOTR
            ROLC : ALU_MUX = 1'b1; // ROLC
            RORC : ALU_MUX = 1'b1; // RORC R
            
            // GROUP C 
            JMP : ALU_MUX = 1'b0;
            JZ  : ALU_MUX = 1'b0;
            JNZ : ALU_MUX = 1'b0;
            JC  : ALU_MUX = 1'b0;
            JNC : ALU_MUX = 1'b0;
            
            // GROUP D,E
            MOVIRA: ALU_MUX = 1'b1; // MOVIRA R
            MOVIAR: ALU_MUX = 1'b1; // MOVIAR R
            
            default: ALU_MUX = 1'b0; // Default case, set to '0' for others
        endcase
    end
	 always @(IR_WR_SIGNAL,MDR_WR_SIGNAL,A_WR_SIGNAL,FLAG_WR_SIGNAL,out_clk)
	 begin
	  IR_WR   = IR_WR_SIGNAL & out_clk;
     MDR_WR  = MDR_WR_SIGNAL & out_clk;
     A_WR    = A_WR_SIGNAL & out_clk;
     FLAG_WR = FLAG_WR_SIGNAL & out_clk;
	 
	 end
    
   // assign IR_WR   = IR_WR_SIGNAL & out_clk;
    //assign MDR_WR  = MDR_WR_SIGNAL & out_clk;
    //assign A_WR    = A_WR_SIGNAL & out_clk;
    //assign FLAG_WR = FLAG_WR_SIGNAL & out_clk;
      
      always @(negedge out_clk or posedge Reset_in)
    begin
        if (Reset_in) begin
            current_state <= 4'b0000;
            Reset_out <= 1;
        end else begin
          if (~out_clk) begin
                Reset_out <= 0;
                current_state <= next_state;
            end
        end
    end
    
    always @(current_state)
    begin
        case (current_state)
            4'b0000:
                begin
                    Stat_tst_out <= 4'b0000;
                    IR_WR_SIGNAL <= 1;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 0;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b0001;
                end
    
            4'b0001:
                begin
                    Stat_tst_out <= 4'b0001;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 0;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 1;
                    ALU_EN <= 1;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 1;
                    PC_LOAD <= 1;
                    RAM_MUX <= 0;
                    FLAG_WR_SIGNAL <= 0;
    
                    case (opcode)
                        MOVLA, MOVRA, ADDLA, SUBLA, ANDLA, ORLA, XORLA:
                            next_state <= 4'b0010;
    
                        ADDAR, SUBAR, ANDAR, ORAR, XORAR:
                            if (Distination == 0)
                                next_state <= 4'b0010;
                            else
                                next_state <= 4'b0011;
    
                        MOVAR, INCR, DECR, NOTR, ROLC, RORC:
                            next_state <= 4'b0011;
    
                        JMP:
                            next_state <= 4'b0100;
    
                        JZ:
                            if (zeroFlag == 0)
                                next_state <= 4'b0000;
                            else
                                next_state <= 4'b0100;
    
                        JNZ:
                            if (zeroFlag == 0)
                                next_state <= 4'b0100;
                            else
                                next_state <=4'b0000;
    
                        JC:
                            if (carryFlag == 0)
                                next_state <= 4'b0000;
                            else
                                next_state <= 4'b0100;
    
                        JNC:
                            if (carryFlag == 0)
                                next_state <= 4'b0100;
                            else
                                next_state <= 4'b0000;
    
                        MOVIRA:
                            next_state <= 4'b0101;
    
                        MOVIAR:
                            next_state <= 4'b0111;
    
                        default:
                            next_state <= 4'b0000;
                    endcase
                end
    
            4'b0010:
                begin
                    Stat_tst_out <= 4'b0010;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 1;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 0;
                    FLAG_WR_SIGNAL <= 1;
                    next_state <= 4'b0000;
                end
    
            4'b0011:
                begin
                    Stat_tst_out <= 4'b0011;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 0;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 0;
                    FLAG_WR_SIGNAL <= 1;
                    next_state <= 4'b0000;
                end
    
            4'b0100:
                begin
                    Stat_tst_out <= 4'b0100;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 0;
                    RAM_MUX <= 0;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b0000;
                end
    
            4'b0101:
                begin
                    Stat_tst_out <= 4'b0101;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 0;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 1;
                    ALU_EN <= 1;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 1;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b0110;
                end
    
            4'b0110:
                begin
                    Stat_tst_out <= 4'b0110;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 1;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 1;
                    FLAG_WR_SIGNAL <= 1;
                    next_state <= 4'b0000;
                end
    
            4'b0111:
                begin
                    Stat_tst_out <= 4'b0111;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 1;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b1000;
                end
    
            4'b1000:
                begin
                    Stat_tst_out <= 4'b1000;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 0;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 1;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b1001;
                end
    
            4'b1001:
                begin
                    Stat_tst_out <= 4'b1001;
                    IR_WR_SIGNAL <= 0;
                    RAM_RD <= 1;
                    RAM_WR <= 1;
                    MDR_WR_SIGNAL <= 0;
                    ALU_EN <= 0;
                    A_WR_SIGNAL <= 0;
                    PC_INC <= 0;
                    PC_LOAD <= 1;
                    RAM_MUX <= 1;
                    FLAG_WR_SIGNAL <= 0;
                    next_state <= 4'b0000;
                end
        endcase
    end
    


endmodule
