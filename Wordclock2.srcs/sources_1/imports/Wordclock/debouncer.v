`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2016 10:34:03 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(
        input clk,
        input btnIn,
        output reg btnOut
    );
    
    reg [15:0] btnFilter;
    
    always @ (posedge clk) begin
        btnFilter  <=  { btnFilter[14:0], btnIn }; 
        if       ( &btnFilter )  
            btnOut <= 1'b1;
        else if ( ~|btnFilter )  
            btnOut <= 1'b0;      
    end
endmodule
