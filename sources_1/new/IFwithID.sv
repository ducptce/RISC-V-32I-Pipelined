`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2024 12:59:01 AM
// Design Name: 
// Module Name: IFwithID
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


module IFwithID (input logic clk, reset, clear, enable,
            input logic [31:0] instF, PCF,
            output logic [31:0] instD, PCD);


always_ff @( posedge clk, posedge reset ) begin
    if (reset) begin // Asynchronous Clear
        instD <= 0;
        PCD <= 0;
    end

    else if (enable) begin 
		 if (clear) begin // Synchrnous Clear
			  instD <= 0;
			  PCD <= 0; 
		 end
		 
		 else begin	 
			  instD <= instF;
			  PCD <= PCF;
		 end
	 end
end

endmodule