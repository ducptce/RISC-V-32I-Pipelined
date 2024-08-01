
`timescale 1ns / 1ps

program automatic test(riscv_io.TB rv_io);
    logic [31:0] aluresult;
    int i;
    logic [31:0] mem [31:0]; // reg store instruction
    initial begin
        reset();
        $display("Simulation starts!");
        $monitor("Time: %0t | Value of ALU = %d", $time, rv_io.cb.Addr);    
        gen();
    end
    initial begin
        mem[0]  = 32'h00500113;  // addi x2, x0, 5
        mem[1]  = 32'h00C00193;  // addi x3, x0, 12
        mem[2]  = 32'hFF718393;  // addi x7, x3, -9     x7 = 3
        mem[3]  = 32'h0023E233;  // or x4, x7, x2       x4 = 7
        mem[4]  = 32'h0041C2B3;  // xor x5, x3, x4      x5 - 11
        mem[5]  = 32'h004282B3;  // add x5, x5, x4      x5 = 18
        mem[6]  = 32'h02728863;  // beq x5, x7, 48 (Flushes the next instruction if taken)
        mem[7]  = 32'h0041A233;  // slt x4, x3, x4 (Flushed if branch taken)    x4 = 0
        mem[8]  = 32'h00020463;  // beq x4, x0, 8   
        mem[9]  = 32'h00000293;  // addi x5, x0, 0
        mem[10] = 32'h0023A233;  // slt x4, x7, x2
        mem[11] = 32'h005203B3;  // add x7, x4, x5
        mem[12] = 32'h402383B3;  // sub x7, x7, x2
        mem[13] = 32'h0471AA23;  // sw x7, 84(x3)
        mem[14] = 32'h06002103;  // lw x2, 96(x0)
        mem[15] = 32'h005104B3;  // add x9, x2, x5
        mem[16] = 32'h008001EF;  // jal x3, 8 (Stalls for jump calculation)
        mem[17] = 32'h00100113;  // addi x2, x0, 1 (Flushed if jal not taken)
        mem[18] = 32'h00910133;  // add x2, x2, x9
        mem[19] = 32'h00100213;  // addi x4, x0, 1
        mem[20] = 32'h800002B7;  // lui x5, -524288
        mem[21] = 32'h0042A333;  // slt x6, x5, x4
        mem[22] = 32'h00030063;  // beq x6, x0, 0
        mem[23] = 32'hABCDE4B7;  // lui x9, -344866
        mem[24] = 32'h00910133;  // add x2, x2, x9
        mem[25] = 32'h0421A023;  // sw x2, 64(x3)
        mem[26] = 32'h00210063;  // beq x2, x2, 0
        mem[27] = 32'h00628533;  // add x10, x5, x6
        mem[28] = 32'h00629633;  // sub x12, x5, x6
        mem[29] = 32'h007316B3;  // or x13, x6, x7
        mem[30] = 32'h00728733;  // and x14, x5, x7
        mem[31] = 32'h00128293;  // slli x5, x5, 1
        mem[32] = 32'h00129313;  // srli x6, x5, 1
        mem[33] = 32'h4012A333;  // srai x6, x5, 1
        mem[34] = 32'h00028293;  // addi x5, x5, 0
        mem[35] = 32'h00A002B7;  // lui x5, 0xA0000
        mem[36] = 32'h00A00337;  // lui x6, 0xA0000
        mem[37] = 32'hFE528EE3;  // bne x5, x2, -24 (Flushes the next instruction if taken)
        mem[38] = 32'h00008067;  // ret
    end
    task reset();
       rv_io.cb.inst <= 32'h00000000; 
       rv_io.reset <= 1; 
       #20;  
       rv_io.reset <= 0;
    endtask: reset
    task gen();
       for (i = 0; i < 39; i = i + 1) begin
           #20;
           rv_io.cb.inst <= mem[i];    
       end 
       #200;
       $finish;  
    endtask: gen
endprogram

//-----------------------------------------------------------------------------------------------------
/*
`timescale 1ns / 1ps

program automatic test(riscv_io.TB rv_io);
    logic [31:0] aluresult;
    int i;
    logic [31:0] mem [31:0]; // reg store instuction
    int count_error=0;
    initial begin
        reset();
        $display("Simulation starts!");
       // $monitor("Time: %0t | Value of ALU = %d", $time, rv_io.cb.Addr);    
       fork
        gen();
        check();
        join
    end
    initial begin
        mem[0]  = 32'h00500113;  // addi x2, x0, 5
        mem[1]  = 32'h00C00193;  // addi x3, x0, 12
        mem[2]  = 32'hFF718393;  // addi x7, x3, -9
        mem[3]  = 32'h0023E233;  // or x4, x7, x2
        mem[4]  = 32'h0041C2B3;  // xor x5, x3, x4
        mem[5]  = 32'h004282B3;  // add x5, x5, x4
        mem[6]  = 32'h02728863;  // beq x5, x7, 48 (Flushes the next instuction if taken)
        mem[7]  = 32'h0041A233;  // slt x4, x3, x4 (Flushed if branch taken)
        mem[8]  = 32'h00020463;  // beq x4, x0, 8
        mem[9]  = 32'h00000293;  // addi x5, x0, 0
        mem[10] = 32'h0023A233;  // slt x4, x7, x2
        mem[11] = 32'h005203B3;  // add x7, x4, x5
        mem[12] = 32'h402383B3;  // sub x7, x7, x2
        mem[13] = 32'h0471AA23;  // sw x7, 84(x3)
        mem[14] = 32'h06002103;  // lw x2, 96(x0)
        mem[15] = 32'h005104B3;  // add x9, x2, x5
        mem[16] = 32'h008001EF;  // jal x3, 8 (Stalls for jump calculation)
        mem[17] = 32'h00100113;  // addi x2, x0, 1 (Flushed if jal not taken)
        mem[18] = 32'h00910133;  // add x2, x2, x9
        mem[19] = 32'h00100213;  // addi x4, x0, 1
        mem[20] = 32'h800002B7;  // lui x5, -524288
        mem[21] = 32'h0042A333;  // slt x6, x5, x4
        mem[22] = 32'h00030063;  // beq x6, x0, 0
        mem[23] = 32'hABCDE4B7;  // lui x9, -344866
        mem[24] = 32'h00910133;  // add x2, x2, x9
        mem[25] = 32'h0421A023;  // sw x2, 64(x3)
        mem[26] = 32'h00210063;  // beq x2, x2, 0
        mem[27] = 32'h00628533;  // add x10, x5, x6
        mem[28] = 32'h00629633;  // sub x12, x5, x6
        mem[29] = 32'h007316B3;  // or x13, x6, x7
        mem[30] = 32'h00728733;  // and x14, x5, x7
        mem[31] = 32'h00128293;  // slli x5, x5, 1
        mem[32] = 32'h00129313;  // srli x6, x5, 1
        mem[33] = 32'h4012A333;  // srai x6, x5, 1
        mem[34] = 32'h00028293;  // addi x5, x5, 0
        mem[35] = 32'h00A002B7;  // lui x5, 0xA0000
        mem[36] = 32'h00A00337;  // lui x6, 0xA0000
        mem[37] = 32'hFE528EE3;  // bne x5, x2, -24 (Flushes the next instuction if taken)
        mem[38] = 32'h00008067;  // ret
    end
    task reset();
       rv_io.cb.inst <= 32'h00000000; 
       rv_io.reset <= 1; 
       #20;  
       rv_io.reset <= 0;
    endtask: reset
    task gen();
       for (i = 0; i < 39; i = i + 1) begin
           #20;
           rv_io.cb.inst <= mem[i];    
       end 
       #200;
//       $finish;  
    endtask: gen
   task check();
    int expected_results[39];
    expected_results[0]  = 5;   // addi x2, x0, 5
    expected_results[1]  = 12;  // addi x3, x0, 12
    expected_results[2]  = 12 - 9; // addi x7, x3, -9
    expected_results[3]  = 12 | 5; // or x4, x7, x2
    expected_results[4]  = 12 ^ 12; // xor x5, x3, x4
    expected_results[5]  = 12 + 12; // add x5, x5, x4
    expected_results[6]  = 12 + 12 + 0; // add x5, x5, x4 (branch not taken)
    expected_results[7]  = 12 < 12; // slt x4, x3, x4 (branch not taken)
    expected_results[8]  = 12 == 0; // beq x4, x0, 8 (branch not taken)
    expected_results[9]  = 0;   // addi x5, x0, 0
    expected_results[10] = 12 < 5; // slt x4, x7, x2 (branch not taken)
    expected_results[11] = 12 + 12; // add x7, x4, x5
    expected_results[12] = 12 - 5; // sub x7, x7, x2
    expected_results[13] = 0;   // sw x7, 84(x3)
    expected_results[14] = 96;  // lw x2, 96(x0)
    expected_results[15] = 96 + 0; // add x9, x2, x5
    expected_results[16] = 96;  // jal x3, 8 (Stalls for jump calculation)
    expected_results[17] = 96 + 1; // addi x2, x0, 1 (Flushed if jal not taken)
    expected_results[18] = 96 + 96; // add x2, x2, x9
    expected_results[19] = 96 + 1; // addi x4, x0, 1
    expected_results[20] = -524288; // lui x5, -524288
    expected_results[21] = -524288 < 12; // slt x6, x5, x4 (branch not taken)
    expected_results[22] = -524288 == 0; // beq x6, x0, 0 (branch not taken)
    expected_results[23] = -344866; // lui x9, -344866
    expected_results[24] = -524288 - 524288; // add x2, x2, x9
    expected_results[25] = -524288; // sw x2, 64(x3)
    expected_results[26] = -524288 == -524288; // beq x2, x2, 0 (branch not taken)
    expected_results[27] = -524288 + -524288; // add x10, x5, x6
    expected_results[28] = -524288 - -524288; // sub x12, x5, x6
    expected_results[29] = (-524288 - -524288) | (-524288 - -524288); // or x13, x6, x7
    expected_results[30] = (-524288 - -524288) & -524288; // and x14, x5, x7
    expected_results[31] = (-524288 - -524288) << 1; // slli x5, x5, 1
    expected_results[32] = ((-524288 - -524288) << 1) >> 1; // srli x6, x5, 1
    expected_results[33] = ((-524288 - -524288) << 1) >>> 1; // srai x6, x5, 1
    expected_results[34] = ((-524288 - -524288) << 1) >>> 1 + 0; // addi x5, x5, 0
    expected_results[35] = -1048576; // lui x5, 0xA0000
    expected_results[36] = -1048576; // lui x6, 0xA0000
    expected_results[37] = -1048576 != 96; // bne x5, x2, -24 (branch not taken)
    expected_results[38] = -1048576 + 0; // ret

    // Compare the expected result with the actual result
    #120;
    for (i = 0; i < 39; i++) begin
        if (rv_io.cb.Addr != expected_results[i]) begin
            $display("ERROR: Expected ALU result = %d, Actual ALU result = %d at instuction %d", expected_results[i], rv_io.cb.Addr, i);
            count_error=count_error+1;
        end
        #20;
    end
    if(count_error == 0) begin
    $display("ALU results check completed successfully!");
    end
    else;
endtask: check


endprogram
*/
//-------------------------------------------------------------------------------------------------
/*
`timescale 1ns / 1ps

program automatic test(riscv_io.TB rv_io);
    logic [31:0] aluresult;
    int i;
    //int delay = 0;
    logic [31:0] mem [31:0]; // reg store instuction
    int count_error=0;
    initial begin
        reset();
        $display("Simulation starts!");
       // $monitor("Time: %0t | Value of ALU = %d", $time, rv_io.cb.Addr);    
       fork
        gen();
        check();
        join
    end
    initial begin
        mem[0]  = 32'h00500113;  // addi x2, x0, 5
        mem[1]  = 32'h00C00193;  // addi x3, x0, 12
        mem[2]  = 32'hFF718393;  // addi x7, x3, -9
        mem[3]  = 32'h0023E233;  // or x4, x7, x2
        mem[4]  = 32'h0041C2B3;  // xor x5, x3, x4
        mem[5]  = 32'h004282B3;  // add x5, x5, x4
        mem[6]  = 32'h02728863;  // beq x5, x7, 48 (Flushes the next instuction if taken)
        mem[7]  = 32'h0041A233;  // slt x4, x3, x4 (Flushed if branch taken)
        mem[8]  = 32'h00020463;  // beq x4, x0, 8
        mem[9]  = 32'h00000293;  // addi x5, x0, 0
        mem[10] = 32'h0023A233;  // slt x4, x7, x2
        mem[11] = 32'h005203B3;  // add x7, x4, x5
        mem[12] = 32'h402383B3;  // sub x7, x7, x2
        mem[13] = 32'h0471AA23;  // sw x7, 84(x3)
        mem[14] = 32'h06002103;  // lw x2, 96(x0)
        mem[15] = 32'h005104B3;  // add x9, x2, x5
        mem[16] = 32'h008001EF;  // jal x3, 8 (Stalls for jump calculation)
        mem[17] = 32'h00100113;  // addi x2, x0, 1 (Flushed if jal not taken)
        mem[18] = 32'h00910133;  // add x2, x2, x9
        mem[19] = 32'h00100213;  // addi x4, x0, 1
        mem[20] = 32'h800002B7;  // lui x5, -524288
        mem[21] = 32'h0042A333;  // slt x6, x5, x4
        mem[22] = 32'h00030063;  // beq x6, x0, 0
        mem[23] = 32'hABCDE4B7;  // lui x9, -344866
        mem[24] = 32'h00910133;  // add x2, x2, x9
        mem[25] = 32'h0421A023;  // sw x2, 64(x3)
        mem[26] = 32'h00210063;  // beq x2, x2, 0
        mem[27] = 32'h00628533;  // add x10, x5, x6
        mem[28] = 32'h00629633;  // sub x12, x5, x6
        mem[29] = 32'h007316B3;  // or x13, x6, x7
        mem[30] = 32'h00728733;  // and x14, x5, x7
        mem[31] = 32'h00128293;  // slli x5, x5, 1
        mem[32] = 32'h00129313;  // srli x6, x5, 1
        mem[33] = 32'h4012A333;  // srai x6, x5, 1
        mem[34] = 32'h00028293;  // addi x5, x5, 0
        mem[35] = 32'h00A002B7;  // lui x5, 0xA0000
        mem[36] = 32'h00A00337;  // lui x6, 0xA0000
        mem[37] = 32'hFE528EE3;  // bne x5, x2, -24 (Flushes the next instuction if taken)
        mem[38] = 32'h00008067;  // ret
    end
    task reset();
       rv_io.cb.inst <= 32'h00000000; 
       rv_io.reset <= 1; 
       #20; 
       rv_io.reset <= 0;
    endtask: reset
    task gen();
       for (i = 0; i < 39; i = i + 1) begin
           #20;
           //@(posedge rv_io.cb);
           rv_io.cb.inst <= mem[i];    
       end 
       #200;
//       $finish;  
    endtask: gen

task check();
    int expected_results[39];
    // Calculate expected results for each instuction
    expected_results[0]  = 5;   // addi x2, x0, 5
    expected_results[1]  = 12;  // addi x3, x0, 12
    expected_results[2]  = 12 - 9; // addi x7, x3, -9
    expected_results[3]  = 7; // or x4, x7, x2
    expected_results[4]  = 11; // xor x5, x3, x4
    expected_results[5]  = 18;//12 + 12; // add x5, x5, x4
    expected_results[6]  = 12 + (12 + 0); // add x5, x5, x4 (branch not taken)
    expected_results[7]  = (12 < 12) ? 1 : 0; // slt x4, x3, x4 (branch not taken)
    expected_results[8]  = (12 == 0) ? 1 : 0; // beq x4, x0, 8 (branch not taken)
    expected_results[9]  = 0;   // addi x5, x0, 0
    expected_results[10] = (12 < 5) ? 1 : 0; // slt x4, x7, x2 (branch not taken)
    expected_results[11] = 12 + 12; // add x7, x4, x5
    expected_results[12] = 12 - 5; // sub x7, x7, x2
    expected_results[13] = 0;   // sw x7, 84(x3)
    expected_results[14] = 0;  // lw x2, 96(x0) - Not specified in the instuctions, assuming it should be 0
    expected_results[15] = 0 + 0; // add x9, x2, x5 - Assuming x2 is 0 after the lw instuction
    expected_results[16] = 0;  // jal x3, 8 (Stalls for jump calculation)
    expected_results[17] = 0 + 1; // addi x2, x0, 1 (Flushed if jal not taken)
    expected_results[18] = 1 + 0; // add x2, x2, x9 - Assuming x2 is 1 after the addi instuction
    expected_results[19] = 1 + 1; // addi x4, x0, 1
    expected_results[20] = -524288; // lui x5, -524288
    expected_results[21] = (-524288 < 12) ? 1 : 0; // slt x6, x5, x4 (branch not taken)
    expected_results[22] = (-524288 == 0) ? 1 : 0; // beq x6, x0, 0 (branch not taken)
    expected_results[23] = -344866; // lui x9, -344866
    expected_results[24] = -524288 - 524288; // add x2, x2, x9
    expected_results[25] = -524288; // sw x2, 64(x3)
    expected_results[26] = (-524288 == -524288) ? 1 : 0; // beq x2, x2, 0 (branch not taken)
    expected_results[27] = (-524288 + -524288); // add x10, x5, x6
    expected_results[28] = (-524288 - -524288); // sub x12, x5, x6
    expected_results[29] = ((-524288 - -524288) | (-524288 - -524288)); // or x13, x6, x7
    expected_results[30] = ((-524288 - -524288) & -524288); // and x14, x5, x7
    expected_results[31] = ((-524288 - -524288) << 1); // slli x5, x5, 1
    expected_results[32] = (((-524288 - -524288) << 1) >> 1); // srli x6, x5, 1
    expected_results[33] = (((-524288 - -524288) << 1) >>> 1); // srai x6, x5, 1
    expected_results[34] = (((-524288 - -524288) << 1) >>> 1 + 0); // addi x5, x5, 0
    expected_results[35] = -1048576; // lui x5, 0xA0000
    expected_results[36] = -1048576; // lui x6, 0xA0000
    expected_results[37] = (-1048576 != 96) ? 1 : 0; // bne x5, x2, -24 (branch not taken)
    expected_results[38] = (-1048576 + 0); // ret
    //expected_results[39] = "x"; // Added to account for the last instuction

    // Compare the expected result with the actual result
    #100;
    //repeat (5) @(posedge rv_io.cb);
    for (i = 0; i <39; i++) begin
        // Adjust the delay according to the pipeline stages
       // #((i + 1) * 20); // Assuming each instuction takes 20 time units in the pipeline
        //repeat(i+1) @(posedge rv_io.cb);
        #20
        if (rv_io.cb.Addr !== expected_results[i]) begin
            $display("ERROR: Expected ALU result = %d, Actual ALU result = %d at instuction %d", expected_results[i], rv_io.cb.Addr, i);
            count_error = count_error + 1;
        end
    end

    if (count_error == 0) begin
        $display("ALU results check completed successfully!");
    end
endtask

endprogram
*/