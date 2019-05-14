module regne
#(parameter n = 8)
(
	input logic [n-1:0] R,
	input logic clock, resetn, E,
	output logic [n-1:0] Q
);

	always_ff @(posedge clock or negedge resetn) begin
		if (resetn == 0)
			Q <= 0;
		else if (E)
			Q <= R;
	end

endmodule
