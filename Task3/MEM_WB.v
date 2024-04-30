`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 09:49:25 PM
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
input clk,reset,
  input [63:0] read_data,
  input [63:0] result, //ALU Result
  input [4:0] rd,
  input memtoreg, regwrite, //ex mem output as mem wb inputs
  output reg [63:0] mem_wb_read_data, 
  output reg [63:0] mem_wb_result,
  output reg [4:0] mem_wb_rd,
  output reg mem_wb_memtoreg, mem_wb_regwrite
);
  
  always @(posedge clk)begin
         mem_wb_read_data = read_data;
          mem_wb_result = result;
          mem_wb_rd = rd;
          mem_wb_memtoreg = memtoreg;
          mem_wb_regwrite = regwrite;
    end
endmodule
