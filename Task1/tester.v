`timescale 1ns / 1ps

module Risc_tb();
   reg clk, reset;
   wire [63:0] PC_Out;
   wire [31:0] Instruction;
   wire [6:0] opcode;
   wire [4:0] rd;
   wire [4:0] rs1;
   wire [4:0] rs2;
   wire [63:0] imm_data;
   wire [1:0] ALUOp;
   wire [63:0] WriteData;
   wire [63:0] ReadData1;
   wire [63:0] ReadData2;
   wire Branch;
   wire MemWrite;
   wire MemRead;
   wire MemtoReg;
   wire ALUSrc;
   wire RegWrite;
   wire [63:0] Result;
   wire [63:0] Read_Data;

   // Instantiate the top module
Top_Module riscv(clk, reset,PC_Out,Instruction,opcode,rd,rs1,rs2,imm_data,ALUOp, PC_Out, WriteData,  ReadData1, ReadData2, 
         Branch,  MemWrite,MemRead, MemtoReg, ALUSrc, RegWrite,Result, Read_Data,);
// Clock generation
initial begin
  clk = 1'b0; reset = 1'b1;
  //#10 reset = 1'b1;
  #20 reset = 1'b0;
  //#160 reset = 1'b1;
  //#20 reset = 1'b0;
end

always #20 clk = ~clk;

endmodule