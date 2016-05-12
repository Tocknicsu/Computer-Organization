//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Unsign_Extend(
    data_i,
    data_o
    );
               
parameter size = 0;			   
//I/O ports
input   [size-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
integer i;
//Sign extended
always @(*) begin
    for( i = 0 ; i < 32 ; i=i+1)
        data_o[i] = (i < size) ? data_i[i] : 0;
end
endmodule      
     
