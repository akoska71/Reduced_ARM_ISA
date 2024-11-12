`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2024 02:51:59 PM
// Design Name: 
// Module Name: alu_test
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


module alu_test();
    reg [15:0] a;
    reg [15:0] b;
    reg [4:0] op;
    wire [3:0] cond_code;
    wire [15:0] out;
    integer i;

    alu dut(.a(a), .b(b), .op(op), .cond_code(cond_code), .out(out));

    //Uses monitor to print exact values that ALU is printing,
    //Confirm that values are right based off of printed values.
    initial begin
        a = 16'h0084;
        b = 16'h009d;
        $monitor("a:%d  b:%d  op:%b  out:%d  cond_code%b time:%0tps", a, b, op, out, cond_code, $time);
        for(i = 0; i < 32; i = i + 1) begin
            op = i;
            #5;
        end
        $finish;
    end
endmodule
