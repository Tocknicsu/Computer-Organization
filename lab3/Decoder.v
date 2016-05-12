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
    ALUZeroSelect_o,
    MemRead_o,
    MemWrite_o,
    RDWriteBackSelect_o
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
output         ALUZeroSelect_o;
output         MemRead_o;
output         MemWrite_o;
output         RDWriteBackSelect_o;
 
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

assign addi = instr_op_i == 6'b001000;
assign rtype = instr_op_i == 6'b000000 & (funct_i != 3) & (funct_i != 7);
assign beq = instr_op_i == 6'b000100;
assign sltiu = instr_op_i == 6'b001001;
assign ori = instr_op_i == 6'b001101;
assign lui = instr_op_i == 6'b001111;
assign sra = instr_op_i == 6'b000000 & (funct_i == 3);
assign srav = instr_op_i == 6'b000000 & (funct_i == 7);
assign bne = instr_op_i == 6'b000101;
assign jump = instr_op_i == 6'b000010;
assign sw = instr_op_i == 6'b101011;
assign lw = instr_op_i == 6'b100011;

assign ALUSrc1_o = sra;
assign ALUSrc2_o = addi | sltiu | ori | lui | sra | sw | lw;
assign RegWrite_o = addi | rtype | sltiu | ori | lui | sra | srav | lw;
assign RegDst_o = rtype | sra | srav;
assign Branch_o = beq | bne;
assign Jump_o = jump;
assign ImmExtensionSelect_o = sltiu | ori;
assign ExtensionSelect_o = sra;
assign ALUZeroSelect_o = bne;
assign MemRead_o = lw;
assign MemWrite_o = sw;
assign RDWriteBackSelect_o = lw;

assign ALU_op_o[2] = beq | sltiu | lui | bne;
assign ALU_op_o[1] = rtype | beq | sltiu | sra | srav | bne;
assign ALU_op_o[0] = sltiu | ori;

/*
addi: 000
RType: 010
BEQ: 110
SLTIU: 111
ori: 001
lui: 100
sra: 010
srav: 010
bne: 110
jump: xxx


*/

//Main function
/*
always @(*) begin
    case (instr_op_i) 
            end
        end
            end
        6'b101011: //sw
            begin
                RegDst_o = 0; 
                RegWrite_o = 0;
                ALU_op_o = 3'b000;
                ALUSrc1_o = 0;
                ALUSrc2_o = 0;
                Branch_o = 0;
                Jump_o = 0;
                ImmExtensionSelect_o = 0;
                ExtensionSelect_o = 0;
                ALUZeroSelect_o = 0;
            end
        default: ;
    endcase
end
*/

endmodule
