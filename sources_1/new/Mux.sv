`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 02:41:05 PM
// Design Name: 
// Module Name: Mux
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


module Mux(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic  sel,
    output logic [31:0] result
    );
    assign result = (sel) ? a : b;
endmodule

module Mux3(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [31:0] c,
    input logic  [1:0] sel,
    output logic [31:0] result
    );
    assign result = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b : c;
endmodule
