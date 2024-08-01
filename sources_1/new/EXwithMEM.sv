`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:00:33 AM
// Design Name: 
// Module Name: EXwithMEM
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

module EXwithMEM(input logic clk, reset,
                input logic [31:0] ALUResultE, DataWE, 
                input logic [4:0] RdE, 
                output logic [31:0] ALUResultM, DataWM,
                output logic [4:0] RdM);

always_ff @( posedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultM <= 0;
        DataWM <= 0;
        RdM <= 0; 
    end

    else begin
        ALUResultM <= ALUResultE;
        DataWM <= DataWE;
        RdM <= RdE;       
    end
    
end

endmodule
