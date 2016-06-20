/*
`include "Adder.v"
`include "ALU_Ctrl.v"
`include "ALU.v"
`include "Data_Memory.v"
`include "Decoder.v"
`include "Instr_Memory.v"
`include "MUX_2to1.v"
`include "ProgramCounter.v"
`include "Reg_File.v"
`include "Shift_Left_Two_32.v"
`include "Sign_Extend.v"
`include "Unsign_Extend.v"
*/
module CPU(
        clk_i,
        start_i
		);
input         clk_i;
input         start_i;

wire [32-1:0] pc_addr;
wire [32-1:0] instr;
wire RegWrite;
wire RegDst;
wire [5-1:0] RegDstResult;
wire [3-1:0] ALU_op;
reg [32-1:0] const_32d4 = 4;
reg [5-1:0] const_5d31 = 31;
wire [5-1:0] RDaddr;
wire ALUSrc1select;
wire ALUSrc2select;
wire MemRead;
wire MemWrite;
wire ExtensionSelect;
wire ImmExtensionSelect;

//assign RDaddr = RegDstResult;


wire [32-1:0] ShamtUnsignExtensionResult;
wire [32-1:0] ImmSignExtensionResult;
wire [32-1:0] ImmUnsignExtensionResult;
wire [32-1:0] ImmExtensionResult;
wire [32-1:0] ExtensionResult;


wire jal;
wire jr;

wire [32-1:0] RSdata;

wire [32-1:0] RTdata;

wire [32-1:0] ALUsrc1;

wire [32-1:0] ALUsrc2;

wire [4-1:0] ALUCtrl;

wire ALUzero;

wire [32-1:0] ALUresult;

wire Branch;
wire mux_pc_branch_select;
//assign mux_pc_branch_select = Branch & ((ALUzeroresult & ALUBranchZeroSelect ) | (ALUresult & ALUBranchResultSelect));
assign mux_pc_branch_select = Branch & (ALUBranchResultSelect ? ALUresult : ALUzeroresult);



wire [32-1:0] BranchShifterResult;
wire [32-1:0] BranchResult;
wire mux_pc_jump_select;
wire [32-1:0] JumpShifterResult;
wire [32-1:0] JumpResult;
assign JumpResult = {pc_addr[31:28], JumpShifterResult[27:0]};

wire [32-1:0] PC_PLUS4;

wire [32-1:0] Adder2result;


wire [32-1:0] pc_in;
wire [32-1:0] PCJumpResult;

wire inverse_ALUzero;
assign inverse_ALUzero = ~ALUzero;

wire ALUBranchZeroSelect;
wire ALUBranchResultSelect;


wire [32-1:0] RDdata;
wire [32-1:0] MemResult;
wire RDWriteBackSelect;
wire [32-1:0] RDWriteBackResult;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (start_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_addr) 
	    );
	
Adder Adder1(
        .src1_i(const_32d4),     
	    .src2_i(pc_addr),     
	    .sum_o(PC_PLUS4)    
	    );
	
Instruction_Memory IM(
        .addr_i(pc_addr),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_DST_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RegDstResult)
        );	

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RegDstResult),
        .data1_i(const_5d31),
        .select_i(jal),
        .data_o(RDaddr)
        );

MUX_2to1 #(.size(32)) Mux_Write_Back_Data(
        .data0_i(ALUresult),
        .data1_i(MemResult),
        .select_i(RDWriteBackSelect),
        .data_o(RDWriteBackResult)
        );

MUX_2to1 #(.size(32)) Mux_Write_Data(
        .data0_i(RDWriteBackResult),
        .data1_i(PC_PLUS4),
        .select_i(jal),
        .data_o(RDdata)
        );

		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(start_i) ,     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(RDaddr),  
        .RDdata_i(RDdata), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
        .funct_i(instr[5:0]),
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc1_o(ALUSrc1select),   
	    .ALUSrc2_o(ALUSrc2select),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch),
        .Jump_o(mux_pc_jump_select),
        .ImmExtensionSelect_o(ImmExtensionSelect),
        .ExtensionSelect_o(ExtensionSelect),
        .ALUBranchZeroSelect_o(ALUBranchZeroSelect),
        .ALUBranchResultSelect_o(ALUBranchResultSelect),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .RDWriteBackSelect_o(RDWriteBackSelect),
        .jal_o(jal),
        .jr_o(jr)
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );


	
Sign_Extend #(.size(16)) ImmSignExtension(
        .data_i(instr[15:0]),
        .data_o(ImmSignExtensionResult)
        );

Unsign_Extend #(.size(16)) ImmUnsignExtension(
        .data_i(instr[15:0]),
        .data_o(ImmUnsignExtensionResult)
        );

MUX_2to1 #(.size(32)) Mux_ImmExtension(
        .data0_i(ImmSignExtensionResult),
        .data1_i(ImmUnsignExtensionResult),
        .select_i(ImmExtensionSelect),
        .data_o(ImmExtensionResult)
        );	

Unsign_Extend #(.size(5)) ShamtUnsignExtension(
        .data_i(instr[10:6]),
        .data_o(ShamtUnsignExtensionResult)
        );


MUX_2to1 #(.size(32)) Mux_Extension(
        .data0_i(ImmExtensionResult),
        .data1_i(ShamtUnsignExtensionResult),
        .select_i(ExtensionSelect),
        .data_o(ExtensionResult)
        );	


MUX_2to1 #(.size(32)) Mux_ALUSrc1(
        .data0_i(RSdata),
        .data1_i(RTdata),
        .select_i(ALUSrc1select),
        .data_o(ALUsrc1)
        );	

MUX_2to1 #(.size(32)) Mux_ALUSrc2(
        .data0_i(RTdata),
        .data1_i(ExtensionResult),
        .select_i(ALUSrc2select),
        .data_o(ALUsrc2)
        );	
		
ALU ALU(
        .src1_i(ALUsrc1),
	    .src2_i(ALUsrc2),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALUresult),
		.zero_o(ALUzero)
	    );
		
Adder Adder2(
        .src1_i(PC_PLUS4), 
	    .src2_i(BranchShifterResult), 
	    .sum_o(Adder2result)      
	    );
		
Shift_Left_Two_32 Branch_Shifter(
        .data_i(ImmSignExtensionResult),
        .data_o(BranchShifterResult)
        ); 

Shift_Left_Two_32 Jump_Shifter(
        .data_i({6'b000000, instr[25:0]}),
        .data_o(JumpShifterResult)
        );
		
MUX_2to1 #(.size(32)) Mux_PC_Branch_Source(
        .data0_i(PC_PLUS4),
        .data1_i(Adder2result),
        .select_i(mux_pc_branch_select),
        .data_o(BranchResult)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Jump_Source(
        .data0_i(BranchResult),
        .data1_i(JumpResult),
        .select_i(mux_pc_jump_select),
        .data_o(PCJumpResult)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Jr_Source(
        .data0_i(PCJumpResult),
        .data1_i(RSdata),
        .select_i(jr),
        .data_o(pc_in)
        );	

MUX_2to1 #(.size(1)) Mux_ALU_ZERO(
        .data0_i(ALUzero),
        .data1_i(inverse_ALUzero),
        .select_i(ALUBranchZeroSelect),
        .data_o(ALUzeroresult)
        );	


Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(ALUresult),
        .data_i(RTdata),
        .MemRead_i(MemRead),
        .MemWrite_i(MemWrite),
        .data_o(MemResult)
);
endmodule
