/* finite states machine of the parkinglot design
 * input:  clk, reset, ab[1:0]
 *           ab[1] - sensor A blocked
 *           ab[0] - sensor B blocked
 * output: io[1:0]
 *           io[1] - enter
 *           io[0] - exit
 */
module parkinglot(clk, reset, ab, io);
  input  logic clk, reset;
  input  logic [1:0] ab;
  output logic [1:0] io;

  // states
  enum{s_00, s_0010, s_001011, s_00101101, s_0001, s_000111, s_00011110} ps, ns;
  always_ff @(posedge clk) begin
    if (reset)
      ps <= s_00;
    else
      ps <= ns;
  end

  // edges assignments of the states
  always_comb begin
    case(ps)
      s_00:
        if (ab == 2'b10)            ns = s_0010;
        else if (ab == 2'b01)       ns = s_0001;
        else                        ns = s_00;
      s_0010: if (ab == 2'b11)      ns = s_001011;
              else                  ns = s_0010;
      s_001011: if (ab == 2'b01)    ns = s_00101101;
                else                ns = s_001011;
      s_00101101: if (ab == 2'b00)  ns = s_00;
                  else              ns = s_00101101;
      s_0001: if (ab == 2'b11)      ns = s_000111;
              else                  ns = s_0001;
      s_000111: if (ab == 2'b10)    ns = s_00011110;
                else                ns = s_000111;
      s_00011110: if (ab == 2'b00)  ns = s_00;
                  else              ns = s_00011110;
      default:                      ns = s_00;
      endcase
  end

  // enter & exist assignments
  assign io[1] = (ab == 2'b01) && (ps == s_001011);
  assign io[0] = (ab == 2'b10) && (ps == s_000111);
endmodule


module parkinglot_testbench();
  logic clk, reset;
  logic [1:0] ab, io;


  parkinglot dut (.clk, .reset, .ab, .io);

  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    // --------- test case 1 ----------

    repeat(30)  begin
      ab <= 2'b00; @(posedge clk);
      ab <= 2'b10; @(posedge clk);
      ab <= 2'b11; @(posedge clk);
      ab <= 2'b01; @(posedge clk);
      ab <= 2'b00; @(posedge clk);
    end
    // --------- test case 2 ----------
    repeat(30)  begin
      ab <= 2'b00; @(posedge clk);
      ab <= 2'b01; @(posedge clk);
      ab <= 2'b11; @(posedge clk);
      ab <= 2'b10; @(posedge clk);
      ab <= 2'b00; @(posedge clk);
    end

    // --------- test case 3 ----------
    ab = 2'b00; @(posedge clk);
    ab = 2'b10; @(posedge clk);
    ab = 2'b01; @(posedge clk);
    ab = 2'b00; @(posedge clk);
    $stop;
  end
endmodule
