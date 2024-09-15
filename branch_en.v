`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2024 05:41:42 PM
// Design Name: 
// Module Name: branch_en
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


module branch_en # (parameter OP_BITS = 5, parameter COND_BITS = 4)(
    input [OP_BITS-1:0] opcode,
    input [COND_BITS-1:0] cond_code,
    output en
    );
    
    wire branch_req;
    wire [2:0] branch_type;
    assign branch_req = (&{opcode[3], opcode[4]}) ||
                        (&{opcode[4], !opcode[3], opcode[1], opcode[0]});    
    assign branch_type = {opcode[2], opcode[1], opcode[0]};
    
    reg x_en;
    wire n_xnor_z;
    assign n_xnor_z = !(cond_code[2] ^ cond_code[3]);
    
    always @ * begin
        case(branch_type)
        3'b000: x_en = 1'b1;
        3'b001: x_en = &{!cond_code[0], n_xnor_z};
        3'b010: x_en = cond_code[0];
        3'b011: x_en = n_xnor_z;
        3'b100: x_en = !n_xnor_z;
        3'b101: x_en = !cond_code[0];
        3'b110: x_en = !(&{n_xnor_z, !cond_code[0]});
        3'b111: x_en = 1'b1;
        endcase
    end
    
    assign en = branch_req && x_en;
    
endmodule
