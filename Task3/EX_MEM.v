`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 09:39:56 PM
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
input clk,flush,
  input [63:0] adderout, //add sum
  input [63:0] result,//ALU Result
  input [3:0] funct3,
  input [63:0] read_data1,write_data, //2 bit mux2by1 output
  input [4:0] rd, //IDEX output
  input branch, memread, memtoreg, memwrite, regwrite, //IDEXX outputs
  output reg [63:0] ex_mem_adderout,
  output reg[3:0] ex_mem_funct,
  output reg [63:0] ex_mem_result,
  output reg [63:0] ex_mem_writedata,ex_mem_readdata1,
  output reg [4:0] ex_mem_rd,
  output reg ex_mem_branch, ex_mem_memread, ex_mem_memtoreg, ex_mem_memwrite, ex_mem_regwrite
  );
  
  always @(posedge clk)
    begin
      if (flush)
        begin
          ex_mem_adderout = 64'b0;
          ex_mem_funct = 0;
          ex_mem_result = 63'b0;
          ex_mem_writedata = 64'b0;
          ex_mem_rd = 5'b0;
          ex_mem_readdata1 =  0;
          ex_mem_branch = 1'b0;
          ex_mem_memread = 1'b0;
          ex_mem_memtoreg =1'b0;
          ex_mem_memwrite = 1'b0;
          ex_mem_regwrite = 1'b0;
        end
      else
        begin
          ex_mem_adderout = adderout;
          ex_mem_result = result;
          ex_mem_writedata = write_data;
          ex_mem_funct = funct3;
          ex_mem_rd = rd;
          ex_mem_readdata1 =  read_data1;
          ex_mem_branch = branch;
          ex_mem_memread = memread;
          ex_mem_memtoreg = memtoreg;
          ex_mem_memwrite = memwrite;
          ex_mem_regwrite = regwrite;
        end
    end
endmodule