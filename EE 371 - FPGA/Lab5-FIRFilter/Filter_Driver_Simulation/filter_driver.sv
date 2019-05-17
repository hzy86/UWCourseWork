module filter_driver
#(parameter N = 3, DATA_WIDTH = 24)
(
  input logic CLOCK_50, reset,
  input logic signed [23:0] readdata_left, readdata_right
);

  wire read_ready, write_ready, read, write;
  wire data_available;
  wire [23:0] writedata_left, writedata_right;

  wire signed[23:0] write_templ, write_tempr, read_templ, read_tempr;
  logic signed[23:0] samplel, sampler;
  wire emptyl, emptyr, fulll, fullr;

  assign read = read_ready;
  assign write = write_ready;

  fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(N)) ffl
	  (.clk(CLOCK_50), .reset(reset), .rd(fulll), .wr(1'b1), .w_data(write_templ), .empty(emptyl), .full(fulll), .r_data(read_templ));
	fifo #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(N)) ffr
	  (.clk(CLOCK_50), .reset(reset), .rd(fullr), .wr(1'b1), .w_data(write_tempr), .empty(emptyr), .full(fullr), .r_data(read_tempr));

  always_comb begin
    if (fulll && fullr) begin
      samplel = write_templ + (~read_templ + 1);
      sampler = write_tempr + (~read_tempr + 1);
    end else begin
      samplel = write_templ;
      sampler = write_tempr;
    end
  end

  assign write_templ = (readdata_left >>> N);
  assign write_tempr = (readdata_right >>> N);

  accumulator #(.DATA_WIDTH(DATA_WIDTH)) acl(.clock(CLOCK_50), .reset, .in(samplel), .out(writedata_left));
  accumulator #(.DATA_WIDTH(DATA_WIDTH)) acr(.clock(CLOCK_50), .reset, .in(sampler), .out(writedata_right));

endmodule

module filter_driver_testbench();
  logic CLOCK_50, reset;
  logic [23:0] readdata_left, readdata_right;

  filter_driver dut (.*);

  parameter CLOCK_PERIOD = 100;
  initial begin
    CLOCK_50 <= 0;
    forever #(CLOCK_PERIOD / 2) CLOCK_50 <= ~CLOCK_50;
  end

  initial begin
    integer i;
    integer start = -16;
    reset <= 1; @(posedge CLOCK_50);
    repeat(1) begin
      for (i = start; i < start + 32; i++) begin
        reset <= 0; readdata_left = i; readdata_right = i; @(posedge CLOCK_50);
      end
    end
    $stop;
  end
endmodule
