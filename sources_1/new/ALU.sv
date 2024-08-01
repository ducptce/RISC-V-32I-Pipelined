module ALU (
    input  logic [31:0] A,         // First operand
    input  logic [31:0] B,         // Second operand
    input  logic [3:0]  ALUSel,    // ALU control signal
    output logic [31:0] ALUResult, // Result of the ALU operation
    output logic        Zero       // Zero flag
);

    // ALU Control signals
    localparam AND  = 4'b0000;
    localparam OR   = 4'b0001;
    localparam ADD  = 4'b0010;
    localparam XOR  = 4'b0011;
    localparam SRL  = 4'b0100; // Shift right logical
    localparam SLL  = 4'b0101; // Shift left logical
    localparam SUB  = 4'b0110;
    localparam SRA  = 4'b0111; // Shift right arithmetic
    localparam SLT  = 4'b1000; // Set on less than
    localparam SLTU = 4'b1001; // Set on less than unsigned
    // ALU Operation
    
    always_comb begin
        case (ALUSel)
            AND:   ALUResult = A & B;
            OR:    ALUResult = A | B;
            ADD:   ALUResult = A + B;
            SUB:   ALUResult = A - B;
            XOR:   ALUResult = A ^ B;
            SLL:   ALUResult = A << B;  // SLLI because funct7(0000000) + shamt = imm =>> B = shamt
            SRL:   ALUResult = A >> B;
            SRA:   ALUResult = $signed(A) >>> B;
            SLT:   ALUResult = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLTI because BSel choose imm or rs2 to ALU already
            SLTU:  ALUResult = (A < B) ? 32'b1 : 32'b0;
            default: ALUResult = 32'b0;
        endcase
    end

    // Zero flag is set if ALUResult is zero
    assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;

endmodule