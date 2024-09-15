`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2024 05:35:20 PM
// Design Name: 
// Module Name: branch_control
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


module branch_control # (parameter BITS = 16, parameter OP_BITS = 5)(
    input [BITS-1:0] currPC,
    input [15:0] imm,
    input pcSel,
    input [OP_BITS-1:0] opcode,
    input [BITS-1:0] aBus,
    output reg [BITS-1:0] nextPC
    );
    
    reg temp;
    reg [BITS-1:0] x_nextPC;
    
    always @ * begin
        case(pcSel)
        1'b0: x_nextPC = currPC + 1;
        1'b1: x_nextPC = currPC + imm;
        endcase
    end
    
    wire muxSel;
    
    assign muxSel = (opcode == 5'b11111) ||
                    (opcode == 5'b01101) ||
                    (opcode == 5'b00100);
    
    always @ * begin
        case(muxSel)
            1'b0: nextPC = x_nextPC;
            1'b1: nextPC = aBus;
        endcase
    end
endmodule
