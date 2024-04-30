`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2023 09:56:57 AM
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
 input clk,
 input reset,
 output [63:0] PC_Out,
 
 output [31:0]Instruction,
 output [6:0]opcode,
 output [4:0]rd,
 output [4:0]rs1,
 output [4:0]rs2,
 output [63:0] imm_data,
 output [1:0]ALUOp,
 output [63:0]WriteData,
 output [63:0]ReadData1,
output [63:0]ReadData2,

output Branch,
output MemWrite,
output MemRead,
output MemtoReg,
 output ALUSrc,
output RegWrite,
output [63:0] Result,
output [63:0] Read_Data
 
    );
wire [63:0] PC_In;

wire [63:0]Inst_Address;

wire [2:0]funct3;
wire [3:0]Funct;

wire [6:0]funct;

wire [3:0] Operation;

wire [63:0]data_out;
wire [63:0] Adder1_Out;
wire [63:0] Adder2_Out;
wire [63:0] a;
wire [63:0]b;
wire [1:0]sel;

//adder
Adder A1( a, b, Adder1_Out );
  
Mux M1(Adder1_Out, Adder2_Out, sel, PC_In);

Program_Counter P1( clk, reset,PC_In,PC_Out);

// Instantiate the adder

// Instantiate the mux


// Instantiate the instruction memory
Instruction_Memory I1(Inst_Address,Instruction);

// Instantiate the instruction parser
InsParser I2(Instruction,opcode,rd,funct3, rs1,rs2,funct);

// Instantiate the immediate generator
ImmGen I3( Instruction, imm_data );

// Instantiate the control unit
Control_Unit C1( opcode, Branch, MemRead, MemtoReg,MemWrite, ALUSrc,
RegWrite, ALUOp);

// Instantiate the register file
registerFile R1( WriteData, rs1, rs2, rd, RegWrite,clk,reset,ReadData1,ReadData2);

// Instantiate the mux
Mux M2( ReadData1,imm_data, sel, data_out);

// Instantiate the ALU control
ALU_Control A2( ALUOp, Funct, Operation);

// Instantiate the ALU
ALU_64_bit A5( ReadData1,data_out, Operation, Result, ZERO);

// Instantiate the data memory
Data_Memory D1( Result,ReadData2, clk,MemWrite,MemRead, Read_Data);

// Instantiate the write back mux
Mux M3( Result, Read_Data, MemtoReg, WriteData);

    
endmodule