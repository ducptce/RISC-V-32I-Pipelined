`timescale 1ns/1ps
module riscv_test_top();
    bit clk;
	top dut(.clk(top_io.clk), 
	        .reset(top_io.reset), 
	        .inst(top_io.inst), 
	        .DataW(top_io.DataW), 
	        .Addr(top_io.Addr), 
	        .MemRW(top_io.MemRW));
	riscv_io top_io(clk);
	test RiscV_test(top_io);
	
	initial
		begin
			clk <= 1; 
			forever begin
			 # 10 clk = ~clk;
			end
		end
		 
	

endmodule

