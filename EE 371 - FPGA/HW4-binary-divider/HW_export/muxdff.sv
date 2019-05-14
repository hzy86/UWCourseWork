module muxdff
(
	input logic D0, D1, Sel, clock,
	output logic Q
);

	always_ff @(posedge clock) begin
	 	if (!Sel)
			Q <= D0;
		else
			Q <= D1;
	end

endmodule
