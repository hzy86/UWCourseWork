module filter #(parameter FILTER_WIDTH = 3) (clock, in, out);
	
	input logic clock;
	input logic signed[23:0] in;
	output logic signed[23:0] out;
	
	logic signed[23:0] fir[0:2**FILTER_WIDTH - 1];
	logic signed[23:0] cur;
	
	always_comb begin
		fir[0] = in;
	end
	
	generate
		genvar k;
		for (k = 0; k < 2**FILTER_WIDTH - 1; k++) begin: dff24
			D_FF dff24(.clk(clock), .reset(1'b0), .d(fir[k]), .q(fir[k+1]));
		end
	endgenerate
	
	assign out = fir[2**FILTER_WIDTH - 1];
endmodule

module filter_tb();
	// last 2**N samples
	parameter N = 3;
	logic clock;
	logic signed[23:0] in, out;
	
	logic signed[23:0] test;
	assign test = in >>> N;
	
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
		in = in + 10;		@(posedge clock);
		in = in + 20;		@(posedge clock);
		in = in + 30;		@(posedge clock);
		in = in + 140;		@(posedge clock);
		in = in + 50;		@(posedge clock);
		in = in + 150;		@(posedge clock);
								@(posedge clock);
		$stop;
	end
endmodule
