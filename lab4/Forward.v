
module Forward(
    WB_RegWrite_i,
    WB_RegDst_i,
    MEM_RegWrite_i,
    MEM_RegDst_i,
    EX_RSaddr_i,
    EX_RTaddr_i,
    EX_Src1_Forward_o,
    EX_Src2_Forward_o
	);

input WB_RegWrite_i;
input [5-1:0] WB_RegDst_i;
input MEM_RegWrite_i;
input [5-1:0] MEM_RegDst_i;
input [5-1:0] EX_RSaddr_i;
input [5-1:0] EX_RTaddr_i;
output [2-1:0] EX_Src1_Forward_o;
output [2-1:0] EX_Src2_Forward_o;
reg [2-1:0] EX_Src1_Forward_o;
reg [2-1:0] EX_Src2_Forward_o;



always @(*) begin
    EX_Src1_Forward_o = 0;
    EX_Src2_Forward_o = 0;
    if (WB_RegWrite_i & WB_RegDst_i != 0 & (WB_RegDst_i == EX_RSaddr_i))
        EX_Src1_Forward_o = 2;
    if (WB_RegWrite_i & WB_RegDst_i != 0 & (WB_RegDst_i == EX_RTaddr_i))
        EX_Src2_Forward_o = 2;
    if (MEM_RegWrite_i & MEM_RegDst_i != 0 & (MEM_RegDst_i == EX_RSaddr_i)) 
        EX_Src1_Forward_o = 1;
    if (MEM_RegWrite_i & MEM_RegDst_i != 0 & (MEM_RegDst_i == EX_RTaddr_i)) 
        EX_Src2_Forward_o = 1;
end
     
//I/O ports
endmodule
