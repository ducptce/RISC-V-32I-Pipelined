`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 04:20:36 PM
// Design Name: 
// Module Name: top
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


module top(input logic 			clk, reset, 
            input  logic [31:0]     inst,
			output logic [31:0] 	DataW,  Addr, 
			output logic 			MemRW);
				
	logic [31:0] PCF, instF, DataRM;
	
// instantiate processor and memories

	RISCV rv(clk, reset, PCF, instF, MemRW, Addr, DataW, DataRM);
	InstructionMemory imem(PCF,inst, instF);
	DataMemory dmem(clk, MemRW, Addr, DataW, DataRM);
endmodule