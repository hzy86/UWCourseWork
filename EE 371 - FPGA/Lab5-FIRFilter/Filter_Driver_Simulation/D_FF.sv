module D_FF(clk, reset, d, q);
	input logic clk, reset;
	input logic [23:0] d;
	output logic [23:0] q;
	
	always @(posedge clk) begin
		if (reset)
			q <= 0;
		else
			q <= d;
	end
endmodule
