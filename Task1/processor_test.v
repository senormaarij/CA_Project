`timescale 1ns / 1ps

module RISC_V_Processor(
input clk,
input rst,
output wire [63:0] PC_out, 
output wire [31:0] Inst, 
output wire [4:0] rs2, 
output wire [4:0] rs1, 
output wire [4:0] rd, 
output wire [63:0] read_data1,
output wire [63:0] read_data2, 
output wire [63:0] write_data,
output wire [63:0] imm_data,
output wire [63:0] read_from_mem,
output wire [63:0] m1_out,
output wire [63:0] aluRes
);

wire [63:0] ad1;
wire [63:0] ad2;

wire [6:0] funct7;
wire [2:0] funct3;
wire [6:0] opcode;


wire  [1:0] ALUOp;
wire  Branch;
wire  MemRead;
wire  MemtoReg;
wire  MemWrite;
wire  ALUSrc;
wire  RegWrite;

wire [63:0] m2_out;

wire zero;

wire [3:0] op;

Program_Counter pc(clk, rst, m2_out, PC_out);

Adder aa(PC_out, 4, ad1);

Instruction_Memory im(PC_out, Inst);

InsParser ip(Inst, opcode, rd,funct3, rs1, rs2, funct7);

Control_Unit cu(opcode,Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);

registerFile rf(write_data, rs1, rs2, rd,RegWrite ,clk,rst, read_data1, read_data2);

ImmGen ide(Inst, imm_data);



Mux m1(imm_data, read_data2, ALUSrc, m1_out);

Adder ab(imm_data*2, PC_out, ad2);
ALU_Control ac(ALUOp, {(Inst[30]),(Inst[14:12])},op);
ALU_64_bit alu(read_data1, m1_out, op, aluRes, zero); 
Mux m2(ad2, ad1, {Branch&&zero}, m2_out);
Data_Memory dm(aluRes,read_data2,clk, MemWrite, MemRead, read_from_mem);
Mux m3(read_from_mem, aluRes, MemtoReg, write_data);
endmodule