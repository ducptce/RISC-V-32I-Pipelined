`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 02:17:40 PM
// Design Name: 
// Module Name: InstructionMemory
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


module InstructionMemory (
    input  logic [31:0] addr, 
    input  logic [31:0] inst, 
    output logic [31:0] instF
);

    logic [31:0] RAM [127:0]; // 128 x 32-bit memory locations

    always_comb begin
        RAM[addr] = inst;
    end

    assign instF = RAM[addr]; 
endmodule   