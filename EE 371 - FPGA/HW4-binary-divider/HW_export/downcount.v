module downcount
#(parameter n = 8)
(
	input logic [n-1:0] R,
	input logic clock, L, E,
	output logic [n-1:0] Q;
);

	always_ff @(posedge clock) begin
		if (L)
			Q <= R;
		else if (E)
			Q <= Q - 1;
	end

endmodule
