`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: AJ Koska
// 
// Create Date: 08/26/2024 04:04:38 AM
// Module Name: aBusSelect
// Description: Module for controlling MUX select signals of the A Bus
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module aBusSelect #(parameter BITS = 16, parameter OP_BITS = 5)(
    input [BITS-1:0] AOut,
    input [BITS-1:0] WOut,
    input [BITS-1:0] PC,
    input [OP_BITS-1:0] opcode,
    output reg [BITS-1:0] ABus
    );
    
    wire [1:0] MUXSel;

    //Control Signals for A Bus Mux Calculations
    //Simplfied to make for effiecient and simple logic calcuations
    assign MUXSel[1] = (&{opcode[3], opcode[2], !opcode[1], !opcode[0]}) ||
                       (&{opcode[4], opcode[3]}) ||
                       (&{opcode[4], opcode[1], opcode[0]});
    assign MUXSel[0] = opcode[4];
    
    always @ * begin
        case(MUXSel)
            2'b00: ABus = AOut;
            2'b01: ABus = !AOut;
            2'b10: ABus = WOut;
            2'b11: ABus = PC;
        endcase
    end
    
endmodule
