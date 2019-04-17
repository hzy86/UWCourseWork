/* top level program that interfaces on-board control to design components
 * input: Switches (SW)
 *          SW[9] - write enable
 *					SW[3:0] - write data for the RAM
 *					SW[8:4] - write data data address
 * output: HEX displays (HEX)
 * 					HEX[5:4] - write address value
 *					HEX[3:2] - read address value
 *					HEX[1] - write data
 *					HEX[0] - data at the address
 * calling modules:
 *          ram - the dual-port 32 x 4 RAM
 *						- input: clk, data (write data), rdaddress(read address), wraddress(write address)
                       ,wren(write enable)
 *            - output: q(read data)
 *          counter - increment the read address by 1 from 0 to 31
 *            - input: clk, reset
 *            - output: count(read address)
 *          display - display the data on the HEXes
 *            - input: din (data to display)
 *            - output: HEX (a 7-bit HEX control)
 */
module top(CLOCK_50, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  logic [9:0] SW;
	input  logic [3:0] KEY;
	input  logic CLOCK_50;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	logic we, reset;
	logic [4:0] r_s, w_s;
	logic [3:0] w_d, r_d;
	logic [31:0] divided;

	assign w_s = SW[8:4];
	assign w_d = SW[3:0];
	assign we = SW[9];
	assign reset = ~KEY[0];

	// generate 1Hz clock from a 50MHz clock
	logic clk;
	parameter which_clock = 25;
	clock_divider div (.reset(~KEY[1]), .clock(CLOCK_50), .divided_clocks(divided));
	assign clk = divided[which_clock];

	// uncomment this and comment the line below to simulate
	// counter c (.clk(CLOCK_50), .reset, .count(r_s));
	counter c (.clk, .reset, .count(r_s));

	// read and write to the RAM
	// uncomment this cand comment the line below to simulate
	// ram32x4 ram (.clock(CLOCK_50), .data(w_d), .rdaddress(r_s), .wraddress(w_s), .wren(we), .q(r_d));
	ram32x4 ram (.clock(clk), .data(w_d), .rdaddress(r_s), .wraddress(w_s), .wren(we), .q(r_d));

	// display read addresses
	display r_s1 (.din(r_s / 10), .HEX(HEX3));
	display r_s2 (.din(r_s % 10), .HEX(HEX2));

	// display write address and write data
	display w_s1 (.din(w_s / 10), .HEX(HEX5));
	display w_s2 (.din(w_s % 10), .HEX(HEX4));
	display wdis (.din(w_d), .HEX(HEX1));

	// display RAM data
	display rdis (.din(r_d), .HEX(HEX0));
endmodule

// clock divider to generate slower clock
module clock_divider (reset, clock, divided_clocks);
  input  logic clock, reset;
  output logic [31:0] divided_clocks;

  always_ff @(posedge clock) begin
    if (reset) begin
      divided_clocks <= 0;
    end else begin
      divided_clocks <= divided_clocks + 1;
    end
  end
endmodule

`timescale 1ps/1ps
module top_testbench();
	logic CLOCK_50;
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	top dut (.CLOCK_50, .SW, .KEY, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);

	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end

	initial begin
		integer i;
		// -------- test case 1 - read initialized RAM with counter --------
		SW[9] <= 0; KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; 						 @(posedge CLOCK_50);
		repeat(32)  						 @(posedge CLOCK_50);
		KEY[0] <= 0; 						 @(posedge CLOCK_50);
		KEY[0] <= 1; 						 @(posedge CLOCK_50);
		repeat(40)  						 @(posedge CLOCK_50);
		// -------- test case 2 - write to the RAM under enable --------
		SW[9] <= 1;												 @(posedge CLOCK_50);
   	for (int i = 0; i < 32; i++) begin
			SW[8:4] <= i; SW[3:0] <= 14 - i; @(posedge CLOCK_50);
			repeat(5)												 @(posedge CLOCK_50);
		end
		// -------- test case 3 - read to verify the writes are successful --------
		SW[9] <= 0; KEY[0] <= 0; 									@(posedge CLOCK_50);
		KEY[0] <= 1; SW[8:4] <= 31; SW[3:0] <= 1'ha;	@(posedge CLOCK_50);
		repeat(40)  															@(posedge CLOCK_50);
		$stop;
	end
endmodule
