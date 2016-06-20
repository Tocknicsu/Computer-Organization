//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    funct_i,
	RegWrite_o,
	ALU_op_o,
    ALUSrc1_o,
	ALUSrc2_o,
	RegDst_o,
	Branch_o,
    Jump_o,
    ImmExtensionSelect_o,
    ExtensionSelect_o,
    ALUBranchZeroSelect_o,
    ALUBranchResultSelect_o,
    MemRead_o,
    MemWrite_o,
    RDWriteBackSelect_o,
    jal_o,
    jr_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input  [6-1:0] funct_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc1_o;
output         ALUSrc2_o;
output         RegDst_o;
output         Branch_o;
output         Jump_o;
output         ImmExtensionSelect_o;
output         ExtensionSelect_o;
output         ALUBranchZeroSelect_o;
output         ALUBranchResultSelect_o;
output         MemRead_o;
output         MemWrite_o;
output         RDWriteBackSelect_o;
output         jal_o;
output         jr_o;
 
//Internal Signals

reg zero = 0;


//Parameter
wire addi;
wire rtype;
wire beq;
wire sltiu;
wire ori;
wire lui;
wire sra;
wire srav;
wire bne;
wire jump;
wire jal;
wire jr;
wire ble;
wire bnez;
wire bltz;

assign addi = instr_op_i == 6'b001000 | instr_op_i == 6'b001111; //addi or li
assign rtype = instr_op_i == 6'b000000 & (funct_i != 3) & (funct_i != 7) & (funct_i != 8);
assign beq = instr_op_i == 6'b000100;
assign sltiu = instr_op_i == 6'b001001;
assign ori = instr_op_i == 6'b001101;
/* cancel lui */
assign lui = instr_op_i == 6'b001111 & 0;
assign sra = instr_op_i == 6'b000000 & (funct_i == 3);
assign srav = instr_op_i == 6'b000000 & (funct_i == 7);
assign bne = instr_op_i == 6'b000101; // bne or bnez
assign jump = instr_op_i == 6'b000010;
assign sw = instr_op_i == 6'b101011;
assign lw = instr_op_i == 6'b100011;
assign jal = instr_op_i == 6'b000011;
assign jr = instr_op_i == 6'b000000 & (funct_i == 8);
assign ble = instr_op_i == 6'b000110;
assign bltz = instr_op_i == 6'b000001;

assign ALUSrc1_o = sra;
assign ALUSrc2_o = addi | sltiu | ori | lui | sra | sw | lw;
assign RegWrite_o = addi | rtype | sltiu | ori | lui | sra | srav | lw | jal;
assign RegDst_o = rtype | sra | srav;
assign Branch_o = beq | bne | ble | bltz;
assign Jump_o = jump | jal;
assign ImmExtensionSelect_o = sltiu | ori;
assign ExtensionSelect_o = sra;
assign ALUBranchZeroSelect_o = bne;
assign ALUBranchResultSelect_o = ble | bltz;
assign MemRead_o = lw;
assign MemWrite_o = sw;
assign RDWriteBackSelect_o = lw;
assign jal_o = jal;
assign jr_o = jr;

assign ALU_op_o[2] = beq | sltiu | lui | bne | ble | bltz;
assign ALU_op_o[1] = rtype | beq | sltiu | sra | srav | bne | bltz;
assign ALU_op_o[0] = sltiu | ori | ble | bltz;

/*
addi: 000
ori: 001
RType: 010
sra: 010
srav: 010
lui: 100
ble: 101
BEQ: 110
bne: 110
SLTIU: 111
bltz: 111
jump: xxx

011, 101
*/

endmodule
