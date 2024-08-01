`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 02:29:46 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input logic clk,RegWEn,
    input logic [31:0] DataD,
    input logic [4:0] AddrD,
    input logic [4:0] AddrA,
    input logic [4:0] AddrB,
    output logic [31:0] DataA,
    output logic [31:0] DataB
    );
    // Write with RegWEn = 1, Read with RegWEn = 0
    // 32 registers, each 32 bits wide
    logic [31:0] registers [0:31];
    
    
    // Write to register file
    always_ff @(posedge clk) begin 
        if (RegWEn && AddrD != 5'd0) begin
            // Write DataD to register AddrD if RegWEn is enabled and AddrD is not zero (x0 is hardwired to 0)
            registers[AddrD] <= DataD;
        end
    end

    // Read from register file
    assign DataA = (AddrA != 5'd0) ? registers[AddrA] : 32'b0; // Read register AddrA, x0 always reads 0
    assign DataB = (AddrB != 5'd0) ? registers[AddrB] : 32'b0; // Read register AddrB, x0 always reads 0

endmodule
