//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//PC & Instr
wire [32-1:0] pc_addr;
//Instr & lots component
wire [32-1:0] instr;
//Decoder & Register File
wire RegWrite;
//Decoder & Mux For Register
wire RegDst;
//Decoder & ALU_Ctrl
wire [3-1:0] ALU_op;

reg [32-1:0] const_32d4 = 4;

wire [5-1:0] RDaddr;

wire ALUSrc1select;

wire ALUSrc2select;

wire SEselect;


wire [32-1:0] shamtSEResult;
wire [32-1:0] instrSEResult;
wire [32-1:0] SEResult;

wire [32-1:0] RSdata;

wire [32-1:0] RTdata;

wire [32-1:0] ALUsrc1;

wire [32-1:0] ALUsrc2;

wire [4-1:0] ALUCtrl;

wire ALUzero;

wire [32-1:0] ALUresult;

wire Branch;

wire [32-1:0] Adder1result;

wire [32-1:0] Adder2result;

wire [32-1:0] Shift2result;

wire [32-1:0] pc_in;

wire mux_pc_select;
assign mux_pc_select = Branch & ALUzero;



//Internal Signles


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_addr) 
	    );
	
Adder Adder1(
        .src1_i(const_32d4),     
	    .src2_i(pc_addr),     
	    .sum_o(Adder1result)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_addr),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(RDaddr),  
        .RDdata_i(ALUresult), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc1_o(ALUSrc1select),   
	    .ALUSrc2_o(ALUSrc2select),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch),
        .SE_o(SEselect)
	    );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend #(.size(16)) instrSE(
        .data_i(instr[15:0]),
        .data_o(instrSEResult)
        );

Sign_Extend #(.size(5)) ShamtSE(
        .data_i(instr[10:6]),
        .data_o(shamtSEResult)
        );


MUX_2to1 #(.size(32)) Mux_SE(
        .data0_i(instrSEResult),
        .data1_i(shamtSEResult),
        .select_i(SEselect),
        .data_o(SEResult)
        );	


MUX_2to1 #(.size(32)) Mux_ALUSrc1(
        .data0_i(RSdata),
        .data1_i(RTdata),
        .select_i(ALUSrc1select),
        .data_o(ALUsrc1)
        );	

MUX_2to1 #(.size(32)) Mux_ALUSrc2(
        .data0_i(RTdata),
        .data1_i(SEResult),
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
        .src1_i(Adder1result), 
	    .src2_i(Shift2result), 
	    .sum_o(Adder2result)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(SEResult),
        .data_o(Shift2result)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(Adder1result),
        .data1_i(Adder2result),
        .select_i(mux_pc_select),
        .data_o(pc_in)
        );	

endmodule
		  


