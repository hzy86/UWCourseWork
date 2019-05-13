/* A bit counter implementing a sample ASM chart
 * @param n - how many bits needed to represent the largest possible number
 * @input [1] clk - clock
 * @input [1] reset	- reset the states
 * @input [1] s - a start signal
 * @input [n] num - a number whose bits are counted
 * @output [5] result - the count of 1s in the binary form of the given num
 * @output [1] done - flag to signal current operation is finished
 */
module bit_counter_driver(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
  input logic CLOCK_50;
  input logic [3:0] KEY;
  input logic [9:0] SW;
  output logic [9:0] LEDR;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  assign HEX1 = 7'b1111111;
  assign HEX2 = 7'b1111111;
  assign HEX3 = 7'b1111111;
  assign HEX4 = 7'b1111111;
  assign HEX5 = 7'b1111111;

  logic reset, s, done;
  assign reset = ~KEY[0];
  assign s = SW[9];
  logic [4:0] result;

  bit_counter bc (.clk(CLOCK_50), .reset, .s, .num(SW[7:0]), .done(LEDR[9]), .result);
  assign HEX0 = num_display(result);

  function automatic [6:0] num_display;
    input [3:0] count;
    logic [6:0] HEX;
    case(count)
      0: HEX = 7'b1000000;
      1: HEX = 7'b1111001;
      2: HEX = 7'b0100100;
      3: HEX = 7'b0110000;
      4: HEX = 7'b0011001;
      5: HEX = 7'b0010010;
      6: HEX = 7'b0000010;
      7: HEX = 7'b1111000;
      8: HEX = 7'b0000000;
      9: HEX = 7'b0010000;
      default: HEX = 7'b1111111;
    endcase
    num_display = HEX;
  endfunction
endmodule

module bit_counter_driver_testbench();
  logic CLOCK_50;
  logic [3:0] KEY;
  logic [9:0] SW, LEDR;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  bit_counter_driver dut (.*);

  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    CLOCK_50 <= 0;
    forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
  end

  integer i;
  initial begin
    KEY[0] <= 0; @(posedge CLOCK_50);
    KEY[0] <= 1; @(posedge CLOCK_50);
    for (i = 0; i < 2**8; i++) begin
      SW[9] <= 0;               @(posedge CLOCK_50);
      SW[9] <= 1; SW[7:0] <= i; @(posedge CLOCK_50);
      repeat(8)                 @(posedge CLOCK_50);
    end
    $stop;
  end
endmodule
