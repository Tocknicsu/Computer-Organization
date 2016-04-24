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
    SE_o,
    ALUZero_o
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
output         SE_o;
output         ALUZero_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc1_o;
reg            ALUSrc2_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            SE_o;
reg            ALUZero_o;

//Parameter


//Main function
always @(*) begin
    case (instr_op_i) 
        6'b000000: begin // R-Type
            if (funct_i == 3) begin
                RegDst_o = 1; RegWrite_o = 1; ALU_op_o = 3'b010; ALUSrc1_o = 1; ALUSrc2_o = 1; Branch_o = 0; SE_o = 1;ALUZero_o = 0; 
            end else if(funct_i == 7) begin
                RegDst_o = 1; RegWrite_o = 1; ALU_op_o = 3'b010; ALUSrc1_o = 0; ALUSrc2_o = 0; Branch_o = 0; SE_o = 0;ALUZero_o = 0; 
            end else begin
                RegDst_o = 1; RegWrite_o = 1; ALU_op_o = 3'b010; ALUSrc1_o = 0; ALUSrc2_o = 0; Branch_o = 0; SE_o = 0;ALUZero_o = 0; 
            end
        end
        6'b001000: //Addi
            begin RegDst_o = 0; RegWrite_o = 1; ALU_op_o = 3'b000; ALUSrc1_o = 0; ALUSrc2_o = 1; Branch_o = 0; SE_o = 0; ALUZero_o = 0; end
        6'b000100: //BEQ
            begin RegDst_o = 0; RegWrite_o = 0; ALU_op_o = 3'b110; ALUSrc1_o = 0; ALUSrc2_o = 0; Branch_o = 1; SE_o = 0; ALUZero_o = 0; end
        6'b001001: //SLTIU
            begin RegDst_o = 0; RegWrite_o = 1; ALU_op_o = 3'b111; ALUSrc1_o = 0; ALUSrc2_o = 1; Branch_o = 0; SE_o = 0; ALUZero_o = 0; end
        6'b001101: //ORI
            begin RegDst_o = 0; RegWrite_o = 1; ALU_op_o = 3'b001; ALUSrc1_o = 0; ALUSrc2_o = 1; Branch_o = 0; SE_o = 0; ALUZero_o = 0; end
        6'b001111: //LUI
            begin RegDst_o = 0; RegWrite_o = 1; ALU_op_o = 3'b100; ALUSrc1_o = 0; ALUSrc2_o = 1; Branch_o = 0; SE_o = 0; ALUZero_o = 0; end
        6'b000101: //BNE
            begin RegDst_o = 0; RegWrite_o = 0; ALU_op_o = 3'b110; ALUSrc1_o = 0; ALUSrc2_o = 0; Branch_o = 1; SE_o = 0; ALUZero_o = 1; end
        default: ;
    endcase
        
        
end

endmodule
