`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2024 07:34:02 PM
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input clk,
    input reset,
    input  [63:0] if_id_pc_out,read_data1,read_data2, immGen,
    input  [4:0] rd,
    input  [3:0] funct3,
    input  branch, memread, memtoreg, memwrite, regwrite, alusrc,
    input  [1:0] aluop,
    output reg [63:0]id_ex_pc_out,id_ex_read_data1,id_ex_read_data2, id_ex_immGen,
    output reg [4:0]  id_ex_rd,
    output reg [3:0] id_ex_funct3,
    output reg id_ex_branch, id_ex_memread, id_ex_memtoreg, id_ex_memwrite, id_ex_regwrite, id_ex_alusrc,
    output reg [1:0] id_ex_aluop
    );
    
always @(posedge clk) begin
    // if reset then 0 all
    if (reset == 1'b1)begin
        id_ex_pc_out = 0;
        id_ex_read_data1 = 0;
        id_ex_read_data2 = 0;
        id_ex_immGen = 0;
        id_ex_rd = 0;
        id_ex_funct3 = 0;
        id_ex_branch = 0;
        id_ex_memread = 0;
        id_ex_memtoreg = 0;
        id_ex_memwrite = 0;
        id_ex_regwrite = 0;
        id_ex_alusrc = 0;
        id_ex_aluop = 0;
        end
    // assign the values that are coming in this pipeline.
    else begin
        id_ex_pc_out = if_id_pc_out;
        id_ex_read_data1 = read_data1;
        id_ex_read_data2 = read_data2;
        id_ex_immGen = immGen;
        id_ex_rd = rd;
        id_ex_funct3 = funct3;
        id_ex_branch = branch;
        id_ex_memread = memread;
        id_ex_memtoreg = memtoreg;
        id_ex_memwrite = memwrite;
        id_ex_regwrite = regwrite;
        id_ex_alusrc = alusrc;
        id_ex_aluop = aluop;
        end
        
    end
endmodule
