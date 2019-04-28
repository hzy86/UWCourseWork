/* Bresenham's drawing algorithm in System Verilog
 * input:
 *        clk (clock)
 *				reset	(hardware reset)
 * 				[11 bits] x0 (start point x coordinate), y0 (start point y coordinate)
 * 				[11 bits] x1 (end point x coordinate), y1 (end point y coordinate)
 * output:
 *        [11 bits] xout (x coordinate of current pixel)
 *        [11 bits] yout (y coordinate of current pixel)
 */
module line_drawer(
	input logic clk, reset,
	input logic [10:0]	x0, y0, x1, y1, //the end points of the line
	output logic [10:0]	xout, yout 						//outputs corresponding to the pair (x, y)
	);

	logic signed [11:0] error, error_next;
	logic is_steep;
	logic [10:0] x_0, y_0, x_1, y_1, tmpx, tmpy, x, y;

	assign is_steep = abs(y1-y0) > abs(x1-x0);
  // do the swapping
  always_comb begin
    x_0 = x0; y_0 = y0; x_1 = x1; y_1 = y1;
    if(is_steep) begin
      x_0 = y0; y_0 = x0; x_1 = y1; y_1 = x1;
    end
    tmpx = x_0; tmpy = y_0;
    if (x_0 > x_1) begin
      x_0 = x_1; x_1 = tmpx;
      y_0 = y_1; y_1 = tmpy;
    end
  end

	// prepare the variables for counting x and y
	logic [11:0] deltax, deltay, y_step;
	assign deltax = x_1 - x_0;
	assign deltay = abs(y_1 - y_0);
	assign y_step = (y_0 < y_1)?1:-1;
	assign error_next = error + deltay;

  // count the x and y
  always_ff @(posedge clk) begin
    if (reset) begin
      x <= x_0;
      y <= y_0;
      error <= -(deltax) / 2;
    end else if (x < x_1) begin
      x <= x + 1;
      if (error_next >= 0) begin
        y <= y + y_step;
        error <= error_next - deltax;
      end else begin
        error <= error_next;
      end
    end
  end

  // reverse x and y if necessary
  always_comb begin
    if (is_steep) begin
      xout = y;
      yout = x;
    end else begin
      xout = x;
      yout = y;
    end
  end

  function automatic [10:0] abs;
    input [10:0] num;
    abs = (num[10])? ~num+1:num;
  endfunction
endmodule

// test drawing lines with different steepness
module line_drawer_testbench();
	logic clk, reset;
	logic [10:0]	x0, y0, x1, y1;//the end points of the line
	logic [10:0]	xout, yout;

	line_drawer dut (.clk, .reset, .x0, .y0, .x1, .y1, .xout, .yout);

	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk;
	end

	initial begin
		// ------------------ test case 1 - draw from (0, 0) to (240, 240) (diagonal) ---------------------
		// reset <= 1; x0 <= 11'b0; y0 <= 11'b0; x1 <= 240; y1 <= 240; @(posedge clk);
		// 																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
		// ------------------ test case 2 - draw from (120, 0) to (120, 240) (vertical) ---------------------
		// reset <= 1; x0 <= 120; y0 <= 0; x1 <= 120; y1 <= 240; @(posedge clk);
		//																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
		// ------------------ test case 3 - draw from (0, 0) to (120, 240) (steep) ---------------------
		// reset <= 1; x0 <= 0; y0 <= 0; x1 <= 120; y1 <= 240; @(posedge clk);
		//																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 4 - draw from (240, 240) to (0, 0) (x0 < x1) ---------------------
		// reset <= 1; x1 <= 0; y1 <= 0; x0 <= 240; y0 <= 240; @(posedge clk);
		// 																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 5 - draw from (120, 240) to (120, 0) (vertical backwards) ---------------------
		// reset <= 1; x0 <= 120; y0 <= 240; x1 <= 120; y1 <= 0; @(posedge clk);
		// 																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 6 - draw from (0, 120) to (240, 120) (horizontal) ---------------------
		// reset <= 1; x0 <= 0; y0 <= 120; x1 <= 240; y1 <= 120; @(posedge clk);
		// 																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 7 - draw from (120, 120) to (200, 200) (arbitrary diagonal) ---------------------
		// reset <= 1; x0 <= 120; y0 <= 120; x1 <= 200; y1 <= 200; @(posedge clk);
		//  																														@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 8 - draw point (120, 120) (arbitrary point) ---------------------
		// reset <= 0; x0 <= 120; y0 <= 120; x1 <= 120; y1 <= 120; @(posedge clk);
    // @(posedge clk);
    // @(posedge clk);
		// reset <= 1;																							@(posedge clk);
		// reset <= 0; @(posedge clk);
		// repeat(240)	@(posedge clk);
    // ------------------ test case 9 - draw (120, 120) to (200, 150) (not steep) ---------------------
		reset <= 0; x0 <= 120; y0 <= 120; x1 <= 200; y1 <= 150; @(posedge clk);
    @(posedge clk);
    @(posedge clk);
		reset <= 1;																							@(posedge clk);
		reset <= 0; @(posedge clk);
		repeat(240)	@(posedge clk);
		$stop;
	end
endmodule
