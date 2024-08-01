`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 07:11:01 PM
// Design Name: 
// Module Name: Datapath
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



module Datapath(
    input logic clk, reset,
    //i/o mux if
    input logic PCWrite,IF_ID_Write, IF_Flush,ID_EX_Flush,
    input logic PCSel, ASel, BSel,
    input logic [1:0] ForwardAE, ForwardBE,
    input logic [2:0] ImmSel,
    //i/o PC
    output logic [31:0] PCF,
    //i/o Fetch
    input logic [31:0] instF,
    output logic [31:0] instD,
    //i/o Reg
    input logic RegWEn,
    //i/o BrCo
    input logic BrUn,
    output logic BrEq,
    output logic BrLT,
    //
    output logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E,
    //
    input logic [3:0] ALUSel,
    output logic [31:0] ALUResultM,DataW,
    input logic [31:0] DataR,
    output logic Zero,
    //
    output logic [4:0] RdE, RdM, RdW,
    //MEM-WB
    input logic MemRW,
    input logic WBSel);
    // mux PC
    logic [31:0] PCPlus4F, PCJARL, PCNextF, PCD;
    logic [31:0] Rd1D, Rd2D,Rd1E,Rd2E;
    logic [31:0] New_Imm, DataWE;
    logic [31:0] DataWB, New_ImmE;
    logic [31:0] ALUResultE, DataWE, ALUResultW, DataRW;
    logic [4:0] RdD; // destination register address
    logic [31:0] DataAE,DataBE,SrcAEfor;
    // Fetch Stage
    Mux muxPC (.b(PCPlus4F), .a(PCJARL), .sel(PCSel), .result(PCNextF));
    PC PC(.clk(clk),.reset(reset),.enable(PCWrite), .pc_in(PCNextF), .pc_out(PCF));
    Adder add4(.a(PCF), .b(32'd4), .s(PCPlus4F));
    //InstructionMemory imem (.addr(PCF), .inst(instF));
    
    // Instruction Fetch - Decode Pipeline Register	
    IFwithID pipe1(.clk(clk), .reset(reset), .clear(IF_Flush), .enable(IF_ID_Write), .instF(instF), .PCF(PCF),
                    .instD(instD), .PCD(PCD));
    assign Rs1D = instD[19:15];                
    assign Rs2D = instD[24:20];
    assign RdD = instD[11:7];
    RegisterFile rf( .clk(clk), .RegWEn(RegWEn), .AddrA(Rs1D),
                    .AddrB(Rs2D), .AddrD(RdW), .DataD(DataWB),
                    .DataA(Rd1D), .DataB(Rd2D));
    ImmGen ImmGen(instD[31:0], ImmSel, New_Imm);
    assign iPCJARL = New_Imm << 1;
    Adder addimmforjarl(.a(iPCJARL), .b(PCD), .s(PCJARL));
    BrancheComp branch(.A(Rd1D), .B(Rd2D), .BrUn(BrUn), .BrEq(BrEq), .BrLT(BrLT));
    
    // Decode - Execute Pipeline Register
    IDwithEX pipe2(.clk(clk), .reset(reset),.clear(ID_EX_Flush), .DataAD(Rd1D), .DataBD(Rd2D),
                .Rs1D(Rs1D), .Rs2D(Rs2D), .RdD(RdD),
                .New_ImmD(New_Imm), 
                .DataAE(Rd1E), .DataBE(Rd2E),
                .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE),
                .New_ImmE(New_ImmE));
    Mux3 forwardmuxA(Rd1E, DataWB, ALUResultM, ForwardAE, SrcAEfor);
    Mux3 forwardmuxB(Rd2E, DataWB, ALUResultM, ForwardBE, DataWE);
    Mux srcamux(.b(SrcAEfor), .a(32'b0), .sel(ASel), .result(DataAE)); //0 32'b0 1 rs1  for lui
    Mux srcbmux(.b(DataWE), .a(New_ImmE), .sel(BSel), .result(DataBE)); //0 rs2 1 imm
    ALU ALU(.A(DataAE), .B(DataBE), .ALUResult(ALUResultE), .ALUSel(ALUSel), .Zero(Zero));
    
    // Execute - Memory Access Pipeline Register
    EXwithMEM pipe3 (.clk(clk), .reset(reset), .ALUResultE(ALUResultE), .DataWE(DataWE),.RdE(RdE), 
                     .ALUResultM(ALUResultM), .DataWM(DataW), .RdM(RdM) );
    //Data_Memory( .clk(clk),.reset(reset), .MemRW(MemRW), .Addr(ALUResultM), .DataW(DataW),.DataR(DataR));
    // Memory - Register Write Back Stage
    MEMwithWB pipe4 (.clk(clk), .reset(reset), .ALUResultM(ALUResultM), .DataRM(DataR), .RdM(RdM)
                    ,.ALUResultW(ALUResultW), .DataRW(DataRW), .RdW(RdW));
    Mux WriteBack(.b(ALUResultW), .a(DataRW), .sel(WBSel), .result(DataWB)); // 0 ALUResultW 1 DataRW
    
endmodule
