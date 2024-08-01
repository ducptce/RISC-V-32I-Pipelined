`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2024 06:12:32 PM
// Design Name: 
// Module Name: BranchComp
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


module BrancheComp(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic BrUn,
    output logic BrEq,
    output logic BrLT
);

    always_comb begin
        // BrEq is true if A equals B
        BrEq = (A == B);

        // BrLt is true if A is less than B
        if (BrUn) begin
            // Unsigned comparison
            BrLT = (A < B);
        end else begin
            // Signed comparison
            BrLT = ($signed(A) < $signed(B));
        end
    end

endmodule