
module Hazard(
    EX_MemRead_i,
    EX_RTaddr_i,
    ID_RSaddr_i,
    ID_RTaddr_i,
    MEM_pc_select_i,
    IF_ID_FLUSH_o,
    ID_EX_FLUSH_o,
    EX_MEM_FLUSH_o,
    IF_PC_Write_o
	);

input EX_MemRead_i;
input [5-1:0] EX_RTaddr_i;
input [5-1:0] ID_RSaddr_i;
input [5-1:0] ID_RTaddr_i;
input MEM_pc_select_i;

output IF_ID_FLUSH_o;
output ID_EX_FLUSH_o;
output EX_MEM_FLUSH_o;

output IF_PC_Write_o;

reg IF_ID_FLUSH_o;
reg ID_EX_FLUSH_o;
reg EX_MEM_FLUSH_o;

reg IF_PC_Write_o;

always @(*) begin
    IF_ID_FLUSH_o = 0;
    ID_EX_FLUSH_o = 0;
    EX_MEM_FLUSH_o = 0;

    IF_PC_Write_o = 1;
    if (EX_MemRead_i & ((EX_RTaddr_i == ID_RSaddr_i) | (EX_RTaddr_i == ID_RTaddr_i))) begin
        IF_ID_FLUSH_o = 1;
        ID_EX_FLUSH_o = 1;
        IF_PC_Write_o = 0;
    end

    if(MEM_pc_select_i) begin
        IF_ID_FLUSH_o = 1;
        ID_EX_FLUSH_o = 1;
        EX_MEM_FLUSH_o = 1;
    end


end
     
//I/O ports
endmodule
