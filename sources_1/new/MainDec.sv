`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 07:08:19 PM
// Design Name: 
// Module Name: MainDec
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

module MainDec (
    input  logic clk, reset,
    input  logic [6:0] op,       // Instruction opcode
    input  logic [6:0] funct7,   // Instruction funct7 field
    input  logic [2:0] funct3,   // Instruction funct3 field
    input  logic       BrEq,     // Branch equal flag
    input  logic       BrLT,     // Branch less than flag
    output logic [2:0] ImmSel,   // Immediate select
    output logic       WBSel,    // Write-back select 
    output logic       PCSel,    // Program counter select
    output logic       RegWEn,   // Register write enable
    output logic       BrUn,     // Branch unsigned
    output logic       BSel,     // Select between Imm or RS2 into ALU
    output logic       ASel,     // Select between PC or RS1 use for JALR
    output logic       MemRW,    // Memory read/write
    output logic [3:0] ALUSel,     // ALU operation
    output logic IF_Flush        // Added IF_Flush signal
);
    
    logic [15:0] controls;
    logic PCSel_temp;
    // Control signal defaults
    assign {RegWEn, ImmSel, ASel, BSel, MemRW, WBSel, PCSel, ALUSel, BrUn, IF_Flush} = {controls[15:10], PCSel_temp, controls[9:0]};
    always_comb begin
        //RegWEn, ImmSel, ASel, BSel, MemRW, WBSel, PCSel, ALUSel, BrUn, IF_Flush
        // Default control signals
        ImmSel   = 3'b111;  
        WBSel    = 1'b0;   // 00 DataR, 01 ALU Result, 10 PC +4
                            // 0 ALUResultW 1 DataRW
        PCSel    = 1'b0;    // 1 Adder Imm 0 PC+4
        RegWEn   = 1'b0;    // 1 write data 0 no write
        BrUn     = 1'b0;    // 0 signed 1 unsigned
        BSel     = 1'b0;    // 0 rs2 1 imm
        ASel     = 1'b0;    // 0 rs1 1 32'b0 for LUI instruction
        MemRW    = 1'b0;    // 0 read 1 write
        ALUSel    = 4'b1111;
        IF_Flush = 0; // Default value
        case (op)
        7'b0110011: 
        begin // R-type instructions
                RegWEn = 1;
                ImmSel = 3'b111; // No immediate
                BSel   = 0;
                ASel   = 0;
                case (funct3)
                    3'b000: ALUSel = (funct7 == 7'b0000000) ? 4'b0010 : // ADD
                                      (funct7 == 7'b0100000) ? 4'b0110 : // SUB
                                      4'b1111; // Default
                    3'b111: ALUSel = 4'b0000; // AND
                    3'b110: ALUSel = 4'b0001; // OR
                    3'b100: ALUSel = 4'b0011; // XOR
                    3'b001: ALUSel = 4'b0101; // SLL
                    3'b101: ALUSel = (funct7 == 7'b0000000) ? 4'b0100 : // SRL
                                      (funct7 == 7'b0100000) ? 4'b0111 : // SRA
                                      4'b1111; // Default
                    3'b010: ALUSel = 4'b1000; // SLT
                    3'b011: ALUSel = 4'b1001; // SLTU
                    default: ALUSel = 4'b1111;
                endcase
                MemRW    = 1'b0;
                WBSel = 1'b0; // ALU result
                PCSel    = 1'b0;
            end
            7'b0010011: begin // I-type instructions
                RegWEn = 1;
                ImmSel = 3'b000; // I-type immediate
                BSel   = 1;        // Imm
                ASel   = 0;
                case (funct3)
                    3'b000: ALUSel = 4'b0010; // ADDI
                    3'b111: ALUSel = 4'b0000; // ANDI
                    3'b110: ALUSel = 4'b0001; // ORI
                    3'b100: ALUSel = 4'b0011; // XORI
                    3'b001: ALUSel = 4'b0101; // SLLI
                    3'b101: ALUSel = (funct7 == 7'b0000000) ? 4'b0100 : // SRLI
                                      (funct7 == 7'b0100000) ? 4'b0111 : // SRAI
                                      4'b1111; // Default
                    3'b010: ALUSel = 4'b1000; // SLTI
                    3'b011: ALUSel = 4'b1001; // SLTIU
                    default: ALUSel = 4'b1111;
                endcase
                MemRW    = 1'b0;
                WBSel = 1'b0; // ALU result
                PCSel    = 1'b0;
            end
            7'b0000011: begin // Load instructions
                RegWEn = 1;
                ImmSel = 3'b000; // I-type immediate
                BSel   = 1;
                ASel   = 0;
                ALUSel  = 4'b0010; // ADD for address calculation
                MemRW  = 0; // Read
                WBSel  = 1'b1; // Load data from memory
            end
            7'b0100011: begin // Store instructions
                RegWEn = 0;
                ImmSel = 3'b001; // S-type immediate
                BSel   = 1;
                ASel   = 0;
                ALUSel  = 4'b0010; // ADD for address calculation
                MemRW  = 1; // Write
            end
            7'b1100011: begin // Branch instructions
                ImmSel = 3'b010; // B-type immediate
                BSel   = 1'b0;  //rd2
                ASel   = 0;
                MemRW = 0;
                IF_Flush = 1; // Set IF_Flush for branch instructions
                case (funct3)
                    3'b000: begin // BEQ
                        assign PCSel = BrEq;
                        BrUn  = 0;
                    end
                    3'b001: begin // BNE
                        assign PCSel = ~BrEq;
                        BrUn  = 0;
                    end
                    3'b100: begin // BLT
                        assign PCSel = BrLT;
                        BrUn  = 0;
                    end
                    3'b101: begin // BGE
                        assign PCSel = ~BrLT;
                        BrUn  = 0;
                    end
                    3'b110: begin // BLTU
                        assign PCSel = BrLT;
                        BrUn  = 1;
                    end
                    3'b111: begin // BGEU
                        assign PCSel = ~BrLT;
                        BrUn  = 1;
                    end
                    default: PCSel = 0;
                endcase
            end
            7'b0010111: begin // AUIPC
                PCSel = 0;
                RegWEn = 1;
                BSel = 1;
                ASel = 1;
                ALUSel = 4'b0010;
                MemRW = 0;
                WBSel = 1'b0;  // ALU result
                ImmSel = 3'b100; // Utype
            end
            7'b0110111: begin // Lui
                PCSel = 0;
                RegWEn = 1;
                BSel = 1;
                ASel = 1;
                ALUSel = 4'b0010;
                MemRW = 0;
                WBSel = 1'b0;  // ALU result
                ImmSel = 3'b100; // Utype
            end
            
            7'b1101111: begin // JAL
                PCSel = 1;
                RegWEn = 1;
                BSel = 1;
                ASel = 0;
                ALUSel = 4'b0010;
                MemRW = 0;
                WBSel = 1'b0;  
                ImmSel = 3'b011; // Jtype
            end
            
            7'b1100111: begin // JALR
                PCSel = 1;
                RegWEn = 1;
                BSel = 1;
                ASel = 0;
                ALUSel = 4'b0010;
                MemRW = 0;
                ImmSel = 3'b000; // Itype
            end
                
            default: begin
                ImmSel   = 3'b000;
                WBSel    = 1'b0;
                PCSel    = 1'b0;
                RegWEn   = 1'b0;
                BrUn     = 1'b0;
                BSel     = 1'b0;
                ASel     = 1'b0;
                MemRW    = 1'b0;
                ALUSel    = 4'b0000;
                IF_Flush = 1'b0;
            end
        endcase
    end
            
    
endmodule

/*
7'b0110011: begin
                case (funct3)
                3'b000: controls = (funct7 == 7'b0000000) ? 16'b1_111_0_0_0_0_0_0010_x_0 : // ADD
                                      (funct7 == 7'b0100000) ? 16'b1_111_0_0_0_0_0_0110_x_0 : // SUB
                                      16'b1_111_0_0_0_0_0_1111_x_0; // Default
                3'b111: controls = 16'b1_111_0_0_0_0_0_0000_x_0; // AND
                3'b110: controls = 16'b1_111_0_0_0_0_0_0001_x_0; // OR
                3'b100: controls = 16'b1_111_0_0_0_0_0_0011_x_0; // XOR
                3'b001: controls = 16'b1_111_0_0_0_0_0_0101_x_0; // SLL
                3'b101: controls = (funct7 == 7'b0000000) ? 16'b1_111_0_0_0_0_0_0100_x_0 : // SRL
                                      (funct7 == 7'b0100000) ? 16'b1_111_0_0_0_0_0_0111_x_0 : // SRA
                                      16'b1_111_0_0_0_0_0_1111_x_0; // Default
                3'b010: controls = 16'b1_111_0_0_0_0_0_1000_x_0; // SLT
                3'b011: controls = 16'b1_111_0_0_0_0_0_1001_x_0; // SLTU
                default: controls = 16'b1_111_0_0_0_0_0_1111_x_0; // Default
                endcase
            end
 
            7'b0010011: begin // I-type instructions
                case (funct3)
                3'b000: controls = 16'b1_000_0_1_0_0_0_0010_x_0; // ADDI
                3'b111: controls = 16'b1_000_0_1_0_0_0_0000_x_0; // ANDI
                3'b110: controls = 16'b1_000_0_1_0_0_0_0001_x_0; // ORI
                3'b100: controls = 16'b1_000_0_1_0_0_0_0011_x_0; // XORI
                3'b001: controls = 16'b1_000_0_1_0_0_0_0101_x_0; // SLLI
                3'b101: controls = (funct7 == 7'b0000000) ? 16'b1_000_0_1_0_0_0_0100_x_0 : // SRLI
                                      (funct7 == 7'b0100000) ? 16'b1_000_0_1_0_0_0_0111_x_0 : // SRAI
                                      16'b1_000_0_1_0_0_0_1111_x_0; // Default
                3'b010: controls = 16'b1_000_0_1_0_0_0_1000_x_0; // SLTI
                3'b011: controls = 16'b1_000_0_1_0_0_0_1001_x_0; // SLTIU
                default: controls = 16'b1_000_0_1_0_0_0_1111_x_0; // Default
                endcase
                end  
            7'b0000011:  // Load instructions
                controls = 16'b1_000_0_1_0_0_0_0010_x_0; // Load instructions
                
            7'b0100011: begin // Store instructions
                controls = 16'b0_001_0_1_1_x_0_0010_x_0; // Store instructions
                
            end
            7'b1100011: begin // Branch instructions
                IF_Flush = 1; // Set IF_Flush for branch instructions
                case (funct3)
                3'b000: begin // BEQ
                    PCSel_temp = BrEq;
                    controls = 16'b0_010_0_1_0_0_0_0000_0_1;
                end
                3'b001: begin // BNE
                    PCSel_temp = ~BrEq;
                    controls = 16'b0_010_0_1_0_0_0_0000_0_1;
                end
                3'b100: begin // BLT
                    PCSel_temp = BrLT;
                    controls = 16'b0_010_0_1_0_0_0_0000_0_1;
                end
                3'b101: begin // BGE
                    PCSel_temp = ~BrLT;
                    controls = 16'b0_010_0_1_0_0_0_0000_0_1;
                end
                3'b110: begin // BLTU
                    PCSel_temp = BrLT;
                    controls = 16'b0_010_0_1_0_0_0_0000_1_1;
                end
                3'b111: begin // BGEU
                    PCSel_temp = ~BrLT;
                    controls = 16'b0_010_0_1_0_0_0_0000_1_1;
                end
                default: begin // Default
                    PCSel_temp = 0;
                    controls = 16'b0_010_0_1_0_0_0_0000_0_1;
                end
                endcase
            end
            7'b0010111: begin // AUIPC
                controls = 16'b1_100_1_1_0_0_0_0010_x_0; // AUIPC
            end
            7'b0110111: begin // Lui
                controls = 16'b1_100_1_1_0_0_0_0010_x_0; // LUI
            end
            
            7'b1101111: begin // JAL
                controls = 16'b1_011_0_1_0_1_1_0010_x_0; // JAL
            end
            
            7'b1100111: begin // JALR
                controls = 16'b1_001_0_1_0_x_1_0010_x_0; // JALR
            end
                
            default: controls = 16'b0_000_0_0_0_0_0_0000_0_0; // Default
        endcase
    end
   */