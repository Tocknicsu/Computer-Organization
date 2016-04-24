//Subject:     CO project 2 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 10			
`define END_COUNT 25
module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     handle;
integer     end_count;
//Greate tested modle  
Simple_Single_CPU cpu(
        .clk_i(CLK),
		.rst_i(RST)
		);
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
    handle = $fopen("CO_P2_Result.txt", "a");
	CLK = 0;
    RST = 0;
	count = 0;
    end_count=25;
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*`END_COUNT)	$fclose(handle); $stop;
end

//Print result to "CO_P2_Result.txt"
always@(posedge CLK) begin
    count = count + 1;
	//if( count == `END_COUNT ) begin 
	/*
    $fdisplay(handle, "count=%d, r0=%d, r1=%d, r2=%d, r3=%d, r4=%d, r5=%d, r6=%d, r7=%d, r8=%d, r9=%d, r10=%d, r11=%d, r12=%d",
			 count,
	          cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
			  cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7], cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], 
			  cpu.RF.Reg_File[10],cpu.RF.Reg_File[11], cpu.RF.Reg_File[12]
			  );
	*/
	$fdisplay(handle, "count=%d, instr=%b,\n\
    RegDst=%b, RegWrite=%b, ALU=%b, SE=%b,\n\
    \tr0=%d, r1=%d, r2=%d, r3=%d, r4=%d\n\
    \tr5=%d, r6=%d, r7=%d, r8=%d, r9=%d\n\
    \tr10=%d, r11=%d",
    //aluop=%b, funct=%b op=%b, alu=%d",
		count, cpu.instr,
        cpu.Decoder.RegDst_o, cpu.Decoder.RegWrite_o, cpu.Decoder.ALU_op_o, cpu.SEResult,
		cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
        cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7], cpu.RF.Reg_File[8], cpu.RF.Reg_File[9],
        cpu.RF.Reg_File[10], cpu.RF.Reg_File[11]
        //cpu.ALU_op, cpu.AC.funct_i, cpu.AC.ALUCtrl_o, cpu.ALUresult
		);
	//end
	//else ;
end
  
endmodule
