`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 07:10:10 PM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen (
    input  logic [31:0] Imm,      // Immediate field from instruction
    input  logic [2:0]  ImmSel,   // Immediate type selector
    output logic [31:0] New_Imm   // Generated immediate value
);

    assign New_Imm = (ImmSel == 3'b000) ? {{20{Imm[31]}}, Imm[31:20]}                             : // I-type
                     (ImmSel == 3'b001) ? {{20{Imm[31]}}, Imm[31:25], Imm[11:7]}                  : // S-type
                     (ImmSel == 3'b010) ? {{20{Imm[31]}}, Imm[7], Imm[30:25], Imm[11:8], 1'b0}    : // B-type
                     (ImmSel == 3'b011) ? {{12{Imm[31]}}, Imm[19:12], Imm[20], Imm[30:25], Imm[24:21], 1'b0} : // J-type
                     (ImmSel == 3'b100) ? {Imm[31:12], 12'h000}                                   : // U-type
                                           32'b0;                                                   // Default case

endmodule
