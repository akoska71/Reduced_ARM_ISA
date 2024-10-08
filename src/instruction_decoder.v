`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: AJ Koska
// 
// Create Date: 08/10/2024 11:10:15 PM
// Module Name: instruction_decoder
// Description: Instruction Decoder Module for reduced ARM ISA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_decoder # (parameter BITS = 16,
                              parameter RBITS = 3,
                              parameter OP_BITS = 5)(
        input [BITS-1:0] instr,
        output cond_update,
        output mem_rd,
        output mem_wr,
        output reg_wr,
        output [OP_BITS-1:0] op,
        output [RBITS-1:0] wSel,
        output [RBITS-1:0] aSel,
        output [RBITS-1:0] bSel,
        output [4:0] imm5,
        output [7:0] imm8,
        output [10:0] imm11
    );
    
    wire [OP_BITS-1:0] opCode;
    assign opCode = instr[15:11];
    
    wire A,B,C,D,E;
    assign A = opCode[4];
    assign B = opCode[3];
    assign C = opCode[2];
    assign D = opCode[1];
    assign E = opCode[0];

    //Update Condition Code Register
    assign cond_update = (&{!B, !D, E}) ||
                         (&{!B, !C, !E}) ||
                         (&{!A, !C, !D, E}) ||
                         (&{!A, B, C, !D, !E});

    //Memory Read Enable
    assign mem_rd = &{E, C ,D ,!A};
    //Memory Write Enable
    assign mem_wr = (&{E, D, !C, !A}) || (&(opCode));
    //Register Write Enable
    assign reg_wr = (&{!A, !C, !D}) ||
                    (&{!A, B, C}) ||
                    (&{!A, D, !E}) ||
                    (&{!B, C, D}) ||
                    (&{A, !B, !C}) ||
                    (&{A, !B, !D, !E});

    //Register Select Values
    assign wSel = instr[10:8];
    assign aSel = instr[7:5];
    assign bSel = instr[4:2];
    //Immediate Values
    assign imm5 = instr[4:0];
    assign imm8 = instr[7:0];
    assign imm11 = instr[10:0];
    
    assign op = opCode;
    
endmodule
