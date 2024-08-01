`timescale 1ns / 1ps


module HazardDetectionUnit (
    input logic [4:0] ID_EX_RegRd,
    input logic [4:0] IF_ID_RegRs1, 
    input logic [4:0] IF_ID_RegRs2,
    input logic ID_EX_MemRead, // assert when MemRW = 0 ( 0 read 1 write)
    output logic PCWrite, // StallF
    output logic IF_ID_Write, // StallD
    output logic ID_EX_Flush // FlushE
);

    always_comb begin
        // Default signals
        PCWrite = 1;
        IF_ID_Write = 1;
        ID_EX_Flush = 0;    // allow control signal

        // Detect load-use hazard
        if (ID_EX_MemRead == 1 && ((ID_EX_RegRd == IF_ID_RegRs1) || (ID_EX_RegRd == IF_ID_RegRs2))) begin
            PCWrite = 0;
            IF_ID_Write = 0;
            ID_EX_Flush = 1; //block control signal( all 0 )
        end
    end

endmodule
