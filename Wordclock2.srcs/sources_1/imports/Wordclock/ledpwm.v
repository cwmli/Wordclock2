`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2016 06:24:35 PM
// Design Name: 
// Module Name: ledpwm
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


module ledpwm(
        input clk,
        input btnU,
        input btnD,
        input downtime,
        input sw,
        input fade,
        input [7:0] pins1,
        input [7:0] pins2,
        input [7:0] pins3,
        output reg [15:0] led,
        output reg [7:0] JA,
        output reg [7:0] JB,
        output reg [7:0] JC    
    );
    //5000 -> 10ms upper limit
    localparam constnum = 500; //1ms
    localparam fadecycle = 143; //143ms
    localparam cycle = 20;//20ms
    
    reg last_btnU;
    reg last_btnD;
    
    reg [7:0] cwidth;
    reg [7:0] bright;
    reg [7:0] dim;
    
    reg [31:0] count;
    reg [7:0] width;
    reg [31:0] binterval;
    
    reg [7:0] bsets [0:6];
    
    integer i;
    reg decrease;
    
    initial begin
        bright = 5;
        dim = 1;
        decrease = 0;
        i = 0;
        
        bsets[0] = 0;
        bsets[1] = 1;
        bsets[2] = 2;
        bsets[3] = 5;
        bsets[4] = 10;
        bsets[5] = 17;
        bsets[6] = 20;
    end
    
    integer x;
    
    always @(posedge(clk)) 
    begin
        if (!downtime) begin
            if (btnU && !last_btnU && sw && (bright < cycle)) begin
                last_btnU <= btnU;
                bright <= bright + 1;
            end else if (btnD && !last_btnD && sw && (bright > 0)) begin
                last_btnD <= btnD;
                bright <= bright - 1;
            end else if (!btnU && !btnD) begin
                last_btnD <= btnD;
                last_btnU <= btnU; 
            end   
        end else begin
            if (btnU && !last_btnU && sw && (dim < cycle)) begin
                last_btnU <= btnU;
                dim <= dim + 1;
            end else if (btnD && !last_btnD && sw && (dim > 0)) begin
                last_btnD <= btnD;
                dim <= dim - 1;
            end else if (!btnU && !btnD) begin
                last_btnD <= btnD;
                last_btnU <= btnU; 
            end  
        end          
    end
     
    always @ (posedge(clk))
    begin
        if (count == constnum - 1) begin
            count <= 32'b0;
            width <= width + 1;
            binterval <= binterval + 1;
            if (width == cycle - 1)
                width <= 4'b0;
            if (binterval == fadecycle - 1)
                binterval <= 8'b0;
        end else
            count <= count + 1;
    end
    
    always @(posedge(clk))
    begin
        if (sw) begin
            for(x = 0; x < 10; x = x + 1) begin
                if(x < cwidth / 2)
                    led[x] <= 1;
                else
                    led[x] <= 0;
            end
        end else
            led <= 0; 
        
//        if (downtime)
//            cwidth <= dim;
//        else
//            cwidth <= bright;  
    
        if (binterval == fadecycle - 1 && fade) begin
            cwidth <= bsets[i];
            if (i == 6)
                decrease <= 1;
            else if (i == 0)
                decrease <= 0;
            
            if (!decrease) begin
                i <= i + 1;
            end else begin
                i <= i - 1;
            end
        end
        
        if (width < cwidth) begin
            JA <= pins1;
            JB <= pins2;
            JC <= pins3;
        end else begin
            JA <= 8'b0;
            JB <= 8'b0;
            JC <= 8'b0;
        end            
    end
endmodule
