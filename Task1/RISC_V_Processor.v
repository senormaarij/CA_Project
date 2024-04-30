`timescale 1ns / 1ps

module RISC_V_Processor(
    input clk,
    input reset,
    output wire [63:0] PC_Out,
    output wire [31:0] Instruction,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output wire [63:0]WriteData,
    output wire [63:0]ReadData1,
    output wire [63:0]ReadData2,
    output wire [63:0]imm_data,
    output wire [63:0] dataout,
    output wire [63:0] Result,
    output wire ZERO,
    output wire [63:0] Read_Data,
    output wire [6:0] opcode,
    output wire Branch,
    output wire MemRead,
    output wire MemtoReg,
    output wire MemWrite,
    output wire ALUSrc,
    output wire RegWrite,
    output wire [1:0] ALUOp
);
wire [63:0] PC_In;
Program_Counter PC(clk,reset,PC_In,PC_Out);
    
wire [63:0] Y;
Adder A1(PC_Out, 4, Y);
    
Instruction_Memory IM(PC_Out,Instruction);

wire [2:0] funct3;
wire [6:0] funct7;
InsParser IP(Instruction,opcode,rd, funct3, rs1,rs2,funct7);

Control_Unit CU(opcode,Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

registerFile RF(WriteData,rs1,rs2,rd, RegWrite,clk, reset, ReadData1, ReadData2);

ImmGen IG(Instruction, imm_data);

wire [3:0] Funct = {Instruction[30], funct3};
wire [3:0] Operation;
ALU_Control AC(ALUOp,Funct,Operation);

Mux M1(ReadData2,imm_data ,ALUSrc,dataout);

ALU_64_bit A(ReadData1, dataout,Operation, Result,ZERO);

Data_Memory DM(Result,ReadData2,clk, MemWrite, MemRead,Read_Data);

Mux M2(Read_Data,Result,MemtoReg,WriteData);

wire [63:0] b = imm_data << 1;
wire [63:0] out;
Adder A2(PC_Out,b,out);

wire PC_Src = Branch&ZERO;
Mux M3(Y,out,PC_Src,PC_In);

endmodule
