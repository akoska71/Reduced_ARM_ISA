`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: AJ Koska
// 
// Create Date: 08/11/2024 02:13:08 PM
// Design Name: 
// Module Name: shifter
// Description: shifter module for performing all bit shift operations as well as
// movis(move into high bits) instruction
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shifter # (parameter BITS = 16, parameter OP_BITS = 5)(
    input signed [BITS-1:0] aBus,
    input [BITS-1:0] imm5,
    input [OP_BITS-1:0] shift_op,
    output reg [BITS-1:0] shift_out
    );
    
    wire [1:0] shift_sel;
    
    assign shift_sel = shift_op[1:0];
    
    wire [BITS-1:0] arith_r_shift;
    wire [BITS-1:0] logic_r_shift;
    wire [BITS-1:0] rotate_r;
    
    reg [BITS-1:0] logic_l_shift;
    wire [BITS-1:0] extend;
    wire [BITS-1:0] x_lshift_imm5;
    wire [BITS-1:0] y_lshift_imm5;
    reg [3:0] l_shift;
    
    wire [7:0] sign_extend;
    assign sign_extend = 8'b00000000;
    
    assign extend = {sign_extend, aBus[7:0]};
    
    wire [(BITS*2)-1:0] rotate_tmp;
    
    reg [1:0] muxSel;

    //Arithmatic Right Shift
    assign arith_r_shift = aBus >>> imm5[3:0];
    //Logical Right Shift
    assign logic_r_shift = aBus >> imm5[3:0];

    //Rotate Right
    assign rotate_tmp = {aBus, aBus} >> imm5[3:0];
    assign rotate_r = rotate_tmp[15:0]; 

    always @ * begin
        case(shift_op[1])
            1'b0: l_shift = 0;
            1'b1: l_shift = 8;
       endcase
    end

    //movis operation
    assign x_lshift_imm5 = imm5 << l_shift;
    assign y_lshift_imm5 = extend | x_lshift_imm5;
    
    always @ * begin
        case(shift_op[1])
            1'b0: logic_l_shift = x_lshift_imm5;
            1'b1: logic_l_shift = y_lshift_imm5;
        endcase
    end
    
    
    always @ * begin
        muxSel = {shift_op[2] ,!shift_op[4] & shift_op[1]};
        case(muxSel)
            2'b00: shift_out = arith_r_shift; //ash
            2'b01: shift_out = logic_r_shift; //lsh
            2'b10: shift_out = logic_l_shift; //movis
            2'b11: shift_out = rotate_r; //rot
        endcase
    end
    
endmodule
