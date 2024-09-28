`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: AJ Koska
// 
// Create Date: 08/26/2024 05:53:00 PM
// Module Name: wBusSelect
// Description: Module for producing control signals for the W Bus MUX select signals
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wBusSelect # (parameter BITS = 16, parameter OP_BITS = 5)(
    input [BITS-1:0] aluOut,
    input [BITS-1:0] dataOut,
    input [BITS-1:0] shiftOut,
    input [BITS-1:0] PC,
    input [OP_BITS-1:0] opcode,
    output reg [BITS-1:0] wBusOut
    );
    
    wire [1:0] MUXSel;

    //W Bus MUX Select Calculations
    assign MUXSel[0] = &{opcode[2], opcode[0]};
    
    assign MUXSel[1] = (&{opcode[2], !opcode[1], opcode[0]}) ||
                       (&{opcode[3], !opcode[2], !opcode[0]}) ||
                       (&{opcode[2], opcode[1], !opcode[0]}) ||
                       (&{opcode[4], opcode[2]});
    
    always @ * begin
        case(MUXSel)
            2'b00: wBusOut = aluOut;
            2'b01: wBusOut = dataOut;
            2'b10: wBusOut = shiftOut;
            2'b11: wBusOut = PC;
        endcase
    end
endmodule
