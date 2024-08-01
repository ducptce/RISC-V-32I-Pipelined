`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2024 04:28:43 PM
// Design Name: 
// Module Name: testbench
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


`timescale 1ns / 1ps

module testbench;
    reg clk;
    reg reset;
    reg [31:0] instr;
    wire [31:0] alu_result;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz clock
    end

    // Instantiate the RISC-V processor
    riscv_processor rv_cpu (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .alu_result(alu_result)
    );

    // Memory to hold instructions
    reg [31:0] mem [38:0];

    // Expected values for ALU results
    reg [31:0] expected_values [38:0];
    
    initial begin
        // Initialize memory with instructions
        mem[0]  = 32'h00500113; // addi x2, x0, 5
        mem[1]  = 32'h00C00193; // addi x3, x0, 12
        mem[2]  = 32'hFF718393; // addi x7, x3, -9
        mem[3]  = 32'h0023E233; // or x4, x7, x2
        mem[4]  = 32'h0041C2B3; // xor x5, x3, x4
        mem[5]  = 32'h004282B3; // add x5, x5, x4
        mem[6]  = 32'h02728863; // beq x5, x7, 48 (Flushes the next instruction if taken)
        mem[7]  = 32'h0041A233; // slt x4, x3, x4 (Flushed if branch taken)
        mem[8]  = 32'h00020463; // beq x4, x0, 8
        mem[9]  = 32'h00000293; // addi x5, x0, 0
        mem[10] = 32'h0023A233; // slt x4, x7, x2
        mem[11] = 32'h005203B3; // add x7, x4, x5
        mem[12] = 32'h402383B3; // sub x7, x7, x2
        mem[13] = 32'h0471AA23; // sw x7, 84(x3)
        mem[14] = 32'h06002103; // lw x2, 96(x0)
        mem[15] = 32'h005104B3; // add x9, x2, x5
        mem[16] = 32'h008001EF; // jal x3, 8 (Stalls for jump calculation)
        mem[17] = 32'h00100113; // addi x2, x0, 1 (Flushed if jal not taken)
        mem[18] = 32'h00910133; // add x2, x2, x9
        mem[19] = 32'h00100213; // addi x4, x0, 1
        mem[20] = 32'h800002B7; // lui x5, -524288
        mem[21] = 32'h0042A333; // slt x6, x5, x4
        mem[22] = 32'h00030063; // beq x6, x0, 0
        mem[23] = 32'hABCDE4B7; // lui x9, -344866
        mem[24] = 32'h00910133; // add x2, x2, x9
        mem[25] = 32'h0421A023; // sw x2, 64(x3)
        mem[26] = 32'h00210063; // beq x2, x2, 0
        mem[27] = 32'h00628533; // add x10, x5, x6
        mem[28] = 32'h00629633; // sub x12, x5, x6
        mem[29] = 32'h007316B3; // or x13, x6, x7
        mem[30] = 32'h00728733; // and x14, x5, x7
        mem[31] = 32'h00128293; // slli x5, x5, 1
        mem[32] = 32'h00129313; // srli x6, x5, 1
        mem[33] = 32'h4012A333; // srai x6, x5, 1
        mem[34] = 32'h00028293; // addi x5, x5, 0
        mem[35] = 32'h00A002B7; // lui x5, 0xA0000
        mem[36] = 32'h00A00337; // lui x6, 0xA0000
        mem[37] = 32'hFE528EE3; // bne x5, x2, -24 (Flushes the next instruction if taken)
        mem[38] = 32'h00008067; // ret

        // Expected ALU results
        expected_values[0]  = 32'd0;
        expected_values[1]  = 32'd5;
        expected_values[2]  = 32'd12;
        expected_values[3]  = 32'd3;
        expected_values[4]  = 32'd7;
        expected_values[5]  = 32'd11;
        expected_values[6]  = 32'd18;
        expected_values[7]  = 32'd15;
        expected_values[8]  = 32'd0;
        expected_values[9]  = 32'd0;
        expected_values[10] = 32'd0;
        expected_values[11] = 32'd18;
        expected_values[12] = 32'd13;
        expected_values[13] = 32'd96;
        expected_values[14] = 32'd0;
        expected_values[15] = 32'd31;
        expected_values[16] = 32'd1;
        expected_values[17] = 32'd32;
        expected_values[18] = 32'd1;
        expected_values[19] = 32'd2147483648;
        expected_values[20] = 32'd1;
        expected_values[21] = 32'd2882396160;
        expected_values[22] = 32'd2882396192;
        expected_values[23] = 32'd76;
        expected_values[24] = 32'd0;
        expected_values[25] = 32'd8192;
        expected_values[26] = 32'd2147483661;
        expected_values[27] = 32'd2147483649;
        expected_values[28] = 32'd0;
        expected_values[29] = 32'd0;
        expected_values[30] = 32'd0;
        expected_values[31] = 32'd0;
        expected_values[32] = 32'd0;
        expected_values[33] = 32'd0;
        expected_values[34] = 32'd0;
        expected_values[35] = 32'd0;
        expected_values[36] = 32'd0;
        expected_values[37] = 32'd0;
        expected_values[38] = 32'd0;

        // Reset the processor
        reset = 1;
        #40;
        reset = 0;

        // Load instructions into the processor
        for ( int i = 0; i < 39; i = i + 1) begin
            instr = mem[i];
            #40; // Wait for the instruction to be processed
        end

        // Compare ALU results with expected values
        for ( int i = 0; i < 39; i = i + 1) begin
            if (alu_result !== expected_values[i]) begin
                $display("ALU result mismatch at instruction %0d. Expected: %h, Actual: %h", i, expected_values[i], alu_result);
            end
            #40; // Wait for the next instruction to be processed
        end

        $display("Simulation finished.");
        $finish;
    end
endmodule
