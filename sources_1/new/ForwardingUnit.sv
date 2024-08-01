module ForwardingUnit (
    input logic [4:0] EX_MEM_RegRd, 
    input logic [4:0] MEM_WB_RegRd,
    input logic [4:0] ID_EX_RegRs1, 
    input logic [4:0] ID_EX_RegRs2,
    input logic EX_MEM_RegWrite, 
    input logic MEM_WB_RegWrite,
    output logic [1:0] ForwardA, 
    output logic [1:0] ForwardB
);

    always_comb begin
        // Default forwarding values
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        // ALU input comes from RF
        
        // EX hazard
        //ALU input is forwarded from the prior ALU result 
        if (EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRs1)) begin
            ForwardA = 2'b10;
        end
        if (EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRs2)) begin
            ForwardB = 2'b10;
        end

        // MEM hazard
        // ALU input is forwarded from the data memory or a prior ALU Result
        if (MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_RegRs1) && !(EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRs1))) begin
            ForwardA = 2'b01;
        end
        if (MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_RegRs2) && !(EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRs2))) begin
            ForwardB = 2'b01;
        end
    end

endmodule