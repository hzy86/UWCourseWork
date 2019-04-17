module counter(clk, reset, count);
  input  logic clk, reset;
  output logic [4:0] count;

  always_ff @(posedge clk) begin
    if (reset)
      count <= 5'b0;
    else if (count < 31)
      count <= count + 1;
  end
endmodule

module counter_testbench();
  logic clk, reset;
  logic [5:0] count;

  counter dut (.clk, .reset, .count);

  // set up the clock
  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    reset <= 1; @(posedge clk);
    reset <= 0; @(posedge clk);
    repeat(40)  @(posedge clk);    
    $stop;
  end
endmodule
