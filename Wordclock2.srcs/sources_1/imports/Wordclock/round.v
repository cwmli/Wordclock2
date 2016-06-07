`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2016 09:01:07 PM
// Design Name: 
// Module Name: round
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


module bcpin(
        input refFreq,
        input [7:0] hour,
        input [7:0] minute,
        output reg [7:0] JA,
        output reg [7:0] JB,
        output reg [7:0] JC       
    );
    
    //LED MATRIX
    //\ 1 2 3 4 5 6 7 8 9 10 11  
    //A I T - I S - H A L F -
    //B T E N - Q U A R T E R
    //C - T W E N T Y F I V E
    //D T O P A S T - F O U R
    //E F I V E T W O N I N E
    //F T H R E E T W E L V E
    //G - E L E V E N O N E -
    //H S E V E N - E I G H T 
    //I - T E N S I X - - - -
    //J - - - - O - C L O C K       
    
    //JA1 - JA[0] = IT_IS            JC1 - JC[0] = FOUR    JB1 - JB[0] = SEVEN      
    //JA2 - JA[1] = HALF             JC2 - JC[1] = FIVE    JB2 - JB[1] = EIGHT
    //JA3 - JA[2] = TEN              JC3 - JC[2] = TWO     JB3 - JB[2] = TEN 
    //JA4 - JA[3] = QUARTER          JC4 - JC[3] = NINE    JB4 - JB[3] = SIX
    //JA7 - JA[4] = TWENTY           JC7 - JC[4] = THREE   JB7 - JB[4] = O_CLOCK
    //JA8 - JA[5] = FIVE             JC8 - JC[5] = TWELVE  JB8 - JB[5] = ELEVEN
    //JA9 - JA[6] =                  JC9 - JC[6] = TO      JB9 - JB[6] = ONE
    //JA10 - JA[7] =  ALARMSIGNAL    JC10 - JC[7] = PAST
                
    integer res_hour;
    integer rnd_min;
    reg [3:0] ones;
    
    integer i;
    
    always @(posedge refFreq) begin
        //convert bin to int
        res_hour = hour;
        rnd_min = minute;
        //simple rounding
        ones = 4'd0;       
        for(i = 7; i >= 0; i = i - 1) begin
            if(ones >= 5)
                ones = ones + 3;
            ones = ones << 1;
            ones[0] = minute[i];
        end
        //6789 & 1234
        if(ones == 5 || ones == 0)
            rnd_min = rnd_min;
        else if(ones == 4 || ones == 9)
            rnd_min = rnd_min + 1;
        else if(ones == 3 || ones == 8)
            rnd_min = rnd_min + 2;
        else if(ones == 2 || ones == 7)
            rnd_min = rnd_min - 2;
        else //ones == 6 or 1
            rnd_min = rnd_min - 1; 
        
        //reset the row data
        JA <= 0;
        JB <= 0;
        JC <= 0;
        
        //activate IT IS
        JA[0] <= 1;
        
        //check whether past or to
        if(rnd_min == 0 || rnd_min == 60) begin
            JC[7] <= 0;
            JC[6] <= 0;
            if(rnd_min == 60)
                res_hour = res_hour + 1;
        end else if(rnd_min <= 30) begin
            JC[7] <= 1;
        end else if(rnd_min > 30) begin
            JC[6] <= 1;
            res_hour = res_hour + 1;
        end      
        
        //check what minutes should be used
        if(rnd_min == 5 || rnd_min == 55) begin 
            JA[5] <= 1;
        end else if(rnd_min == 10 || rnd_min == 50) begin
            JA[2] <= 1;
        end else if(rnd_min == 15 || rnd_min == 45) begin
            JA[3] <= 1;
        end else if(rnd_min == 20 || rnd_min == 40) begin
            JA[4] <= 1;
        end else if(rnd_min == 25 || rnd_min == 35) begin
            JA[4] <= 1;
            JA[5] <= 1;
        end else if(rnd_min == 30) begin
            JA[1] <= 1;
        end else begin //top of the hour
            JB[4] <= 1;
        end
        
        //check hour
        if(res_hour == 0 || res_hour == 12) begin 
            JC[5] <= 1;
        end else if(res_hour == 1 || res_hour == 13) begin
            JB[6] <= 1;
        end else if(res_hour == 2 || res_hour == 14) begin
            JC[2] <= 1;
        end else if(res_hour == 3 || res_hour == 15) begin
            JC[4] <= 1;
        end else if(res_hour == 4 || res_hour == 16) begin
            JC[0] <= 1;
        end else if(res_hour == 5 || res_hour == 17) begin
            JC[1] <= 1;
        end else if(res_hour == 6 || res_hour == 18) begin
            JB[3] <= 1;
        end else if(res_hour == 7 || res_hour == 19) begin 
            JB[0] <= 1;
        end else if(res_hour == 8 || res_hour == 20) begin
            JB[1] <= 1;          
        end else if(res_hour == 9 || res_hour == 21) begin
            JC[3] <= 1;
        end else if(res_hour == 10 || res_hour == 22) begin
            JB[2] <= 1;
        end else begin //hour 11
            JB[5] <= 1;
        end   
    end    
endmodule
