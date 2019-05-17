/* 24-bit input D-flip-flop
 * @input [1] clk - clock
 * @input [1] reset - reset signal
 * @input [24] d - input
 * @output [24] q - output
 */
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
