/* Binary search control logic
 * @param data_width - how many bits in a word
 * @param addr_width - the number of bits needed to represent the RAM's depth
 * @input [1] clk - clock
 * @input [1] reset - reset the ASM
 * @input [1] start - start searching
 * @input [1] mid_val_eqA - if RAM[mid] == target number A
 * @input [1] low_ge_high - if low < high
 * @input [1] mid_val_lA - if RAM[mid] < target number A
 * @output [1] found - if the RAM contains the target number
 * @output [1] mid_new - middle index should be updated
 * @output [1] low_new - lower index should be updated
 * @output [1] high_new - higher index should be updated
 * @output [1] data_in - if A should be loaded
 */
module bs_control
#(parameter data_width=8, addr_width=5)
(
  input logic clk, reset, start,
  input logic mid_val_eqA, low_ge_high, mid_val_lA,
  output logic found, mid_new, low_new, high_new, data_in
);

	enum{s1, s2, s3, s4, s5}ps, ns;
	// controls states
	always_comb begin
		case (ps)
			s1: begin
					if (start)
					  ns = s2;
					else
					  ns = s1;
				 end
			s2: begin
					ns = s5;
				 end
			s5: begin
					ns = s3;
				 end
			s3: begin
					if (mid_val_eqA)
					  ns = s4;
					else if (low_ge_high)
					  ns = s4;
					else
					  ns = s2;
				 end
			s4: begin
					if (start)
					  ns = s4;
					else
					  ns = s1;
				 end
			default: ns = s1;
		endcase
	end

	always_comb begin
		mid_new = 0;
		found = 0;
		low_new = 0;
		high_new = 0;
		data_in = 0;
		case (ps)
			s1: begin
					if (start)
						data_in = 1;
				 end
			s2: begin
					mid_new = 1;
				 end
			s3: begin
					if (mid_val_eqA) begin
					  found = 1;
					end else if (~low_ge_high) begin
					  if (mid_val_lA)  low_new = 1;
					  else             high_new = 1;
					end
				 end
			s4: begin
					if (mid_val_eqA) found = 1;
				 end
		endcase
	end

	always_ff @(posedge clk) begin
		if (reset)
			ps <= s1;
		else
			ps <= ns;
	end
endmodule
