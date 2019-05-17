/* an 8-tap averaging FIR filter
 * @input [1] clk - clock
 * @input [24] in - a sample
 * @output [24] out - the average of this sample and 7 earlier samples
 */
module filter (clock, in, out);
	input logic clock;
	input logic signed[23:0] in;
	output logic signed[23:0] out;

	logic signed[23:0] fir[0:7];
	logic signed[23:0] cur;

	always_comb begin
		cur = 0;
		fir[0] = in;
		for(int i = 0; i < 8; i++)
			cur = cur + (fir[i] >>> 3);
	end

	generate
		genvar k;
		for (k = 0; k < 7; k++) begin: dff24
			D_FF dff24(.clk(clock), .reset(1'b0), .d(fir[k]), .q(fir[k+1]));
		end
	endgenerate

	assign out = cur;
endmodule

// test the results against some known values, including negative and positive
module filter_tb();
	logic clock;
	logic signed[23:0] in, out;

	logic signed[23:0] test;
	assign test = in >>> 3;

	filter dut (clock, in, out);
	// set up the clock
   parameter CLOCK_PERIOD = 100;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD / 2) clock <= ~clock;
	end

	initial begin
		in = 0;				@(posedge clock);
		// test from 0 to 50
		for (int i=0; i<10; i++) begin
			in = in + 1; 	@(posedge clock);
		end
		// some random values
		in = in + 10;		@(posedge clock);
		in = in + 20;		@(posedge clock);
		in = in + 30;		@(posedge clock);
		in = in + 140;		@(posedge clock);
		in = in + 50;		@(posedge clock);
		in = in + 150;		@(posedge clock);
								@(posedge clock);
		// negative values
		in = -20;			@(posedge clock);
		in = -10;			@(posedge clock);
		$stop;
	end
endmodule
