`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 02/25/2016
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

wire    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire [32:0] tmp_cout;
wire less;
wire [1:0] op;
wire a_invert, b_invert;
assign a_invert = ALU_control[3];
assign b_invert = ALU_control[2];
assign tmp_cout[0] = ALU_control[1] & ALU_control[2];
assign op = ALU_control[1:0];
assign less = 0;
wire _zero;
assign _zero = 0;
genvar i;
generate
	for(i = 0 ; i < 32 ; i = i+1) begin : inst
		alu_top module_alu_top(
			src1[i], 
			src2[i], 	
			i==0 ? tmp_cout[32] : _zero,
			a_invert,
			b_invert,
			tmp_cout[i],
			op,
			result[i],
			tmp_cout[i+1]
		);
	end
endgenerate

always @(*) begin
	if(rst_n) begin
		zero = ~(result[0]|result[1]|result[2]|result[3]|result[4]|result[5]|result[6]|result[7]|result[8]|result[9]|result[10]|result[11]|result[12]|result[13]|result[14]|result[15]|result[16]|result[17]|result[18]|result[19]|result[20]|result[21]|result[22]|result[23]|result[24]|result[25]|result[26]|result[27]|result[28]|result[29]|result[30]|result[31]);
		if (op == 2) begin
			cout = tmp_cout[32];
			overflow = (a_invert ^ src1[31]) == (b_invert ^ src2[31]) & (a_invert ^ src1[31] ^ result[31]);
		end else begin
			cout = 0;
			overflow = 0;
		end
	end 
	else begin
		zero = 0;
		cout = 0;
		overflow = 0;
	end
end
endmodule
