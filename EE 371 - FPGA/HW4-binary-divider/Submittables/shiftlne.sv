module shiftlne
#(parameter n = 4)
(
	input logic [n-1:0] R,
	input logic L, E, w, clock,
	output logic[n-1:0] Q
);

	integer k;
	always_ff @(posedge clock) begin
		if (L)
			Q <= R;
		else if (E) begin
			Q[0] <= w;
			for (k = n-1; k > 0; k = k-1) begin
				Q[k] <= Q[k-1];
			end
		end
	end

endmodule
