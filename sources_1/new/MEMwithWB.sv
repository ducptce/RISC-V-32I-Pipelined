`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 01:10:30 AM
// Design Name: 
// Module Name: MEMwithWB
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


module MEMwithWB(input logic clk, reset,
                input logic [31:0] ALUResultM, DataRM,  
                input logic [4:0] RdM, 
                output logic [31:0] ALUResultW, DataRW,
                output logic [4:0] RdW);

always_ff @( posedge clk, posedge reset ) begin 
    if (reset) begin
        ALUResultW <= 0;
        DataRW <= 0;
        
        RdW <= 0; 
    end

    else begin
        ALUResultW <= ALUResultM;
        DataRW <= DataRM;
        
        RdW <= RdM;    
    end
    
end

endmodule
