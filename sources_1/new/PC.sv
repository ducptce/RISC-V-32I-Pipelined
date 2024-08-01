`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 12:45:14 AM
// Design Name: 
// Module Name: PC
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

module PC (
    input logic clk,          // Clock signal
    input logic reset,        // Reset signal
    input logic enable,       // Enable signal
    input logic [31:0] pc_in, // Input address
    output logic [31:0] pc_out // Output address (current PC)
);

    // On the positive edge of the clock, check for reset and enable signals
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0; // Reset the PC to 0
        end else if (enable) begin
            pc_out <= pc_in; // Update the PC with the input value
        end
    end

endmodule
