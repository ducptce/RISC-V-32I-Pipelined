`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:14:52 AM
// Design Name: 
// Module Name: c_IDwithEX
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

// c?n khúc m?t ch? branch

module c_IDwithEX(input logic clk, reset, clear,
        input logic RegWEnD, MemRWD, PCSelD, ASelD,BSelD,
        input logic WBSelD, 
        input logic [3:0] ALUSelD,  
        output logic RegWEnE, MemRWE, PCSelE,  ASelE,BSelE,
        output logic WBSelE,
        output logic [3:0] ALUSelE);
        
always_ff @( posedge clk, posedge reset ) begin

		if (reset) begin
			RegWEnE <= 0;
			MemRWE <= 0;
			PCSelE <= 0; 
			ASelE <= 0;
			BSelE <= 0;
			WBSelE <= 0;
			ALUSelE <= 0;          
		end

		else if (clear) begin
			RegWEnE <= 0;
			MemRWE <= 0;
			PCSelE <= 0; 
			ASelE <= 0;
			BSelE <= 0;
			WBSelE <= 0;
			ALUSelE <= 0;    			
		end
		
		else begin
			RegWEnE <= RegWEnD;
			MemRWE <= MemRWD;
			PCSelE <= PCSelD; 
			ASelE <= ASelD;
			BSelE <= BSelD;
			WBSelE <= WBSelD;
			ALUSelE <= ALUSelD;   
		end
		 
	 end
  
endmodule

