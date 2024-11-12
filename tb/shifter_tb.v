`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2024 02:40:06 PM
// Design Name: 
// Module Name: shifter_tb
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


module shifter_tb();
    reg [15:0] aBus;
    reg [15:0] imm5;
    reg [4:0] shift_op;
    wire [15:0] shift_out;
    
    integer i;
    integer j;

    shifter dut(.aBus(aBus), .imm5(imm5), .shift_op(shift_op), .shift_out(shift_out));

    //Monitor operations performed by the shifter unit inside the ARM Processor
    initial begin
        aBus = 16'hf084;
        $monitor("a:%b\n  imm5:%d  op:%b\n  out:%b\n", aBus, imm5, shift_op, shift_out);
        for(i = 8; i < 23; i = i + 1) begin
        if (i == 8 || i == 10 || i == 14 || i == 22) begin
            shift_op = i;
            for(j = 0; j < 32; j = j + 1) begin
                imm5 = j;
                #5;
            end
        end
        end
        $finish;
    end

endmodule
