`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 11:14:36 PM
// Design Name: 
// Module Name: RISCV_Processor
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

module RISCV_Processor(input clk,
    input reset,
    output reg [63:0] PC_In, PC_Out, ReadData1, ReadData2, WriteData, Result, Read_Data, imm_data,
    output reg [31:0] Instruction,
    output reg [6:0] opcode,
    output reg [4:0] rs1, rs2, rd,
    output reg [1:0] ALUOp,
    output reg [63:0] adder_out1, adder_out2,
    output reg Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite, addermuxselect,
    output wire [63:0] if_id_pc_out,
    output wire [31:0] if_id_inst,
    output wire [63:0] id_ex_pc_out,id_ex_read_data1,id_ex_read_data2, id_ex_immGen,
    output wire [4:0]  id_ex_rd,
    output wire [3:0] id_ex_funct,
    output wire id_ex_branch, id_ex_memread, id_ex_memtoreg, id_ex_memwrite, id_ex_regwrite, id_ex_alusrc,
    output wire [1:0] id_ex_aluop,
    output wire [63:0] ex_mem_adderout,
    output wire ex_mem_zero,
    output wire [63:0] ex_mem_result,
    output wire [63:0] ex_mem_writedata,
    output wire [4:0] ex_mem_rd,
    output wire ex_mem_branch, ex_mem_memread, ex_mem_memtoreg, ex_mem_memwrite, ex_mem_regwrite,
    output wire [63:0] mem_wb_read_data,
    output wire [63:0] mem_wb_result,
    output wire[4:0] mem_wb_rd,
    output wire mem_wb_memtoreg, mem_wb_regwrite
    );

wire [63:0] PC_In, PC_Out, adder_out1, adder_out2, imm_data, WriteData, ReadData1, ReadData2, Result, Read_Data;
wire [63:0] muxmid_out;
wire [31:0] Instruction;
wire [6:0] opcode, funct7;
wire [4:0] rd, rs1, rs2;
wire [3:0] Funct, Operation;
wire [2:0] funct3;
wire [1:0] ALUOp;
wire Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite, Zero, addermuxselect;
wire [63:0] index0, index1, index2, index3, index4;

wire [63:0] if_id_pc_out;
wire [31:0] if_id_inst;
wire [63:0] id_ex_pc_out,id_ex_read_data1,id_ex_read_data2, id_ex_immGen;
wire [4:0]  id_ex_rd;
wire [3:0] id_ex_funct;
wire id_ex_branch, id_ex_memread, id_ex_memtoreg, id_ex_memwrite, id_ex_regwrite, id_ex_alusrc;
wire [1:0] id_ex_aluop;
wire [63:0] ex_mem_adderout;
wire ex_mem_zero;
wire [63:0] ex_mem_result;
wire [63:0] ex_mem_writedata;
wire [4:0] ex_mem_rd;
wire ex_mem_branch, ex_mem_memread, ex_mem_memtoreg, ex_mem_memwrite, ex_mem_regwrite;
wire [63:0] mem_wb_read_data;
wire [63:0] mem_wb_result;
wire[4:0] mem_wb_rd;
wire mem_wb_memtoreg;







// Instruction Fetch //
Adder A1(.A(PC_Out), .B(64'd4), .Out(adder_out1));
Mux_2x1 muxfirst(.A(adder_out1), .B(adder_out2), .S(Branch && addermuxselect), .Out(PC_In));
Program_Counter PC(.clk(clk), .reset(reset), .PC_In(PC_In), .PC_Out(PC_Out));
Instruction_Memory IM(.Inst_Address(PC_Out), .Instruction(Instruction));

// IF/ID pipeline

IF_ID if_id(.clk(clk),.reset(reset), .PC_out(PC_Out), .Instruction(Instruction), .if_id_pc_out(if_id_pc_out), .if_id_inst(if_id_inst));

// Instruction Decode / Register File Read //
Instruction_Parser IP(.Instruction(if_id_inst), .Opcode(opcode), .RD(rd), .Funct3(funct3), .RS1(rs1), .RS2(rs2), .Funct7(funct7));
Imm_Gen Immgen(.Instruction(if_id_inst), .Imm(imm_data));
Control_Unit cu(.Opcode(opcode), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));
RegisterFile rf(.clk(clk), .reset(reset), .WriteData(WriteData), .RS1(rs1), .RS2(rs2), .RD(rd), .RegWrite(RegWrite), .ReadData1(ReadData1), .ReadData2(ReadData2));
assign Funct = {if_id_inst[30], if_id_inst[14:12]};

// ID/Ex pipeline
ID_EX id_ex(.clk(clk), .reset(reset), .if_id_pc_out(if_id_pc_out), .read_data1(ReadData1), .read_data2(ReadData2), .immGen(imm_data), .rd(rd), .funct3(Funct), .branch(Branch), .memread(MemRead), .memtoreg(MemtoReg), .memwrite(MemWrite), .regwrite(RegWrite), .alusrc(ALUSrc), .aluop(ALUOp), .id_ex_pc_out(id_ex_pc_out), .id_ex_read_data1(id_ex_read_data1), .id_ex_read_data2(id_ex_read_data2), .id_ex_immGen(id_ex_immGen), .id_ex_rd(id_ex_rd), .id_ex_funct3(id_ex_funct), .id_ex_branch(id_ex_branch), .id_ex_memread(id_ex_memread), .id_ex_memtoreg(id_ex_memtoreg), .id_ex_memwrite(id_ex_memwrite), .id_ex_regwrite(id_ex_regwrite), .id_ex_alusrc(id_ex_alusrc), .id_ex_aluop(id_ex_aluop));

// Execute / Address Calculation // 
Adder A2(.A(id_ex_pc_out), .B(id_ex_immGen * 2), .Out(adder_out2));
Mux_2x1 muxmid(.A(ReadData2), .B(id_ex_immGen), .S(id_ex_alusrc), .Out(muxmid_out));
ALU_Control aluc(.ALUOp(id_ex_aluop), .Funct(id_ex_funct), .Operation(Operation));
ALU64bit ALU(.A(ReadData1), .B(muxmid_out), .ALUOp(Operation), .Result(Result));
Branch_unit BU(.Funct3(funct3), .ReadData1(ReadData1), .ReadData2(ReadData2), .addermuxselect(addermuxselect)); //zero = addermuxselect

//EX_MEM pipeline
EX_MEM ex_mem(.clk(clk), .reset(reset), .adderout(adder_out2), .result(Result), .zero(addermuxselect), .write_data(id_ex_read_data2), .rd(id_ex_rd), .branch(id_ex_branch), .memread(id_ex_memread), .memtoreg(id_ex_memtoreg), .memwrite(id_ex_memwrite), .regwrite(id_ex_regwrite), .ex_mem_adderout(ex_mem_adderout), .ex_mem_zero(ex_mem_zero), .ex_mem_result(ex_mem_result), .ex_mem_writedata(ex_mem_writedata), .ex_mem_rd(ex_mem_rd), .ex_mem_branch(ex_mem_branch), .ex_mem_memread(ex_mem_memread), .ex_mem_memtoreg(ex_mem_memtoreg), .ex_mem_memwrite(ex_mem_memwrite), .ex_mem_regwrite(ex_mem_regwrite));

//Data_Memory DM(.Mem_Addr(Result), .Write_Data(ReadData2), .clk(clk), .MemWrite(MemWrite), .MemRead(MemRead), .Read_Data(Read_Data));
Data_Memory DM(.clk(clk), .MemWrite(MemWrite), .MemRead(MemRead), .Mem_Addr(Result), .Write_Data(ReadData2), .Read_Data(Read_Data), .index0(index0), .index1(index1), .index2(index2), .index3(index3), .index4(index4));

//MEM_WB
MEM_WB mem_wb(.clk(clk), .reset(reset), .read_data(Read_Data), .result(ex_mem_result), .rd(ex_mem_rd), .memtoreg(ex_mem_memtoreg), .regwrite(ex_mem_regwrite), .mem_wb_read_data(mem_wb_read_data), .mem_wb_result(mem_wb_result), .mem_wb_rd(mem_wb_rd), .mem_wb_memtoreg(mem_wb_memtoreg), .mem_wb_regwrite(mem_wb_regwrite));

// Write Back // 
Mux_2x1 muxlast(.A(Result), .B(Read_Data), .S(MemtoReg), .Out(WriteData));
endmodule
