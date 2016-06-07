`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 09:33:42 AM
// Design Name: 
// Module Name: clock
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


module clock(
        input clk,
        input btnL,
        input btnR,
        input btnC,
        input btnU,
        input btnD,
        input [15:0] sw,
        output [15:0] led,
        output [7:0] JA,
        output [7:0] JB,
        output [7:0] JC,
        output [3:0] an,
        output [6:0] seg,
        output dp
    );
    
    wire seconds_clk;
    wire ms_clk;
    wire digit_refclk;
    
    wire [7:0] hour;
    wire [7:0] minute;
    
    wire [7:0] dhour;
    wire [7:0] dminute;
    wire [7:0] uhour;
    wire [7:0] uminute;
    wire [7:0] ahour;
    wire [7:0] aminute;
        
    wire db_btnL;
    wire db_btnR;
    wire db_btnU;
    wire db_btnD;
    
    wire downtime;
    wire alarmtime;
         
    //segment displays
    // 4 3 : 2 1
    wire [7:0] stime [0:3];
    wire [7:0] dtime [0:3];
    wire [7:0] utime [0:3];
    wire [7:0] atime [0:3];
        
    //pin data
    wire [7:0] j1;
    wire [7:0] j2;
    wire [7:0] j3;
        
    secondsTimer secTimer(clk, sw[12], seconds_clk);
    mstimer msTimer(clk, ms_clk);
    refreshTimer refTimer(clk, 1'b0, digit_refclk);  
    
    debouncer dbbtnL(clk, btnL, db_btnL); 
    debouncer dbbtnR(clk, btnR, db_btnR);
    debouncer dbbtnU(clk, btnU, db_btnU);
    debouncer dbbtnD(clk, btnD, db_btnD);
        
    counter timeCounter(clk, seconds_clk, btnC, sw[12], db_btnL, db_btnR, hour, minute); 
    bcd bin2digit(hour, minute, stime[3], stime[2], stime[1], stime[0]);
    
    downtime downtimer(clk, hour, minute, sw[15], sw[14], sw[13], sw[3], btnC, db_btnL, db_btnR, uhour, uminute, dhour, dminute, ahour, aminute, alarmtime, downtime); 
    bcd dbin2digit(dhour, dminute, dtime[3], dtime[2], dtime[1], dtime[0]);
    bcd ubin2digit(uhour, uminute, utime[3], utime[2], utime[1], utime[0]);
    bcd abin2digit(ahour, aminute, atime[3], atime[2], atime[1], atime[0]);
    
    digits sevenSeg(digit_refclk, seconds_clk, sw[1], sw[14], sw[15], sw[13], 
                    stime[0], stime[1], stime[2], stime[3], 
                    dtime[0], dtime[1], dtime[2], dtime[3], 
                    utime[0], utime[1], utime[2], utime[3],
                    atime[0], atime[1], atime[2], atime[3], 
                    seg, an, dp);
    
    bcpin bin2pin(digit_refclk, hour, minute, j1, j2, j3);
    
    ledpwm ledpwm(clk, ms_clk, db_btnU, db_btnD, downtime, alarmtime, sw[0], sw[2], j1, j2, j3, led, JA, JB, JC);
endmodule
