`timescale 1ns / 1ps

module testbench;

	reg reset;			// asynchronous active-high reset

	reg clk_in;			// write clock
	reg we;				// active-high write enable
	reg [7:0] din;		// 8-bit data-in
	wire busy;			// active-high buffer full

	reg clk_out;		// read clock
	reg re;				// active-high read enable
	wire [7:0] dout;	// 8-bit data-out
	wire ready;			// active-high data ready flag

	// Instantiate Unit Under Test (UUT)
	ccd_register uut (
		.reset,
		.clk_in,
		.we,
		.din,
		.busy,
		.clk_out,
		.re,
		.dout,
		.ready
	);

	// clocks

	always begin
		#3 clk_in = 0;
		#3 clk_in = 1;
	end

	always begin
		#13 clk_out = 0;
		#13 clk_out = 1;
	end

	initial begin
		// create files for waveform viewer
		$dumpfile("testbench.lxt");
		$dumpvars;

		// initialize inputs
		reset = 1;
		clk_in = 1;
		we = 0;
		din = 8'hx;
		clk_out = 1;
		re = 0;

		// release reset
		#100 reset = 0;

		// write to register
		#6 din = 8'hA5;
		wait(!clk_in);
		wait(clk_in); #1 we = 1;
		wait(!clk_in);
		wait(clk_in); #1 we = 0;
		#6 din = 8'hx;

		// wait for data ready, then wait a little latency
		wait(ready); #78;
		
		// read from register
		wait(!clk_out);
		wait(clk_out); #1 re = 1;
		wait(!clk_out);
		wait(clk_out); #1 re = 0;

		// wait for not busy
		wait(!busy);

		// Finished
		#100 $display("finished");
		$finish;
	end

endmodule
