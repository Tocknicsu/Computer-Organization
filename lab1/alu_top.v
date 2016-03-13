`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 02/25/2016
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
					equal,
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
					add_result,
               cout       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input			  equal;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output 		  add_result;
output        cout;

//reg           result;

wire a, b;
assign a = A_invert ^ src1;
assign b = B_invert ^ src2;
assign cout = operation[1] == 1 ? (cin & (a | b)) | (a & b) : 0;
assign add_result = (a ^ b ^ cin);
assign result = 
				operation == 0 ? a & b :
				operation == 1 ? a | b :
				operation == 2 ? add_result :
				operation == 3 ? less | equal : 0;
endmodule
