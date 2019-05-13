/* A bit counter implementing a sample ASM chart
 * @param n - how many bits needed to represent the largest possible number
 * @input [1] clk - clock
 * @input [1] reset	- reset the states
 * @input [1] s - a start signal
 * @input [n] num - a number whose bits are counted
 * @output [5] result - the count of 1s in the binary form of the given num
 * @output [1] done - flag to signal current operation is finished
 */
module bit_counter
#(parameter n=8)
(
  input logic clk, reset, s,
  input logic [n-1:0] num,
  output logic done,
  output logic [4:0] result
);

  logic [4:0] result_next;
  logic [n-1:0] A, A_next;

  enum{s1, s2, s3}ps, ns;
  always_comb begin
    case(ps)
      s1: begin
            A_next = num;
            result_next = 0;
            if (s) ns = s2;
            else   ns = s1;
          end
      s2: begin
            A_next = A >> 1;
            if (A) begin
              ns = s2;
              if (A[0]) result_next = result + 1;
              else    result_next = result;
            end else begin
				  result_next = result;
              ns = s3;
            end
          end
      s3: begin
				A_next = num;
				result_next = result;
            if (s) ns = s3;
            else   ns = s1;
          end
      default: ns = s1;				
    endcase
  end

  always_ff @(posedge clk) begin
    if(reset) begin
      ps <= s1;
      result <= 0;
    end else begin
      ps <= ns;
      result <= result_next;
    end
    A <= A_next;
    done <= (ps == s3);
  end
endmodule

/* verify that the bit count for each number in range (0, 2**8) is correct
 * verify that the system responds correctly to reset and s
 */
module bit_counter_testbench();
  logic clk, reset, s, done;
  logic [7:0] num;
  logic [4:0] result;

  bit_counter dut (.*);

  parameter CLOCK_PERIOD = 1000;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  integer i;
  initial begin
    reset <= 1;          @(posedge clk);
    reset <= 0;          @(posedge clk);
    for (i = 0; i < 2**8; i++) begin
      s <= 0;           @(posedge clk);
      s <= 1; num <= i; @(posedge clk);
      repeat(8)         @(posedge clk);
    end
    $stop;
  end
endmodule
