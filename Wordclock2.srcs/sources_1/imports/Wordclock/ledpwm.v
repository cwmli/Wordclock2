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
        input msclk,
        input btnU,
        input btnD,
        input downtime,
        input alarmsig,
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
    localparam fadecycle = 3250; //2000ms / 2s on for 1000-2000, off for 3000 - 3250
    localparam lightincr = 50; //50ms
    localparam alarmincr = 10000; //10000ms 10s
    localparam cycle = 20;//20ms
    
    localparam beeplength = 250; //250ms
    
    reg last_btnU;
    reg last_btnD;
    
    reg [7:0] cwidth;
    reg [7:0] bright;
    reg [7:0] dim;
    
    reg [31:0] count;
    reg [7:0] width;
    
    reg [31:0] alarmincrwidth;
    reg [15:0] alarmwidth;
    
    reg [31:0] icnt1;
    reg [31:0] icnt2;
    reg [31:0] icnt3;
    reg [31:0] fcnt1;
    reg [31:0] fcnt2;
    reg [31:0] fcnt3;
    reg [7:0] cw1;
    reg [7:0] cw2;
    reg [7:0] cw3;
    
    reg [7:0] bsets [0:19];
    reg [15:0] adsets [0:5]; //alarm delays
    
    reg [7:0] i1;
    reg [7:0] i2;
    reg [7:0] i3;
    
    integer a;
    
    initial begin
        bright = 5;
        dim = 1;
        
        a = 0;
        
        i1 = 10;
        i2 = 5;
        i3 = 0;
        
        //fade delays
        icnt1 = 0;
        fcnt1 = 500;
        
        icnt2 = 0;
        fcnt2 = 250;
        
        icnt3 = 0;
        fcnt3 = 0;
        
        adsets[0] = 1000;
        adsets[1] = 900;
        adsets[2] = 750;
        adsets[3] = 550;
        adsets[4] = 350;
        adsets[5] = 250;
        
        bsets[0] = 0;
        bsets[1] = 1;
        bsets[2] = 2;
        bsets[3] = 3;
        bsets[4] = 4;
        bsets[5] = 5;
        bsets[6] = 6;
        bsets[7] = 7;
        bsets[8] = 8;
        bsets[9] = 9;
        bsets[10] = 10;
        bsets[11] = 11;
        bsets[12] = 12;
        bsets[13] = 13;
        bsets[14] = 14;
        bsets[15] = 15;
        bsets[16] = 16;
        bsets[17] = 17;
        bsets[18] = 18;
        bsets[19] = 20;
    end
    
    integer x;
    
    always @(posedge(clk)) 
    begin
        if (!downtime) begin
            if (btnU && !last_btnU && sw && !fade && (bright < cycle)) begin
                last_btnU <= btnU;
                bright <= bright + 1;
            end else if (btnD && !last_btnD && sw && !fade && (bright > 0)) begin
                last_btnD <= btnD;
                bright <= bright - 1;
            end else if (!btnU && !btnD) begin
                last_btnD <= btnD;
                last_btnU <= btnU; 
            end   
        end else begin
            if (btnU && !last_btnU && sw && !fade && (dim < cycle)) begin
                last_btnU <= btnU;
                dim <= dim + 1;
            end else if (btnD && !last_btnD && sw && !fade && (dim > 0)) begin
                last_btnD <= btnD;
                dim <= dim - 1;
            end else if (!btnU && !btnD) begin
                last_btnD <= btnD;
                last_btnU <= btnU; 
            end  
        end          
    end
         
    always @(posedge(msclk)) begin
        width <= width + 1;
        if (width == cycle - 1)
            width <= 4'b0;
         
        if (alarmsig) begin   
            alarmincrwidth <= alarmincrwidth + 1;
            if (alarmincrwidth == alarmincr - 1)
                alarmincrwidth <= 32'b0;
        end
        
        if (fade) begin        
            fcnt1 <= fcnt1 + 1;
            icnt1 <= icnt1 + 1;            
            if (fcnt1 == fadecycle - 1)
                fcnt1 <= 32'b0;
            if (icnt1 == lightincr - 1)
                icnt1 <= 32'b0;
            
            fcnt2 <= fcnt2 + 1;
            icnt2 <= icnt2 + 1;            
            if (fcnt2 == fadecycle - 1)
                fcnt2 <= 32'b0;
            if (icnt2 == lightincr - 1)
                icnt2 <= 32'b0;
            
            fcnt3 <= fcnt3 + 1;
            icnt3 <= icnt3 + 1;            
            if (fcnt3 == fadecycle - 1)
                fcnt3 <= 32'b0;
            if (icnt3 == lightincr - 1)
                icnt3 <= 32'b0;    
        end
    end
    
    always @(posedge(msclk))
    begin
        if (fade) begin     
            if (icnt1 == lightincr - 1) begin       
                if(fcnt1 >= 0 && fcnt1 <= 1000)
                    i1 <= i1 + 1;
                else if(fcnt1 >= 2000 && fcnt1 <= 3000)
                    i1 <= i1 - 1;
                else 
                    i1 <= i1;
            end
            
            if (icnt2 == lightincr - 1) begin       
                if(fcnt2 >= 0 && fcnt2 <= 1000) 
                    i2 <= i2 + 1;
                else if(fcnt2 >= 2000 && fcnt2 <= 3000) 
                    i2 <= i2 - 1;
                else
                    i2 <= i2;      
            end
            
            if (icnt3 == lightincr - 1) begin       
                if(fcnt3 >= 0 && fcnt3 <= 1000)
                    i3 <= i3 + 1;
                else if(fcnt3 >= 2000 && fcnt3 <= 3000)
                    i3 <= i3 - 1;
                else 
                    i3 <= i3;
            end
            
            cw1 <= bsets[i1];
            cw2 <= bsets[i2];
            cw3 <= bsets[i3];
        end else begin           
            if (downtime)
                cwidth <= dim;
            else
                cwidth <= bright;  
        end
        
        if (alarmsig) begin
            //speed up timer of alarm
            if (alarmincrwidth == alarmincr - 1) begin
                if (a < 6) 
                    a <= a + 1;
                else
                    a <= a;
            end
            
            //alarm width
            alarmwidth <= alarmwidth + 1;
            if (alarmwidth >= adsets[a] + beeplength)
                alarmwidth <= 16'b0;
        end else begin
            a <= 0;
            alarmwidth <= 16'b0;
        end                  
        
        if (!alarmsig) begin      
            if (sw && !fade) begin
                for(x = 0; x < 10; x = x + 1) begin
                    if(x < cwidth / 2)
                        led[x] <= 1;
                    else
                        led[x] <= 0;
                end
            end else if (fade && sw) begin
                for(x = 0; x < 10; x = x + 1) begin
                    if(x < cw1 / 2)
                        led[x] <= 1;
                    else
                        led[x] <= 0;
                end
            end else
                led <= 0;
        end
            
        if (alarmsig) begin 
            if (alarmwidth > adsets[a] && alarmwidth < adsets[a] + beeplength) begin
                JA <= pins1;
                JA[7] <= 1;
                led <= 15'b111111111111111;
                JB <= pins2;
                JC <= pins3;
            end else begin
                led <= 15'b000000000000000;
                JA <= 8'b0;
                JB <= 8'b0;
                JC <= 8'b0;
            end
        end else if (!fade) begin
            if (width < cwidth) begin
                JA <= pins1;
                JB <= pins2;
                JC <= pins3;
            end else begin
                JA <= 8'b0;
                JB <= 8'b0;
                JC <= 8'b0;
            end
        end else begin
            if (width < cw1)
                JA <= pins1;
            else 
                JA <= 8'b0;
                
            if (width < cw3)
                JB <= pins2;
            else 
                JB <= 8'b0;
                
            if (width < cw2)
                JC <= pins3;
            else 
                JC <= 8'b0;
        end  
    end
endmodule
