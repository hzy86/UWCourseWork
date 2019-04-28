/* FSM for a 5-stage line animation
 * input:
 *        clk (clock)
 *				reset	(reset the FSM)
 * 				white (if the current pixel color is white)
 * output:
 *        [11 bits] (x0, y0) (next start point), (x1, y1) (next endpoint)
 *        color (next color)
 */
module animation(
  input logic clk, reset, white, clear,
  output logic [10:0] x0, y0, x1, y1,
  output logic color
);
  enum{s1, s2, s3, s4, s5} ps, ns;
  always_comb begin
    case(ps)
      s1: begin
        if (~white) begin
          ns = s2;
        end else begin
          ns = s1;
        end
        x0 = 120; y0 = 120; x1 = 120; y1 = 240;
      end
      s2: begin
        if (~white) begin
          ns = s3;
        end else begin
          ns = s2;
        end
        x0 = 120; y0 = 240; x1 = 240; y1 = 240;
      end
      s3: begin
        if (~white) begin
          ns = s4;
        end else begin
          ns = s3;
        end
        x0 = 240; y0 = 240; x1 = 120; y1 = 120;
      end
      s4: begin
        if (~white) begin
          ns = s5;
        end else begin
          ns = s4;
        end
        x0 = 120; y0 = 120; x1 = 230; y1 = 0;
      end
      s5: begin
        if (~white) begin
          ns = s1;
        end else begin
          ns = s5;
        end
        x0 = 120; y0 = 120; x1 = 240; y1 = 150;
      end
      default: ns = s2;
    endcase
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      ps <= s1;
      color <= 1;
    end
    else begin
      ps <= ns;
      color <= (ps != ns) & ~clear;
    end
  end

endmodule

// reset once to see the FSM works
module animation_testbench();
  logic clk, reset;
  logic [10:0] x0, y0, x1, y1;

  animation dut(.clk, .reset, .x0, .y0, .x1, .y1);

  parameter CLOCK_PERIOD = 1000;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    repeat(100) @(posedge clk);
    $stop;
  end
endmodule
