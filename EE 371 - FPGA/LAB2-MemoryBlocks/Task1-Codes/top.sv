/* top level program that interfaces on-board control to design components
 * input: addr (address for writing)
 *				din (data to write)
 *				clk (clock)
 * 				we	(write enable)
 * output: dout (data at the address)
 * calling modules:
 *          ram - the 32 x 4 RAM
 *						- input: address, clk, din (input data), we(write enable)
 *						- output: dout (data at the address)
 */
module top(addr, din, we, clk, dout);
	input  logic [4:0] addr;
	input  logic [3:0] din;
	input  logic we, clk;
	output logic [3:0] dout;

	ram32x4 ram (.address(addr), .clock(clk), .data(din),	.wren(we), .q(dout));
endmodule

`timescale 1ps/1ps
module top_testbench();
	logic [4:0] addr;
	logic [3:0] din, dout;
	logic we, clk;

	top dut (.addr, .din, .we, .clk, .dout);

	parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

	initial begin
		integer i;
		we <= 1; 						 @(posedge clk);
		for (i = 0; i < 32; i++) begin
			addr = i; din = i; @(posedge clk);
		end
		$stop;
	end
endmodule
