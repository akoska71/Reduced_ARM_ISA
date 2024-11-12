`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2024 11:35:21 PM
// Design Name: 
// Module Name: instruction_decoder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:Testbench to observe control signals being generated
// by the Instruction Decoder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_decoder_tb();
    reg [15:0] instr;
    wire cond_update;
    wire mem_wr;
    wire mem_rd;
    wire reg_wr;
    wire [2:0] wSel;
    wire [2:0] aSel;
    wire [2:0] bSel;
    wire [4:0] imm5;
    wire [7:0] imm8;
    wire [10:0] imm11;
    
    integer i;
    
    instruction_decoder dut (.instr(instr), .cond_update(cond_update), .mem_wr(mem_wr), .mem_rd(mem_rd),
                             .reg_wr(reg_wr), .wSel(wSel), .aSel(aSel), .bSel(bSel), .imm5(imm5), .imm8(imm8), .imm11(imm11));

    //Monitor signals generated depending on the operation sent to the ALU.
    initial begin
        instr[10:0] = 0;
        $monitor("Instr:%d\nCon:%d  Mem_wr:%b  Mem_rd:%b  Reg_wr:%b \nwSel:%b aSel:%b bSel:%b imm5:%b imm8:%b imm11:%b\n",
         instr[15:11], cond_update, mem_wr, mem_rd, reg_wr, wSel, aSel, bSel, imm5, imm8, imm11);
        for(i = 0; i < 32; i = i + 1) begin
            instr[15:11] = i;
            #5;
        end
        $finish;
    end
endmodule
