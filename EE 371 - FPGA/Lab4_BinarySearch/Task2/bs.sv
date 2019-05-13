/* Binary search algorithm
 * @param data_width - how many bits in a word
 * @param addr_width - the number of bits needed to represent the RAM's depth
 * @input [1] clk - clock
 * @input [1] reset - reset the ASM
 * @input [1] start - start searching
 * @input [data_width] A - the target number
 * @output [1] found - if the A is stored in the RAM
 * @output [addr_width] result_addr - the RAM location of the target number A
 * @calling module RAM - the RAM
 *    @input [1] clk - clock
 *    @input [1] wr_en - 0 (disable)
 *    @input [data_width] w_d - A
 *    @input [addr_width] addr - mid
 *    @output [data_width] data - mid_val
 * calling module bs_control - the binary search control logic
 *    @input internal registers
 *    @output internal registers
 * calling module bs_data - the binary search datapath
 *    @input internal registers
 *    @output internal registers
 */
module bs
#(parameter data_width=8, addr_width=5)
(
  input logic clk, reset, start,
  input logic [data_width-1:0] A,
  output logic found,
  output logic [addr_width-1:0] result_addr
);
	logic [addr_width-1:0] high, low, mid;
	logic [data_width-1:0] mid_val;
	logic mid_val_eqA, low_ge_high;
	logic mid_new, low_new, high_new, data_in, mid_val_lA;

	RAM ram (.clk, .wr_en(1'b0), .w_d(A), .addr(mid), .data(mid_val));
	bs_control bsc(.clk, .reset, .start, .mid_val_eqA, .low_ge_high, .mid_val_lA, .found, .mid_new, .low_new, .high_new, .data_in);
	bs_data bsd(.clk, .reset, .start, .A, .mid_val, .mid_new, .low_new, .high_new, .data_in, .found, .mid_val_eqA, .low_ge_high, .mid_val_lA, .result_addr, .mid);
endmodule
