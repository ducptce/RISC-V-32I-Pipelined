`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2024 09:13:51 PM
// Design Name: 
// Module Name: Controller
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


module Controller(
    input  logic clk, reset,
    input  logic [6:0] op,       // Instruction opcode
    input  logic [6:0] funct7,   // Instruction funct7 field
    input  logic [2:0] funct3,   // Instruction funct3 field
    input  logic       BrEq,     // Branch equal flag
    input  logic       BrLT,     // Branch less than flag
    input  logic       ID_EX_Flush,// assert when MemRW = 0 ( 0 read 1 write)
    input  logic       Zero,
    output logic [2:0] ImmSel,   // Immediate select
    output logic       WBSel,    // Write-back select 
    output logic       PCSel,    // Program counter select
    output logic       RegWEnM, // use for EX_MEM_RegWrite
    output logic       RegWEn,   // Register write enable
    output logic       BrUn,     // Branch unsigned
    output logic       BSel,     // Select between Imm or RS2 into ALU
    output logic       ASel,     // Select between PC or RS1 use for JALR
    output logic       MemRW,    // Memory read/write
    output logic [3:0] ALUSel,     // ALU operation
    output logic       IF_Flush        // Added IF_Flush signal
    );
    
    logic PCSelD,  PCSelE,  PCSelM; // PCSelM dùng ð? assign
    logic WBSelD,  WBSelE,  WBSelM;
    logic RegWEnD, RegWEnE;
    logic ASelD;
    logic BSelD;
    logic MemRWD,  MemRWE;
    logic [3:0] ALUSelD;
    MainDec Control(.clk(clk),
                    .reset(reset),
                    .op(op),
                    .funct7(funct7),
                    .funct3(funct3),
                    .BrEq(BrEq),
                    .BrLT(BrLT),
                    .ImmSel(ImmSel),
                    .WBSel(WBSelD),
                    .PCSel(PCSelD),
                    .RegWEn(RegWEnD),
                    .BrUn(BrUn),
                    .BSel(BSelD),
                    .ASel(ASelD),
                    .MemRW(MemRWD),
                    .ALUSel(ALUSelD),
                    .IF_Flush(IF_Flush));
    c_IDwithEX c_pipe1(clk, reset, ID_EX_Flush, RegWEnD , MemRWD, PCSelD, ASelD, BSelD, WBSelD, ALUSelD,
                                                RegWEnE, MemRWE, PCSelE,  ASel,BSel,WBSelE, ALUSel);
    c_EXwithMEM c_pipe2(clk, reset, RegWEnE, MemRWE, WBSelE, PCSelE,
                                    RegWEnM, MemRW, WBSelM, PCSelM);
    assign PCSel = PCSelM & Zero;                               
    c_MEMwithWB c_pipe3(clk, reset, RegWEnM, WBSelM ,  
                                    RegWEn, WBSel);                                                                                   
endmodule
