`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 05:23:56 PM
// Design Name: 
// Module Name: c_EXwithMEM
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


module c_EXwithMEM(input logic clk, reset,
                input logic RegWEnE, MemRWE,
                input logic  WBSelE,  PCSelE,
                output logic RegWEnM, MemRWM,
                output logic WBSelM, PCSelM);

    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            RegWEnM <= 0;
            MemRWM <= 0;
            WBSelM <= 0;
            PCSelM <= 0;
        end
        else begin
            RegWEnM <= RegWEnE;
            MemRWM <= MemRWE;
            WBSelM <= WBSelE; 
            PCSelM <= PCSelE;
        end
        
    end
endmodule
