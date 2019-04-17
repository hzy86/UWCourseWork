/* top level program that interfaces on-board control to design components
 * input: Switches (SW)
 *          SW[9] - write enable
 *					SW[3:0] - input data for the RAM
 *					SW[8:4] - input data address
 * output: HEX displays (HEX)
 * 					HEX[5:4] - address value
 *					HEX[2] - input data
 *					HEX[0] - data at the address
 * calling modules:
 *          ram - the 32 x 4 RAM
 *						- input: address, clk, din (input data), we(write enable)
 *						- output: dout (data at the address)
 *          display - display the data on the HEXes
 *            - input: din (data to display)
 *            - output: HEX (a 7-bit HEX control)
 */
module top(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  logic [9:0] SW;
	input  logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	logic [4:0] addr;
	logic [3:0] din, dout;
	logic clk;
	assign addr = SW[8:4];
	assign din = SW[3:0];
	assign clk = ~KEY[0];
	assign we = SW[9];
	assign HEX1 = 7'b1111111;
	assign HEX3 = 7'b1111111;

	RAM ram (.addr, .clk, .din, .we, .dout);
	display daddr1 (.din(addr / 10), .HEX(HEX5));
	display daddr2 (.din(addr % 10), .HEX(HEX4));
	display displayDin (.din(din), .HEX(HEX2));
	display displayDout (.din(dout), .HEX(HEX0));
endmodule

`timescale 1ps/1ps
/* test bencht that iterate over all 32 addresses and set their value equal to their addresses % 15,
 * make clk low for 5 cycles before becoming high to verify that wrie enable works correctly
 * expect to see HEX0 change only when clicking KEY[0]
 */
module top_testbench();
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	top dut (.SW, .KEY, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	initial begin
		integer i;
		KEY[0] = 1;
		SW[9] = 1;

		for (int i = 0; i < 32; i++) begin
			SW[8:4] = i; SW[3:0] = i;
			KEY[0] = 1; #5;
			KEY[0] = 0; #5;
		end
		$stop;
	end
endmodule
