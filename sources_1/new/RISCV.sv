`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 03:29:46 PM
// Design Name: 
// Module Name: RISCV
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


module RISCV(input logic clk, reset,
    output logic [31:0] PCF,
    input logic [31:0] instF,
    output logic MemRW,
    output logic [31:0] ALUResultM, DataW,
    input logic [31:0] DataRM
    );
    logic PCSel, BrUn,WBSel;
    logic [31:0] instD, DataR, DataWM;
    logic RegWEnM, RegWEn,BrEq,BrLT, Zero, BSel, ASel;
    logic [3:0] ALUSel;
    logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E;
    logic [4:0] RdE, RdM, RdW;
    logic ID_EX_Flush,IF_Flush, IF_ID_Write, PCWrite;
    logic [2:0] ImmSel;
    logic [1:0] ForwardA, ForwardB;
    Datapath dp (.clk(clk),
                 .reset(reset),
                 .ID_EX_Flush(ID_EX_Flush),
                 .IF_Flush(IF_Flush),
                 .IF_ID_Write(IF_ID_Write),
                 .PCSel(PCSel),
                 .ASel( ASel),
                 .BSel(BSel),
                 .ImmSel(ImmSel),
                 .ForwardAE(ForwardA),
                 .ForwardBE(ForwardB),
                 .PCWrite(PCWrite),
                 .instF(instF),
                 .RegWEn(RegWEn),
                 .BrUn(BrUn),
                 .ALUSel(ALUSel),
                 .DataR(DataR),
                 .MemRW(MemRW),
                 .WBSel(WBSel),
                 .PCF(PCF),
                 .instD(instD),
                 .BrEq(BrEq),
                 .BrLT(BrLT),
                 .Rs1D(Rs1D),
                 .Rs2D(Rs2D),
                 .Rs1E(Rs1E),
                 .Rs2E(Rs2E),
                 .ALUResultM(ALUResultM),
                 .DataW(DataW),
                 .Zero(Zero),
                 .RdE(RdE),
                 .RdM(RdM),
                 .RdW(RdW));
    Controller c(.clk(clk),
                 .reset(reset),
                 .op(instD[6:0]),
                 .funct7(instD[31:25]),
                 .funct3(instD[14:12]),
                 .BrEq(BrEq),
                 .BrLT(BrLT),
                 .ID_EX_Flush(ID_EX_Flush),
                 .Zero(Zero),
                 .ImmSel(ImmSel),
                 .WBSel(WBSel),
                 .PCSel(PCSel),
                 .RegWEnM(RegWEnM),
                 .RegWEn(RegWEn),
                 .BrUn(BrUn),
                 .BSel(BSel),
                 .ASel(ASel),
                 .MemRW(MemRW),
                 .ALUSel(ALUSel),
                 .IF_Flush(IF_Flush));
     ForwardingUnit fw(.EX_MEM_RegRd(RdM),
                        .MEM_WB_RegRd( RdW),
                        .ID_EX_RegRs1(Rs1E),
                        .ID_EX_RegRs2(Rs2E),
                        .EX_MEM_RegWrite(RegWEnM),
                        .MEM_WB_RegWrite(RegWEn),
                        .ForwardA(ForwardA),
                        .ForwardB(ForwardB)); 
     HazardDetectionUnit h(.ID_EX_RegRd(RdE),
                            .IF_ID_RegRs1(Rs1D),
                            .IF_ID_RegRs2(Rs2D),
                            .ID_EX_MemRead(WBSel), // load hazard
                            .PCWrite(PCWrite),
                            .IF_ID_Write(IF_ID_Write),
                            .ID_EX_Flush(ID_EX_Flush));               
endmodule
