`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 06:30:47 PM
// Design Name: 
// Module Name: refreshTimer
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


module refreshTimer(
        input clk,
        input rst,
        output reg freq
    );
    
    localparam constnum = 50000;
    
    reg [31:0] count;
     
    always @ (posedge(clk), posedge(rst))
    begin
        if (rst == 1'b1)
            count <= 32'b0;
        else if (count == constnum - 1)
            count <= 32'b0;
        else
            count <= count + 1;
    end
        
    always @ (posedge(clk), posedge(rst))
    begin
        if (rst == 1'b1)
            freq <= 1'b0;
        else if (count == constnum - 1)
            freq <= ~freq;
        else
            freq <= freq;
    end    
endmodule
