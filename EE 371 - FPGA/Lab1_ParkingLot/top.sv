/* top level program that interfaces on-board control to design components
 * input:  CLOCK_50, Switches (SW)
 *          SW[9] - reset, SW[1] - a, SW[0] - b
 * output: HEX displays (HEX), GPIO pins (GPIO_0)
 *          HEX - current count of cars
 *          GPIO_0[0] - sensor b blocked - green off-board LED
 *          GPIO_0[1] - sensor a blocked - red off-board LED
 * calling modules:
 *          parkinglot -  the finite state machine
 *            - input:  SW[1:0] (ab)
 *            - output: io[1] (enter), io[0] (exit)
 *          counter - the counter
 *            - input:  io[1:0] (enter, exit)
 *            - output: count (current count)
 *          display - display the count on the HEXes
 *            - input: count
 *            - output: HEX0-HEX5
 */
module top(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, GPIO_0);
  input logic CLOCK_50;
  input logic [3:0] KEY;
  input logic [9:0] SW;
  inout logic [35:0] GPIO_0;
  output logic [9:0] LEDR;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  logic reset;
  assign reset = SW[9];
  logic [5:0] count;
  logic [1:0] io;
  assign GPIO_0[1] = SW[1];
  assign GPIO_0[0] = SW[0];

  parkinglot pkl (.clk(CLOCK_50), .reset, .ab(SW[1:0]), .io(io));
  counter ct (.clk(CLOCK_50), .reset, .io(io), .count);
  display dp (.count, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
endmodule

module top_testbench();
  logic CLOCK_50;
  logic [3:0] KEY;
  logic [9:0] SW, LEDR;
  wire [35:0] GPIO_0;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  top dut (.CLOCK_50, .KEY, .SW, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR, .GPIO_0);

  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    CLOCK_50 <= 0;
    forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
  end

  initial begin
    // ---------------------- testcase 1 - route to inc ----------------------
    SW[9] <= 1; @(posedge CLOCK_50);
    SW[9] <= 0; @(posedge CLOCK_50);

    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);
    SW[1:0] <= 2'b10; @(posedge CLOCK_50);

    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);
    SW[1:0] <= 2'b10; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);

    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    SW[1:0] <= 2'b10; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);

    SW[1:0] <= 2'b10; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);
    SW[1:0] <= 2'b00; @(posedge CLOCK_50);

    // ---------------------- testcase 2 - route to dec----------------------

    SW[1:0] <= 2'b01; @(posedge CLOCK_50);

    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);
    SW[1:0] <= 2'b10; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);

    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);
    SW[1:0] <= 2'b10; @(posedge CLOCK_50);

    SW[1:0] <= 2'b10; @(posedge CLOCK_50);
    SW[1:0] <= 2'b11; @(posedge CLOCK_50);
    SW[1:0] <= 2'b01; @(posedge CLOCK_50);
    SW[1:0] <= 2'b00; @(posedge CLOCK_50);
    $stop;
  end
endmodule
