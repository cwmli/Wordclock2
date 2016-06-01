`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2016 06:30:47 PM
// Design Name: 
// Module Name: digits
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


module digits(
        input refFreq,
        input secFreq,
        input active,
        input disptime,
        input dispdtime,
        input disputime,
        input [7:0] num1a, input [7:0] num1b, input [7:0] num1c, input [7:0] num1d,
        input [7:0] num2a, input [7:0] num2b, input [7:0] num2c, input [7:0] num2d,
        input [7:0] num3a, input [7:0] num3b, input [7:0] num3c, input [7:0] num3d,
        output reg [6:0] segm,
        output reg [3:0] anm,
        output reg dp
    );
    
    parameter off = 8'b11111111;
    
    reg [3:0] state;
    reg [7:0] activenum1;
    reg [7:0] activenum2;
    reg [7:0] activenum3;
    reg [7:0] activenum4;
    
    always @(posedge refFreq) begin
        if (disputime) begin
            activenum1 <= num3a;
            activenum2 <= num3b;
            activenum3 <= num3c;
            activenum4 <= num3d;
        end else if (dispdtime) begin
            activenum1 <= num2a;
            activenum2 <= num2b;
            activenum3 <= num2c;
            activenum4 <= num2d;
        end else begin
            activenum1 <= num1a;
            activenum2 <= num1b;
            activenum3 <= num1c;
            activenum4 <= num1d;
        end
    end
    
    always @(posedge refFreq)
        if (active)
            case(state)
                0:begin anm <= 4'b1110; state <= 1; end
                1:begin segm <= activenum1; dp <= secFreq; state <= 2; end
                2:begin segm <= off; dp <= 1'b1; state <= 3; end
                3:begin anm <= 4'b1101; state <= 4; end
                4:begin segm <= activenum2; state <= 5; end
                5:begin segm <= off; state <= 6; end
                6:begin anm <= 4'b1011; state <= 7; end
                7:begin segm <= activenum3; state <= 8; end
                8:begin segm <= off; state <= 9; end
                9:begin anm <= 4'b0111; state <= 10; end
                10:begin segm <= activenum4; state <= 11; end 
                11:begin segm <= off; state <= 0; end           
                default: state <= 0;
            endcase 
        else 
            anm <= 4'b1111;    
endmodule
