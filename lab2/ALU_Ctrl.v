//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(*) begin
    casez ({ALUOp_i, funct_i})
        9'b000??????: ALUCtrl_o = 4'b0010;  //Addi
        9'b010100101: ALUCtrl_o = 4'b0001;  //Or
        9'b010100000: ALUCtrl_o = 4'b0010;  //Add
        9'b110??????: ALUCtrl_o = 4'b0110;  //Beq
        9'b111??????: ALUCtrl_o = 4'b1111;  //SLTIU
        9'b010101010: ALUCtrl_o = 4'b0111;  //SLT
        9'b010100100: ALUCtrl_o = 4'b0000;  //AND
        9'b010100010: ALUCtrl_o = 4'b0110;  //SUB
        9'b001??????: ALUCtrl_o = 4'b1001;  //ORI
        9'b100??????: ALUCtrl_o = 4'b1110;  //LUI
        9'b010000011: ALUCtrl_o = 4'b1101;  //SRA
        9'b010000111: ALUCtrl_o = 4'b1010;  //SRAV
        9'b000101010: ALUCtrl_o = 4'b0110;  //BNE
    endcase
end

endmodule     





                    
                    
