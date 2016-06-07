`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2016 04:21:49 PM
// Design Name: 
// Module Name: downtime
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


module downtime(
        input clk,
        input [7:0] hr,
        input [7:0] min,        
        input setdown,
        input setup,
        input setalarm,
        input alarmon,
        input rev,
        input btnL,
        input btnR,
        output reg [7:0] dhr,
        output reg [7:0] dmin,
        output reg [7:0] bhr,
        output reg [7:0] bmin,
        output reg [7:0] ahr,
        output reg [7:0] amin,
        output reg alarm,
        output reg down
    );
    
    localparam hour = 8'b00111011;
    localparam hourLim = 8'b00010111;
    
    reg last_btnL;
    reg last_btnR;
    
    initial begin
        dhr = 8'b0;
        dmin = 8'b0;
        
        bhr = 8'b0;
        bmin = 8'b00000001;
        
        ahr = 8'b0;
        amin = 8'b0;
    end
       
    
    always @ (posedge clk) begin
       if (btnL && !last_btnL && (setdown || setup || setalarm)) begin
            last_btnL <= btnL;
            if (setdown) begin
                if (dhr == hourLim && !rev)
                    dhr <= 8'b0;
                else if (dhr == 8'b0 && rev)
                    dhr <= hourLim;
                else begin
                    if (rev)
                        dhr <= dhr - 1'b1;
                    else
                        dhr <= dhr + 1'b1;
                end
            end else if (setup) begin
                if (bhr == hourLim && !rev)
                    bhr <= 8'b0;
                else if (bhr == 8'b0 && rev)
                    bhr <= hourLim;
                else begin
                    if (rev)
                        bhr <= bhr - 1'b1;
                    else
                        bhr <= bhr + 1'b1;
                end
             end else if (setalarm) begin
                 if (ahr == hourLim && !rev)
                     ahr <= 8'b0;
                 else if (ahr == 8'b0 && rev)
                     ahr <= hourLim;
                 else begin
                     if (rev)
                         ahr <= ahr - 1'b1;
                     else
                         ahr <= ahr + 1'b1;
                 end             
             end
        end else if (btnR && !last_btnR && (setdown || setup || setalarm)) begin
             last_btnR <= btnR;
             if (setdown) begin
                if (dmin == hour && !rev)
                    dmin <= 8'b0;
                else if (dmin == 8'b0 && rev)
                    dmin <= hour;
                else begin
                    if (rev)
                        dmin <= dmin - 1'b1;
                    else
                        dmin <= dmin + 1'b1;
                end
             end else if (setup) begin
                if (bmin == hour && !rev)
                    bmin <= 8'b0;
                else if (bmin == 8'b0 && rev)
                    bmin <= hour;
                else begin
                    if (rev)
                        bmin <= bmin - 1'b1;
                    else
                        bmin <= bmin + 1'b1;
                end
             end else if (setalarm) begin
                 if (amin == hour && !rev)
                    amin <= 8'b0;
                 else if (bmin == 8'b0 && rev)
                     amin <= hour;
                 else begin
                     if (rev)
                         amin <= amin - 1'b1;
                     else
                         amin <= amin + 1'b1;
                 end             
             end
        end else if (!btnL && !btnR) begin
            last_btnL <= btnL;
            last_btnR <= btnR;
        end    
    end
    
    always @ (posedge clk) begin    
       if (hr > dhr || hr < bhr)
          down <= 1;
       else if(hr == dhr && min >= dmin)
          down <= 1;
       else if(hr == bhr && min <= bmin)
          down <= 1;       
       else
          down <= 0; 
          
       if (hr == ahr && min == amin && alarmon)
          alarm <= 1;
       else
          alarm <= 0;
    end
    
endmodule
