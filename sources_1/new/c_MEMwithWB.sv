`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 05:20:52 PM
// Design Name: 
// Module Name: c_MEMwithWB
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


module c_MEMwithWB(input logic clk, reset, 
                input logic RegWEnM, 
                input logic  WBSelM, 
                output logic RegWEnW, 
                output logic WBSelW);

    always_ff @( posedge clk, posedge reset ) begin
        if (reset) begin
            RegWEnW <= 0;
            WBSelW <= 0;           
        end

        else begin
            RegWEnW <= RegWEnM;
            WBSelW <= WBSelM; // lol this wasted 1 hour
        end

    end

endmodule
