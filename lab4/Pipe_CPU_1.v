//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] IF_pc_in;
wire [32-1:0] IF_pc_out;

wire [32-1:0] IF_const_32d4;
assign IF_const_32d4 = 4;

wire [32-1:0] IF_pc_out_plus_4;

wire [32-1:0] IF_instr;
/**** IF/ID stage ****/
wire [32 + 32 - 1 :0] IF_ID_PIPE_i;
wire [32 + 32 - 1 :0] IF_ID_PIPE_o;

assign IF_ID_PIPE_i = {IF_instr, IF_pc_out};
wire IF_ID_PIPE_rst_i;
assign IF_ID_PIPE_rst_i = rst_i;
/**** ID stage ****/
wire [32-1:0] ID_instr;
wire [32-1:0] ID_pc_in;
assign {ID_instr, ID_pc_in} = IF_ID_PIPE_o;
wire [32-1:0] ID_RSdata;
wire [32-1:0] ID_RTdata;

wire [32-1:0] ID_ImmUnsignExtensionResult;
wire [32-1:0] ID_ImmSignExtensionResult;
wire [32-1:0] ID_ShamtUnsignExtensionResult;

wire ID_RegWrite;
wire [3-1:0] ID_ALU_op; 
wire ID_ALUSrc1select;
wire ID_ALUSrc2select;
wire ID_RegDst;
wire ID_Branch;
wire ID_ImmExtensionSelect;
wire ID_ExtensionSelect;
wire ID_ALUBranchZeroSelect;
wire ID_MemRead;
wire ID_MemWrite;
wire ID_RDWriteBackSelect;
/**** ID/EX ****/
wire [32+32+1+3+10+32*5-1:0] ID_EX_PIPE_i;
wire [32+32+1+3+10+32*5-1:0] ID_EX_PIPE_o;
wire ID_EX_PIPE_rst_i;
assign ID_EX_PIPE_rst_i = rst_i;

assign ID_EX_PIPE_i = {
    ID_instr, //32
    ID_pc_in, //32
    ID_RegWrite, //1
    ID_ALU_op, //3
    ID_ALUSrc1select, //1
    ID_ALUSrc2select, //1
    ID_RegDst, //1
    ID_Branch, //1
    ID_ImmExtensionSelect, //1
    ID_ExtensionSelect, //1 
    ID_ALUBranchZeroSelect, //1
    ID_MemRead, //1
    ID_MemWrite,//1
    ID_RDWriteBackSelect, //1
    ID_RSdata, //32
    ID_RTdata, //32
    ID_ImmSignExtensionResult, //32
    ID_ImmUnsignExtensionResult, //32
    ID_ShamtUnsignExtensionResult //32
};

/**** EX stage ****/
wire [32-1:0] EX_instr;
wire [32-1:0] EX_pc_in;
wire EX_RegWrite;
wire [3-1:0] EX_ALU_op; 
wire EX_ALUSrc1select;
wire EX_ALUSrc2select;
wire EX_RegDst;
wire EX_Branch;
wire EX_ImmExtensionSelect;
wire EX_ExtensionSelect;
wire EX_ALUBranchZeroSelect;
wire EX_MemRead;
wire EX_MemWrite;
wire EX_RDWriteBackSelect;
wire [32-1:0] EX_RSdata;
wire [32-1:0] EX_RTdata;
wire [32-1:0] EX_ImmUnsignExtensionResult;
wire [32-1:0] EX_ImmSignExtensionResult;
wire [32-1:0] EX_ShamtUnsignExtensionResult;

assign {
    EX_instr, //32
    EX_pc_in, //32
    EX_RegWrite, //1
    EX_ALU_op, //3
    EX_ALUSrc1select, //1
    EX_ALUSrc2select, //1
    EX_RegDst, //1
    EX_Branch, //1
    EX_ImmExtensionSelect, //1
    EX_ExtensionSelect, //1 
    EX_ALUBranchZeroSelect, //1
    EX_MemRead, //1
    EX_MemWrite,//1
    EX_RDWriteBackSelect, //1
    EX_RSdata, //32
    EX_RTdata, //32
    EX_ImmSignExtensionResult, //32
    EX_ImmUnsignExtensionResult, //32
    EX_ShamtUnsignExtensionResult //32
} = ID_EX_PIPE_o;

wire [4-1:0] EX_ALUCtrl;
wire [32-1:0] EX_ImmExtensionResult;
wire [32-1:0] EX_ExtensionResult;
wire [32-1:0] EX_ALUsrc1;
wire [32-1:0] EX_ALUsrc2;
wire [32-1:0] EX_ALUresult;
wire EX_ALUzero;

wire [5-1:0] EX_RegDstResult;
wire [32-1:0] EX_BranchShifterResult;
wire [32-1:0] EX_pc_out;

wire [5-1:0] EX_RSaddr;
assign EX_RSaddr = EX_instr[25:21];
wire [5-1:0] EX_RTaddr;
assign EX_RTaddr = EX_instr[20:16];


wire [2-1:0] EX_Src1_Forward;
wire [2-1:0] EX_Src2_Forward;

wire [32-1:0] EX_Real_RSdata;
wire [32-1:0] EX_Real_RTdata;

/**** EX/MEM ****/
wire [32+6+2*32+1+5-1:0] EX_MEM_PIPE_i;
wire [32+6+2*32+1+5-1:0] EX_MEM_PIPE_o;
wire EX_MEM_PIPE_rst_i;
assign EX_MEM_PIPE_rst_i = rst_i;

assign EX_MEM_PIPE_i = {
    EX_pc_out, //32
    EX_RegWrite, //1
    EX_Branch, //1
    EX_ALUBranchZeroSelect, //1
    EX_MemRead, //1
    EX_MemWrite,//1
    EX_RDWriteBackSelect, //1
    EX_RTdata, //32
    EX_ALUresult, //32
    EX_ALUzero, //1
    EX_RegDstResult //5
};

/**** MEM stage ****/
wire [32-1:0] MEM_pc_out;
wire MEM_RegWrite;
wire MEM_Branch;
wire MEM_ALUBranchZeroSelect;
wire MEM_MemRead;
wire MEM_MemWrite;
wire MEM_RDWriteBackSelect;
wire [32-1:0] MEM_RTdata;
wire [32-1:0] MEM_ALUresult;
wire MEM_ALUzero;
wire [5-1:0] MEM_RegDstResult;

assign {
    MEM_pc_out, //32
    MEM_RegWrite, //1
    MEM_Branch, //1
    MEM_ALUBranchZeroSelect, //1
    MEM_MemRead, //1
    MEM_MemWrite,//1
    MEM_RDWriteBackSelect, //1
    MEM_RTdata, //32
    MEM_ALUresult, //32
    MEM_ALUzero, //1
    MEM_RegDstResult //5
} = EX_MEM_PIPE_o;

wire [32-1:0] MEM_MemResult;
wire MEM_pc_select;
assign MEM_pc_select = MEM_Branch & (MEM_ALUBranchZeroSelect ^ MEM_ALUzero); 

/**** MEM/WB ****/
wire [1*2 + 32*2 + 5-1:0] MEM_WB_PIPE_i;
wire [1*2 + 32*2 + 5-1:0] MEM_WB_PIPE_o;
wire MEM_WB_PIPE_rst_i;
assign MEM_WB_PIPE_rst_i = rst_i;

assign MEM_WB_PIPE_i = {
    MEM_RegWrite, //1
    MEM_RDWriteBackSelect, //1
    MEM_MemResult, //32
    MEM_ALUresult, //32
    MEM_RegDstResult //5
};

/**** WB stage ****/
wire WB_RegWrite;
wire WB_RDWriteBackSelect;
wire [5-1:0] WB_RegDstResult;
wire [32-1:0] WB_MemResult;
wire [32-1:0] WB_ALUresult;
wire [32-1:0] WB_RDdata;
assign {
    WB_RegWrite, //1
    WB_RDWriteBackSelect, //1
    WB_MemResult, //32
    WB_ALUresult, //32
    WB_RegDstResult //5
} = MEM_WB_PIPE_o;


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux_PC(
    .data0_i(IF_pc_out_plus_4),
    .data1_i(MEM_pc_out),
    .select_i(MEM_pc_select),
    .data_o(IF_pc_in)
    );	

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_in_i(IF_pc_in),
    .pc_out_o(IF_pc_out)
    );

Instr_Memory IM(
    .addr_i(IF_pc_out),
    .instr_o(IF_instr)
    );

Adder Add_pc(
    .src1_i(IF_pc_out),
    .src2_i(IF_const_32d4),
    .sum_o(IF_pc_out_plus_4)
    );

Pipe_Reg #(.size(32+32)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
    .rst_i(IF_ID_PIPE_rst_i),
    .data_i(IF_ID_PIPE_i),
    .data_o(IF_ID_PIPE_o)
    );

//Instantiate the components in ID stage
Decoder Control(
    .instr_op_i(ID_instr[31:26]),
    .funct_i(ID_instr[5:0]),
    .RegWrite_o(ID_RegWrite), 
    .ALU_op_o(ID_ALU_op),   
    .ALUSrc1_o(ID_ALUSrc1select),   
    .ALUSrc2_o(ID_ALUSrc2select),   
    .RegDst_o(ID_RegDst),   
    .Branch_o(ID_Branch),
    .ImmExtensionSelect_o(ID_ImmExtensionSelect),
    .ExtensionSelect_o(ID_ExtensionSelect),
    .ALUBranchZeroSelect_o(ID_ALUBranchZeroSelect),
    .MemRead_o(ID_MemRead),
    .MemWrite_o(ID_MemWrite),
    .RDWriteBackSelect_o(ID_RDWriteBackSelect)
    );

Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(ID_instr[25:21]),  
    .RTaddr_i(ID_instr[20:16]),  
    .RDaddr_i(WB_RegDstResult),  
    .RDdata_i(WB_RDdata), 
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_RSdata),  
    .RTdata_o(ID_RTdata)   
    );

Sign_Extend #(.size(16)) ImmSignExtension(
        .data_i(ID_instr[15:0]),
        .data_o(ID_ImmSignExtensionResult)
    );

Unsign_Extend #(.size(16)) ImmUnsignExtension(
        .data_i(ID_instr[15:0]),
        .data_o(ID_ImmUnsignExtensionResult)
    );

Unsign_Extend #(.size(5)) ShamtUnsignExtension(
        .data_i(ID_instr[10:6]),
        .data_o(ID_ShamtUnsignExtensionResult)
    );

Pipe_Reg #(.size(32+32+1+3+10+32*5)) ID_EX(
    .clk_i(clk_i),
    .rst_i(ID_EX_PIPE_rst_i),
    .data_i(ID_EX_PIPE_i),
    .data_o(ID_EX_PIPE_o)
    );

//Instantiate the components in EX stage	   
ALU ALU(
    .src1_i(EX_ALUsrc1),
    .src2_i(EX_ALUsrc2),
    .ctrl_i(EX_ALUCtrl),
    .result_o(EX_ALUresult),
    .zero_o(EX_ALUzero)
    );

ALU_Control ALU_Control(
    .funct_i(EX_instr[5:0]),   
    .ALUOp_i(EX_ALU_op),   
    .ALUCtrl_o(EX_ALUCtrl) 
    );

MUX_2to1 #(.size(32)) Mux_ImmExtension(
    .data0_i(EX_ImmSignExtensionResult),
    .data1_i(EX_ImmUnsignExtensionResult),
    .select_i(EX_ImmExtensionSelect),
    .data_o(EX_ImmExtensionResult)
    );	

MUX_2to1 #(.size(32)) Mux_Extension(
    .data0_i(EX_ImmExtensionResult),
    .data1_i(EX_ShamtUnsignExtensionResult),
    .select_i(EX_ExtensionSelect),
    .data_o(EX_ExtensionResult)
    );	

MUX_3to1 #(.size(32)) Mux_Real_RS(
    .data0_i(EX_RSdata),
    .data1_i(MEM_ALUresult),
    .data2_i(WB_RDdata),
    .select_i(EX_Src1_Forward),
    .data_o(EX_Real_RSdata)
);
MUX_3to1 #(.size(32)) Mux_Real_RT(
    .data0_i(EX_RTdata),
    .data1_i(MEM_ALUresult),
    .data2_i(WB_RDdata),
    .select_i(EX_Src2_Forward),
    .data_o(EX_Real_RTdata)
);


MUX_2to1 #(.size(32)) Mux_ALUSrc1(
    .data0_i(EX_Real_RSdata),
    .data1_i(EX_Real_RTdata),
    .select_i(EX_ALUSrc1select),
    .data_o(EX_ALUsrc1)
    );	

MUX_2to1 #(.size(32)) Mux_ALUSrc2(
    .data0_i(EX_Real_RTdata),
    .data1_i(EX_ExtensionResult),
    .select_i(EX_ALUSrc2select),
    .data_o(EX_ALUsrc2)
    );	

MUX_2to1 #(.size(5)) Mux_Write_DST_Reg(
    .data0_i(EX_instr[20:16]),
    .data1_i(EX_instr[15:11]),
    .select_i(EX_RegDst),
    .data_o(EX_RegDstResult)
    );	

/* clac Branch */
Shift_Left_Two_32 Branch_Shifter(
    .data_i(EX_ImmSignExtensionResult),
    .data_o(EX_BranchShifterResult)
    ); 
Adder Adder2(
        .src1_i(EX_pc_in), 
	    .src2_i(EX_BranchShifterResult), 
	    .sum_o(EX_pc_out)      
	    );

Pipe_Reg #(.size(32+6+2*32+1+5)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(EX_MEM_PIPE_rst_i),
    .data_i(EX_MEM_PIPE_i),
    .data_o(EX_MEM_PIPE_o)
    );

//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_ALUresult),
    .data_i(MEM_RTdata),
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_o(MEM_MemResult)
    );
Pipe_Reg #(.size(1*2 + 32*2 + 5)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(MEM_WB_PIPE_rst_i),
    .data_i(MEM_WB_PIPE_i),
    .data_o(MEM_WB_PIPE_o)
    );

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(WB_ALUresult),
    .data1_i(WB_MemResult),
    .select_i(WB_RDWriteBackSelect),
    .data_o(WB_RDdata)
    );

// Forward
Forward FW(
    .WB_RegWrite_i(WB_RegWrite),
    .WB_RegDst_i(WB_RegDstResult),
    .MEM_RegWrite_i(MEM_RegWrite),
    .MEM_RegDst_i(MEM_RegDstResult),
    .EX_RSaddr_i(EX_RSaddr),
    .EX_RTaddr_i(EX_RTaddr),
    .EX_Src1_Forward_o(EX_Src1_Forward),
    .EX_Src2_Forward_o(EX_Src2_Forward)
    );


endmodule

