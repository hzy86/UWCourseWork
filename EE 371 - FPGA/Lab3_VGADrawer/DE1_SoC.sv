/* top-level program to drive the VGA to animate a line to move around the screen
 * @author: Ziyi Huang
 * date: 4/26/2019
 * input:
 *				CLOCK_50 - 50MHz clock
 * 				KEY	(no use)
 *				SW[9] - hardware reset - reset the clock and initialize the animation
 *				SW[1] - clear the screen
 *				SW[0] - pixel write enable (normally on)
 * output:
 *       	HEX0-HEX9 (HEXes off), LEDR (switches indicator)
 *				VGA_* - VGA control
 * calling modules
 *				VGA_framebuffer
 *					logic - clk50 (clk), reset (always off), x (x coordinate of current pixel to draw),
 *									y (y coordinate of current pixel to draw), pixel_color (color of the pixel),
 *									pixel_write (draw enable), VGA_* (handle other VGA)
 *				clock_divider
 *					input - reset (reset the 0), clock (CLOCK_50)
 *					output - divided (a 32-bit speed of clock)
 *				animation
 *					input - clk, reset(reset the FSM), white (if the last color is white)
 *									clear (clear screen enable)
 *					output - (x0, y0) (start point), (x1, y1) (end point), color (the next color)
 *				line_drawer
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50,
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);

	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;

	logic [10:0] x0, y0, x1, y1, x, y;
	logic reset, hw_reset, pixel_color, pixel_write, color, white, clear;
	assign reset = ~KEY[0];
	assign hw_reset = SW[9];
	assign pixel_write = SW[0];
	assign clear = SW[1];

	// generate 1Hz clock from a 50MHz clock
	logic clk;
	logic [31:0] divided;
	parameter which_clock = 3;
	clock_divider div (.reset(hw_reset), .clock(CLOCK_50), .divided_clocks(divided));
	assign clk = divided[which_clock];
	assign white = color;

	VGA_framebuffer fb(.clk50(CLOCK_50), .reset(1'b0), .x, .y,
				.pixel_color(color), .pixel_write,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_n(VGA_BLANK_N), .VGA_SYNC_n(VGA_SYNC_N));

	animation ani(.clk, .reset(hw_reset), .x0, .y0, .x1, .y1, .white, .color, .clear);
	line_drawer lines (.clk(CLOCK_50), .reset(clk), .x0, .y0, .x1, .y1, .xout(x), .yout(y));
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

module DE1_SoC_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
 	logic CLOCK_50;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
 	logic VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;

	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .CLOCK_50,
		.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);

	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
	end

	initial begin
		// --------- test the top level with resets ------------------
		SW = 10'b0; SW[0] = 1; SW[9] = 1; KEY = 4'b1; @(posedge CLOCK_50);
		SW[9] = 0;							@(posedge CLOCK_50);
		repeat(60)							@(posedge CLOCK_50);
		SW[0] = 1;							@(posedge CLOCK_50);
		repeat(240) @(posedge CLOCK_50);
		KEY = 4'b0; @(posedge CLOCK_50);
		KEY = 4'b1; @(posedge CLOCK_50);
		repeat(120) @(posedge CLOCK_50);
		SW[9] <= 1;	@(posedge CLOCK_50);
		SW[9] <= 0; @(posedge CLOCK_50);
		repeat(120) @(posedge CLOCK_50);
		SW[1] <= 1;	@(posedge CLOCK_50);
		repeat(120) @(posedge CLOCK_50);
		$stop;
	end
endmodule
