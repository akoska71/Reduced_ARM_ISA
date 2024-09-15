module bBusSelect # (parameter BITS = 16, parameter OP_BITS = 5)(
    input [BITS-1:0] BOut,
    input [4:0] imm5,
    input [7:0] imm8,
    input [10:0] imm11,
    input [OP_BITS-1:0] opcode,
    output reg [BITS-1:0] BBus
);

    wire [2:0] MUXSel;
    
    assign MUXSel[0] = (&{opcode[4], !opcode[1], !opcode[0]}) ||
                       (&{opcode[4], opcode[3]}) ||
                       (&{opcode[1], opcode[3]}) ||
                       (&{opcode[3], !opcode[0]}) ||
                       (&{opcode[3], !opcode[2]});
                       
     assign MUXSel[1] = (&{!opcode[3], opcode[2], !opcode[1], !opcode[0]}) ||
                        (&{!opcode[4], opcode[3], opcode[2], !opcode[1]}) ||
                        (&{opcode[4], !opcode[3], opcode[2]}) ||
                        (&{opcode[4], !opcode[3], !opcode[1]});
                        
     assign MUXSel[2] = (&{opcode[4], opcode[3]}) ||
                        (&{!opcode[4], opcode[2], !opcode[1], !opcode[0]}) ||
                        (&{opcode[4], !opcode[2], opcode[1]});
     
     wire [15:0] signex_imm5;
     wire [15:0] signex_imm8;
     wire [15:0] signex_imm11;
     
     assign signex_imm5 = {imm5[4], imm5[4], imm5[4], imm5[4], imm5[4], imm5[4], imm5[4], imm5[4],
                           imm5[4], imm5[4], imm5[4], imm5};
                           
     assign signex_imm8 = {imm8[7], imm8[7], imm8[7], imm8[7], imm8[7], imm8[7], imm8[7], imm8[7], imm8};                      
                
     assign signex_imm11 = {imm11[10], imm11[10], imm11[10], imm11[10], imm11[10], imm11};
                
     always @ * begin
        case(MUXSel)
            3'b000: BBus = BOut;
            3'b001: BBus = signex_imm5;
            3'b010: BBus = signex_imm8;
            3'b011: BBus = {5'b00000, imm11};
            3'b100: BBus = {5'b11111, imm11};
            3'b101: BBus = signex_imm11;
            3'b110: BBus = 0;
            3'b111: BBus = 0;
        endcase
     end

endmodule
