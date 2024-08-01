`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:05:15 AM
// Design Name: 
// Module Name: IDwithEX
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


module IDwithEX(input logic clk, reset, clear,
                input logic [31:0] DataAD, DataBD, 
                input logic [4:0] Rs1D, Rs2D, RdD, 
                input logic [31:0] New_ImmD,
                output logic [31:0] DataAE, DataBE,
                output logic [4:0] Rs1E, Rs2E, RdE, 
                output logic [31:0] New_ImmE);

    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            DataAE <= 0;
            DataBE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            New_ImmE <= 0;
        end
        else if (clear) begin
            DataAE <= 0;
            DataBE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            New_ImmE <= 0;
        end
        else begin
            DataAE <= DataAD;
            DataBE <= DataBD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            New_ImmE <= New_ImmD;
        end

    end

endmodule
