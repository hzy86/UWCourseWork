/* Top-level driver for the FPGA to run binary search algorithm
 * @input [1] CLOCK_50 - 50MHz built-in clock
 * @input [4] KEY - keys
 * @input [10] SW - switches
 * @output [10] LEDR - LEDs
 * @output [7]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 - the HEX displays
 * @calling module bs - run the binary search algorithm
 *    @input [1] clk - CLOCK_50
 *    @input [1] reset - ~KEY[0]
 *    @input [1] start - SW[9]
 *    @input [8] A - SW[7:0]
 *    @output [5] result_addr - drive HEX0 and HEX1
 *    @output [1] found - LEDR[9]
 * @calling module seven_seg_display - display the result address in hexadecimal format
 *    @intput [5] result_addr - the location of the result in the RAM
 *    @output [7] HEX1, HEX0 - display on HEX1 and HEX0
 */
module binary_search_driver(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
  input logic CLOCK_50;
  input logic [3:0] KEY;
  input logic [9:0] SW;
  output logic [9:0] LEDR;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;

  logic reset, s, done;
  assign reset = ~KEY[0];
  assign s = SW[9];

  logic [4:0] result_addr;

  bs bs1 (.clk(CLOCK_50), .reset, .start(s), .A(SW[7:0]), .found(LEDR[9]), .result_addr);
  seven_seg_display ssd(.HEX0, .HEX1, .result_addr);

endmodule

module binary_search_driver_testbench();
  logic CLOCK_50;
  logic [3:0] KEY;
  logic [9:0] SW, LEDR;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  binary_search_driver dut (.*);

  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    CLOCK_50 <= 0;
    forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
  end

  initial begin
    KEY[0] <= 0; @(posedge CLOCK_50);
    KEY[0] <= 1; @(posedge CLOCK_50);
    // --------------- test case 1 - existing value in the middle ---------------
    SW[9] <= 0;                     @(posedge CLOCK_50);
    SW[9] <= 1; SW[7:0] <= 8'h10;   @(posedge CLOCK_50);
    repeat(20)                      @(posedge CLOCK_50);
    // --------------- test case 2 - existing value at the front ---------------
    SW[9] <= 0;                     @(posedge CLOCK_50);
    SW[9] <= 1; SW[7:0] <= 8'h00;   @(posedge CLOCK_50);
    repeat(20)                      @(posedge CLOCK_50);
    // --------------- test case 3 - existing value at the back ---------------
    SW[9] <= 0;                     @(posedge CLOCK_50);
    SW[9] <= 1; SW[7:0] <= 8'h1f;   @(posedge CLOCK_50);
    repeat(20)                      @(posedge CLOCK_50);
    // --------------- test case 4 - non-existing value in the middle ---------------
    SW[9] <= 0;                     @(posedge CLOCK_50);
    SW[9] <= 1; SW[7:0] <= 8'h12;   @(posedge CLOCK_50);
    repeat(20)                      @(posedge CLOCK_50);
    $stop;
  end
endmodule
