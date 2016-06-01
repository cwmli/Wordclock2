`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 09:28:05 AM
// Design Name: 
// Module Name: counter
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


module counter(
        input bclk,
        input clk,
        input rev,
        input rst,
        input btnL,
        input btnR,
        output reg [7:0] hr,
        output reg [7:0] min
    );
    
    parameter minute = 8'b00111011;
    parameter hour = 8'b00111011;
    parameter hourLim = 8'b00010111;
        
    reg [7:0] sec = 8'd0;
    
    reg [7:0] uhr;
    reg [7:0] umin;
    
    reg last_btnL;
    reg last_btnR;
    
    always @ (posedge(bclk)) begin
        if (btnL && !last_btnL && rst) begin
            last_btnL <= btnL;
            if (uhr == hourLim && !rev)
                uhr <= 8'b0;
            else if (uhr == 8'b0 && rev)
                uhr <= hourLim;
            else begin
                if (rev)
                    uhr <= uhr - 1'b1;
                else
                    uhr <= uhr + 1'b1;
            end  
        end else if (btnR && !last_btnR && rst) begin
            last_btnR <= btnR;
            if (umin == hour && !rev)
               umin <= 8'b0;
            else if (umin == 8'b0 && rev)
               umin <= hour;
            else begin
               if (rev)
                   umin <= umin - 1'b1;
               else
                   umin <= umin + 1'b1;
            end  
        end else if (!btnL && !btnR) begin
            uhr <= hr;
            umin <= min;
            last_btnL <= btnL;
            last_btnR <= btnR;
        end
    end      
       
    always @ (posedge(clk), posedge(rst)) begin       
        if (rst == 1'b1) begin
            sec <= 8'b0;
            hr <= uhr;
            min <= umin;
        end else if (sec == minute) begin
            sec <= 8'b0;
            if (min == hour) begin
                min <= 8'b0;
                if (hr == hourLim)
                    hr <= 8'b0;
                else
                    hr <= hr + 1'b1;
            end else 
                min <= min + 1'b1;     
         end else 
            sec <= sec + 1'b1;
    end
endmodule
