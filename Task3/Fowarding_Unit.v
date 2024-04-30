`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 11:24:21 PM
// Design Name: 
// Module Name: Fowarding_Unit
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


module Fowarding_Unit(
    input [4:0] EXMEM_rd, MEMWB_rd,
    input [4:0] IDEX_rs1, IDEX_rs2,
    input EXMEM_RegWrite, EXMEM_MemtoReg,
    input MEMWB_RegWrite,

    output reg [1:0] fwd_A, fwd_B
);

always @(*) begin
    // forwarding for operand A
    if (EXMEM_rd == IDEX_rs1 && EXMEM_RegWrite && EXMEM_rd != 0) begin
        fwd_A = 2'b10;  // forward value from the EX/MEM stage
    end 
    else if ((MEMWB_rd == IDEX_rs1) && MEMWB_RegWrite && (MEMWB_rd != 0) &&
               !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs1))) begin
        fwd_A = 2'b01;  // forward value from the MEM/WB stage
    end 
    else begin
        fwd_A = 2'b00;  // No forwarding for operand A
    end
    
    // forwarding for operand B
    if ((EXMEM_rd == IDEX_rs2) && EXMEM_RegWrite && EXMEM_rd != 0) begin
        fwd_B = 2'b10;  // forward value from the EX/MEM stage
    end
    else if ((MEMWB_rd == IDEX_rs2) && (MEMWB_RegWrite == 1) && (MEMWB_rd != 0) &&
               !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs2))) begin
        fwd_B = 2'b01;  // forward value from the MEM/WB  stage
    end
    else begin
        fwd_B = 2'b00;  // No forwarding for operand B
    end
end

endmodule
