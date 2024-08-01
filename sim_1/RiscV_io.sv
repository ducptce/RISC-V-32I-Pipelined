`timescale 1ns / 1ps

interface riscv_io(input bit clk);
    logic reset;
    logic [31:0] inst; 
	logic [31:0] DataW,  Addr; 
	logic MemRW;
   clocking cb @ (posedge clk);
    default input #1ns output #1ns;
    output clk, reset;
    output inst;
	input DataW,  Addr;
	input MemRW;
   endclocking
    modport TB(clocking cb, output reset);
    
endinterface