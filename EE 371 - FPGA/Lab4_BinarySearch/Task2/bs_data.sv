/* Binary search datapath
 * @param data_width - how many bits in a word
 * @param addr_width - the number of bits needed to represent the RAM's depth
 * @input [1] clk - clock
 * @input [1] reset - reset the ASM
 * @input [1] start - start searching
 * @input [1] found - if the RAM contains the target number
 * @input [1] mid_new - middle index should be updated
 * @input [1] low_new - lower index should be updated
 * @input [1] high_new - higher index should be updated
 * @input [1] data_in - if A should be loaded
 * @output [1] mid_val_eqA - if RAM[mid] == target number A
 * @output [1] low_ge_high - if low < high
 * @output [1] mid_val_lA - if RAM[mid] < target number A
 * @output [5] result_addr - the RAM location of number A
 * @output [5] mid_val_lA - the middle index
 */
module bs_data
#(parameter data_width=8, addr_width=5)
(
  input logic clk, reset, start,
  input logic [data_width-1:0] A, mid_val,
  input logic mid_new, low_new, high_new, data_in, found,
  output logic mid_val_eqA, low_ge_high, mid_val_lA,
  output logic [addr_width-1:0] result_addr, mid
);

	logic [addr_width-1:0] high, low;
	logic [data_width-1:0] A_reg;

	always_ff @(posedge clk) begin
		if (reset) begin
			result_addr <= 0;
			high <= 0;
			low <= 0;
			A_reg <= 0;
		end else begin
			if (data_in) begin
				A_reg <= A;
				high <= 2**addr_width - 1;
				low <= 0;
				result_addr <= 0;
			end

			if (found)
				result_addr <= mid;

			if (mid_new)
				mid <= (high + low) / 2;
			else if (low_new)
				low <= mid + 1;
			else if (high_new)
				high <= mid - 1;
		end
	end

	assign mid_val_eqA = (mid_val == A_reg);
	assign low_ge_high = (low >= high);
	assign mid_val_lA = (mid_val < A_reg);
endmodule
