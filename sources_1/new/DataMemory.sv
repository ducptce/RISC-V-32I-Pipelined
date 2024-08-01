`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 05:50:48 PM
// Design Name: 
// Module Name: DataMemory
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
/*
module Data_Memory(
    input  logic        clk,    // Clock signal
    input  logic        rst,    // Reset signal
    input  logic        MemRW,  // Memory Read/Write control signal (1 for Write, 0 for Read)
    input  logic [31:0] Addr,   // Address for memory access
    input  logic [31:0] DataW,  // Data to be written to memory
    output logic [31:0] DataR   // Data read from memory
);
    logic [31:0] mem [63:0];
    
    always_ff @ (posedge clk)
    begin
        if(MemRW)
        //MemRW = 1 write, = 0 Read
            mem[Addr] <= DataW;
    end

    assign DataR = (~rst) ? 32'd0 : mem[Addr];

    initial begin
        mem[0] = 32'h00000000;
        //mem[40] = 32'h00000002;
    end

endmodule
*/
module DataMemory(
    input  logic        clk,    // Clock signal
    input  logic        MemRW,  // Memory Read/Write control signal (1 for Write, 0 for Read)
    input  logic [31:0] Addr,   // Address for memory access
    input  logic [31:0] DataW,  // Data to be written to memory
    output logic [31:0] DataR   // Data read from memory
);

    // 64 x 32 bit memory
    logic [31:0] RAM [63:0]; 

    // Read operation
    assign DataR = RAM[Addr[31:2]];

    // Write operation
    always_ff @(posedge clk) begin
        if (MemRW) begin
            RAM[Addr[31:2]] <= DataW;
        end
    end

endmodule