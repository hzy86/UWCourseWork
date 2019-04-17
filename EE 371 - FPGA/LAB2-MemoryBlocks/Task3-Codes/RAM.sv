module RAM
(
  input  logic clk, we,
  input  logic [4:0] addr,
  input  logic [3:0] din,
  output logic [3:0] dout
);
  logic [3:0] ram [0:31];
  logic [3:0] data_reg;

  always_ff @(posedge clk) begin
    if(we) begin
      ram[addr] <= din;
    end
    data_reg <= ram[addr];
  end

  assign dout = ram[addr];
endmodule

module RAM_testbench();
  logic clk, we;
  logic [4:0] addr;
  logic [3:0] din, dout;

  RAM dut(.clk, .we, .addr, .din, .dout);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    integer i;
    we <= 1;     @(posedge clk);
    for (i = 0; i < 32; i++) begin
      addr <= i; din <= i; @(posedge clk);
                           @(posedge clk);
    end
    $stop;
  end
endmodule
