`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 07:24:47 PM
// Design Name: 
// Module Name: bcd
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


module bcd(
        input [7:0] bin1,
        input [7:0] bin2,
        output reg [7:0] disp2,
        output reg [7:0] disp1,
        output reg [7:0] disp4,
        output reg [7:0] disp3
    );
    
        //    A
    //   ---
    // F\   \ B
    //   -G-
    // E\ D \ C
    //   ---        
    //0(low) -> on,  1(high) -> off
    parameter a = 8'b11111110;
    parameter b = 8'b11111101;
    parameter c = 8'b11111011;
    parameter d = 8'b11110111;
    parameter e = 8'b11101111;
    parameter f = 8'b11011111;
    parameter g = 8'b10111111;
    
    //numbers & binary equivalent
    parameter zero = a & b & c & d & e & f;
    parameter one = b & c;
    parameter two = a & b & g & e & d;
    parameter three = a & b & g & c & d;
    parameter four = f & g & b & c;
    parameter five = a & f & g & c & d;
    parameter six = a & f & e & d & c & g;
    parameter seven = a & b & c;
    parameter eight = a & b & c & d & e & f & g;
    parameter nine = a & b & c & d & f & g;
    
    parameter b0 = 4'b0000;
    parameter b1 = 4'b0001;
    parameter b2 = 4'b0010;
    parameter b3 = 4'b0011;
    parameter b4 = 4'b0100;
    parameter b5 = 4'b0101;
    parameter b6 = 4'b0110;
    parameter b7 = 4'b0111;
    parameter b8 = 4'b1000;
    parameter b9 = 4'b1001;
    
    reg [3:0] tens1;
    reg [3:0] ones1;
    reg [3:0] tens2;
    reg [3:0] ones2;
        
    integer i;
    integer x;
    always @(bin1, disp1, disp2) begin
        tens1 = 4'd0;
        ones1 = 4'd0;
        
        for(i = 7; i >= 0; i = i - 1) begin
            if(tens1 >= 5)
                tens1 = tens1 + 3;
            if(ones1 >= 5)
                ones1 = ones1 + 3;
                
            tens1 = tens1 << 1;
            tens1[0] = ones1[3];
            ones1 = ones1 << 1;
            ones1[0] = bin1[i];
        end
        
        case(tens1)
            b0: disp2 <= zero;
            b1: disp2 <= one;
            b2: disp2 <= two;
            b3: disp2 <= three;
            b4: disp2 <= four;
            b5: disp2 <= five;
            b6: disp2 <= six;
            b7: disp2 <= seven;
            b8: disp2 <= eight;
            b9: disp2 <= nine;
            default: disp2 <= zero;
        endcase
        
        case(ones1)
            b0: disp1 <= zero;
            b1: disp1 <= one;
            b2: disp1 <= two;
            b3: disp1 <= three;
            b4: disp1 <= four;
            b5: disp1 <= five;
            b6: disp1 <= six;
            b7: disp1 <= seven;
            b8: disp1 <= eight;
            b9: disp1 <= nine;
            default: disp1 <= zero;
        endcase
    end
    
    always @(bin2, disp3, disp4) begin
            tens2 = 4'd0;
            ones2 = 4'd0;
            
            for(x = 7; x >= 0; x = x - 1) begin
                if(tens2 >= 5)
                    tens2 = tens2 + 3;
                if(ones2 >= 5)
                    ones2 = ones2 + 3;
                    
                tens2 = tens2 << 1;
                tens2[0] = ones2[3];
                ones2 = ones2 << 1;
                ones2[0] = bin2[x];
            end
            
            case(tens2)
                b0: disp4 <= zero;
                b1: disp4 <= one;
                b2: disp4 <= two;
                b3: disp4 <= three;
                b4: disp4 <= four;
                b5: disp4 <= five;
                b6: disp4 <= six;
                b7: disp4 <= seven;
                b8: disp4 <= eight;
                b9: disp4 <= nine;
                default: disp4 <= zero;
            endcase
            
            case(ones2)
                b0: disp3 <= zero;
                b1: disp3 <= one;
                b2: disp3 <= two;
                b3: disp3 <= three;
                b4: disp3 <= four;
                b5: disp3 <= five;
                b6: disp3 <= six;
                b7: disp3 <= seven;
                b8: disp3 <= eight;
                b9: disp3 <= nine;
                default: disp3 <= zero;
            endcase
        end
endmodule
