`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 11:32:31 PM
// Design Name: 
// Module Name: Mux3_1
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


module Mux3_1(
    input [63:0] a, b, c,
    input [1:0] sel,
    output reg [63:0] out   
);

always @(*) begin
    if (sel == 2'b00) begin   
        out = a;
    end
    else if (sel == 2'b01) begin    
        out = b;
    end
    else if (sel == 2'b10) begin    
        out = c;
    end
    else 
    begin    
        out = 2'bX;
    end
end


endmodule