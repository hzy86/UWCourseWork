/* counter that keeps track of the current number of cars
 * input:  clk, reset, io[1:0]
 *           io[1] - enter
 *           io[0] - exit
 * output: count - the number of cars
 */
module counter(clk, reset, count, io);
  input  logic clk, reset;
  input [1:0] io;
  output	logic [5:0] count;

  // parse io[1:0] to be enter & exit for readability
  logic enter, exit;
  assign enter = io[1];
  assign exit = io[0];

  // DFF for counter increment
  always_ff @(posedge clk) begin
	if (reset) begin
		count <= 6'b0;
	end
	else if (enter && count < 25) begin
		  count <= count + 1;
	 end
	 else if (exit && count > 0) begin
		  count <= count - 1;
	 end
  end
endmodule

module counter_testbench();
  logic clk, reset;
  logic [1:0] io;
  logic [5:0] count;

  counter dut (.clk, .reset, .io, .count );
  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1;             @(posedge clk);
    reset <= 0; count <=0;  @(posedge clk);
    io <= 2'b10;		        @(posedge clk);
    repeat(29)              @(posedge clk);
    io <= 2'b01;			      @(posedge clk);
    repeat(30)              @(posedge clk);
    $stop;                  @(posedge clk);
  end
endmodule
