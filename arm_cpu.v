`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/26/2024 05:26:05 PM
// Design Name: 
// Module Name: arm_cpu
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


module arm_cpu #(parameter BITS = 16,
                 parameter RBITS = 3)(
    input [BITS-1:0] in,
    input clk,
    input rst_n,
    output [BITS-1:0] out,
    output reg [BITS-1:0] mem_addr,
    output reg [BITS-1:0] mem_data,
    input [BITS-1:0] mem_data_out,
    output mem_rd,
    output mem_wr
    );
    
    localparam OP_BITS = 5;
    localparam COND_BITS = 4;
    
    wire [BITS-1:0] instr;
    wire [RBITS-1:0] aSel;
    wire [RBITS-1:0] bSel;
    wire [RBITS-1:0] wSel;
    wire [OP_BITS-1:0] aluOp;
    wire [4:0] imm5;
    wire [7:0] imm8;
    wire [10:0] imm11;
    
    wire condUpdate;
    wire memRd;
    wire memWr;
    wire regWr;
    
    instruction_decoder #( .BITS(BITS), .RBITS(RBITS), .OP_BITS(OP_BITS))
    instr_decode(.instr(instr), .cond_update(condUpdate), .mem_rd(memRd), .mem_wr(memWr), .reg_wr(regWr),
    .op(aluOp), .aSel(aSel), .bSel(bSel), .wSel(wSel), .imm5(imm5), .imm8(imm8), .imm11(imm11));
    
    wire [BITS-1:0] regIn;
    wire [BITS-1:0] aOut;
    wire [BITS-1:0] bOut;
    wire [BITS-1:0] wOut;
    
    registers  #( .BITS(BITS), .RBITS(RBITS))
    reg_module(.clk(clk), .rst(rst), .write_en(regWr), .w_in(regIn), .a_sel(aSel), .b_sel(bSel), .w_sel(wSel),
    .a_bus(aOut), .b_bus(bOut), .w_out(wOut));
    
    wire [BITS-1:0] aBus;
    reg [BITS-1:0] currPC;
    wire [BITS-1:0] bBus;
    wire [BITS-1:0] wBus;
    
    aBusSelect # ( .BITS(BITS), .OP_BITS(OP_BITS))
    aBusSelector(.AOut(aOut), .WOut(wOut), .PC(currPC), .opcode(aluOp),. ABus(aBus));
    
    bBusSelect # ( .BITS(BITS), .OP_BITS(OP_BITS))
    bBusSelector(.BOut(bOut), .imm5(imm5), .imm8(imm8), .imm11(imm11), .opcode(aluOp), .BBus(bBus));
    
    wire [BITS-1:0] aluOut;
    wire [BITS-1:0] dataOut;
    wire [BITS-1:0] shiftOut;
    
    wBusSelect # ( .BITS(BITS), .OP_BITS(OP_BITS))
    wBusSelector(.aluOut(aluOut), .dataOut(mem_data_out), .shiftOut(shiftOut),
                            .PC(currPC), .opcode(aluOp), .wBusOut(regIn));
    
    wire [COND_BITS-1:0] x_condCodes;
    reg [COND_BITS-1:0] condCodes;
                            
    alu # ( .BITS(BITS), .OP_BITS(OP_BITS), .COND_BITS(COND_BITS))
    alu_inst(.a(aBus), .b(bBus), .op(aluOp), .out(aluOut), .cond_code(x_condCodes));
    
    shifter # ( .BITS(BITS), .OP_BITS(OP_BITS))
    shift_inst(.aBus(aBus), .imm5(bBus), .shift_op(aluOp), .shift_out(shiftOut));
    
    wire b_en;
    wire [BITS-1:0] nextPC;
    
    branch_control # ( .BITS(BITS), .OP_BITS(OP_BITS))
    branch_ctrl_inst(.currPC(currPC), .imm(bBus), .aBus(aBus), .pcSel(b_en), .opcode(aluOp),
                                   .nextPC(nextPC));
                                   
    branch_en # ( .OP_BITS(OP_BITS), .COND_BITS(COND_BITS))
    branch_en_inst(.opcode(aluOp), .cond_code(condCodes), .en(b_en));
    
    always @ (negedge rst_n, posedge clk) begin
        if(~rst_n) begin
            condCodes <= 0;
            currPC <= 0;
        end
        else begin
            currPC <= nextPC;
            if(condUpdate) begin
                condCodes <= x_condCodes;
            end
            else begin
                condCodes <= condCodes;
            end
        end
    end
    
    always @ * begin
        case(aluOp[OP_BITS-1])
            1'b0: begin
                mem_addr = aluOut;
                mem_data = wOut;
            end
            1'b1: begin
                mem_addr = 16'hffff;
                mem_data = bBus;
            end
        endcase
    end
    
    assign mem_rd = memRd;
    assign mem_wr = memWr;
    
    assign instr = in;
    assign out = currPC;
    
endmodule
