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

module RISCV_Processor(
    input clk,
    input reset,
    output wire [63:0] index0, index1,  index2,  index3,  index4
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


wire [63:0] if_id_pc_out;
wire [31:0] if_id_inst;
wire [63:0] id_ex_pc_out,id_ex_read_data1,id_ex_read_data2, id_ex_immGen;
wire [4:0]  id_ex_rd, id_ex_rs1, id_ex_rs2;
wire [3:0] id_ex_funct;
wire id_ex_branch, id_ex_memread, id_ex_memtoreg, id_ex_memwrite, id_ex_regwrite, id_ex_alusrc;
wire [1:0] id_ex_aluop;
wire [63:0] ex_mem_adderout;
wire [63:0] ex_mem_result;
wire [63:0] ex_mem_writedata,ex_mem_readdata1,ex_mem_readdata2;
wire [4:0] ex_mem_rd;
wire ex_mem_branch, ex_mem_memread, ex_mem_memtoreg, ex_mem_memwrite, ex_mem_regwrite;
wire [63:0] mem_wb_read_data;
wire [63:0] mem_wb_result;
wire[4:0] mem_wb_rd;
wire mem_wb_memtoreg, mem_wb_regwrite;
wire [1:0] fwd_A_out, fwd_B_out;
wire [63:0] triplemux_to_a, triplemux_to_b;
wire flush_out;
wire IFID_Write_out;
wire control_mux_sel;
wire PCWrite_out;



Mux_2x1 prcsrcmux (
    .A(adder_out2), 
    .B(adder_out1), 
    .S(addermuxselect),
    .Out(PC_In));
    
Program_Counter PC (.clk(clk),
                    .reset(reset),
                    .PCWrite(PCWrite_out),
                    .PC_In(PC_In),
                    .PC_Out(PC_Out)
                    );
                    
Adder pcadder (.A(PC_Out),
               .B(64'd4),
               .Out(adder_out1)
               );
               
Instruction_Memory IM (.Inst_Address(PC_Out), 
               .Instruction(Instruction)
                );

//// IF/ID pipeline
IF_ID if_id(.clk(clk),
            .flush(flush_out),
            .PC_out(PC_Out),
            .IFID_write(IFID_Write_out), 
            .Instruction(Instruction),
            .if_id_pc_out(if_id_pc_out), 
            .if_id_inst(if_id_inst)
            );

Hazard_Detection hu (
        .current_rd(id_ex_rd),
        .prev_rs1(rs1),
        .prev_rs2(rs2),
        .current_MemRead(id_ex_memread),
        .mux_out(control_mux_sel),
        .enable_Write(IFID_Write_out),
        .enable_PCWrite(PCWrite_out)
        );

Instruction_Parser IP(.Instruction(if_id_inst),
              .Opcode(opcode), 
              .RD(rd), 
              .Funct3(funct3), 
              .RS1(rs1), 
              .RS2(rs2), 
              .Funct7(funct7));

assign Funct = {if_id_inst[30], if_id_inst[14:12]};

Control_Unit cu(.Opcode(opcode),
                .Branch(Branch), 
                .MemRead(MemRead),
                .MemtoReg(MemtoReg),
                .ALUOp(ALUOp), 
                .MemWrite(MemWrite),
                .ALUSrc(ALUSrc),
                .RegWrite(RegWrite)
                );

RegisterFile rf(
                .clk(clk),
                .reset(reset),
                .WriteData(WriteData),
                .RS1(rs1), .RS2(rs2), 
                .RD(rd), 
                .RegWrite(RegWrite),
                .ReadData1(ReadData1),
                .ReadData2(ReadData2));

Imm_Gen Immgen(.Instruction(if_id_inst),
               .Imm(imm_data));



//mux for id_ex reg to flush out control signal
assign id_ex_memtoreg = control_mux_sel ? MemtoReg : 0;
assign id_ex_regwrite = control_mux_sel ? RegWrite : 0;
assign id_ex_branch  = control_mux_sel ? Branch : 0;
assign id_ex_memwrite = control_mux_sel ? MemWrite : 0;
assign  id_ex_memread = control_mux_sel ? MemRead : 0;
assign id_ex_alusrc = control_mux_sel ? ALUSrc : 0;
assign id_ex_aluop = control_mux_sel ? ALUOp : 2'b00;

ID_EX id_ex(.clk(clk), 
            .flush(flush_out), 
            .if_id_pc_out(if_id_pc_out), 
            .read_data1(ReadData1), 
            .read_data2(ReadData2), 
            .immGen(imm_data), 
            .rd(rd),
            .rs1(rs1),
            .rs2(rs2), 
            .funct3(Funct),
            .branch(Branch),
            .memread(MemRead),
            .memtoreg(MemtoReg), 
            .memwrite(MemWrite), 
            .regwrite(RegWrite), 
            .alusrc(ALUSrc), 
            .aluop(ALUOp),
            
            .id_ex_pc_out(id_ex_pc_out), 
            .id_ex_read_data1(id_ex_read_data1), 
            .id_ex_read_data2(id_ex_read_data2), 
            .id_ex_immGen(id_ex_immGen), 
            .id_ex_rd(id_ex_rd), 
            .id_ex_rs1(id_ex_rs1),
            .id_ex_rs2(id_ex_rs2),
            .id_ex_funct3(id_ex_funct),
            .id_ex_branch(id_ex_branch),
            .id_ex_memread(id_ex_memread),
            .id_ex_memtoreg(id_ex_memtoreg),
            .id_ex_memwrite(id_ex_memwrite),
            .id_ex_regwrite(id_ex_regwrite),
            .id_ex_alusrc(id_ex_alusrc),
            .id_ex_aluop(id_ex_aluop)
            );

ALU_Control aluc(.ALUOp(id_ex_aluop),
                 .Funct(id_ex_funct),
                 .Operation(Operation));


Mux_2x1 ALU_mux(.A(id_ex_immGen),
                .B(triplemux_to_b),
                .S(id_ex_alusrc),
                .Out(muxmid_out));


Mux3_1 muxFwd_a (.a(id_ex_read_data1),.b(WriteData),.c(ex_mem_result),.sel(fwd_A_out),.out(triplemux_to_a));

Mux3_1 muxFwd_b(.a(id_ex_read_data2),.b(WriteData), .c(ex_mem_result),.sel(fwd_B_out),.out(triplemux_to_b));

ALU64bit ALU(.A(triplemux_to_a), .B(muxmid_out), .ALUOp(Operation), .Result(Result));


Fowarding_Unit Fwd_unit (
    .EXMEM_rd(ex_mem_rd),
    .MEMWB_rd(mem_wb_rd),
    .IDEX_rs1(id_ex_rs1),
    .IDEX_rs2(id_ex_rs2),
    .EXMEM_RegWrite(ex_mem_regwrite),
    .EXMEM_MemtoReg(ex_mem_memtoreg),
    .MEMWB_RegWrite(mem_wb_regwrite),
    .fwd_A(fwd_A_out),
    .fwd_B(fwd_B_out)
);


//assign imm_to_adder = id_ex_immGen << 1;

Adder PC_Imm(.A(id_ex_pc_out),.B(id_ex_immGen*2),.Out(adder_out2));

EX_MEM ex_mem(.clk(clk),
              .flush(flush_out),
              .adderout(adder_out2), 
              .result(Result),
              .funct3(id_ex_funct) ,
              .write_data(triplemux_to_b), 
              .rd(id_ex_rd),
              .read_data1(triplemux_to_a), 
              .branch(id_ex_branch), 
              .memread(id_ex_memread), 
              .memtoreg(id_ex_memtoreg), 
              .memwrite(id_ex_memwrite), 
              .regwrite(id_ex_regwrite), 
              
              .ex_mem_adderout(ex_mem_adderout),
              .ex_mem_result(ex_mem_result), 
              .ex_mem_writedata(ex_mem_writedata), 
              .ex_mem_rd(ex_mem_rd),
              .ex_mem_branch(ex_mem_branch),
              .ex_mem_memread(ex_mem_memread),
              .ex_mem_memtoreg(ex_mem_memtoreg),
              .ex_mem_memwrite(ex_mem_memwrite),
              .ex_mem_regwrite(ex_mem_regwrite),
              .ex_mem_readdata1(ex_mem_readdata1),
              .ex_mem_funct(ex_mem_funct) ); 
              
              

Branch_unit bu (.Branch(ex_mem_branch),
    .Funct3(funct3),
    .ReadData1(ex_mem_readdata1),
    .ReadData2(ex_mem_writedata),
    .addermuxselect(addermuxselect),
    .flush(flush_out));

Data_Memory DM (.clk(clk), 
    .MemWrite(ex_memwrite), 
    .MemRead(ex_memread), 
    .Mem_Addr(ex_mem_result),
    .Write_Data(ex_mem_readata2), 
    .Read_Data(Read_Data),
    .index0(index0),
    .index1(index1),
    .index2(index2),
    .index3(index3),
    .index4(index4));

MEM_WB mem_wb(.clk(clk), .read_data(Read_Data), .result(ex_mem_result), .rd(ex_mem_rd), .memtoreg(ex_mem_memtoreg), .regwrite(ex_mem_regwrite), .mem_wb_read_data(mem_wb_read_data), .mem_wb_result(mem_wb_result), .mem_wb_rd(mem_wb_rd), .mem_wb_memtoreg(mem_wb_memtoreg), .mem_wb_regwrite(mem_wb_regwrite));

Mux_2x1 WBRmux (.A(mem_wb_read_data),.B(mem_wb_result),.S(mem_wb_regwrite),.Out(WriteData));


endmodule
