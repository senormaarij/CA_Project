`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 07:26:33 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input clk,
    input reset,
    input [63:0] PC_out,
    input [31:0] Instruction,
    output reg [63:0] if_id_pc_out,
    output reg [31:0] if_id_inst
    );
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            if_id_pc_out = 0;
            if_id_inst = 0;
            end
        else begin
            if_id_pc_out = PC_out;
            if_id_inst = Instruction;
            end
    end
endmodule
