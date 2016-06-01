`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2016 09:39:12 AM
// Design Name: 
// Module Name: ledtimer
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


module ledtimer(
        input secFreq,
        input sw,
        output reg [15:0] led
    );
        
    integer i = 0;
    integer x;
    
    always @(posedge secFreq) begin
        if(sw) begin
            //shift leds
            for(x = 0; x < 15; x = x + 1) begin
                led[x + 1] <= led[x];
            end
            led[0] <= 0;
            
            if(i < 4)
               led[0] <= 1;
            i = i + 1;
            
            if(i > 7)
                i <= 0;
        end else begin
            led[15:0] <= 0;
            i = 0;
        end
    end
endmodule
