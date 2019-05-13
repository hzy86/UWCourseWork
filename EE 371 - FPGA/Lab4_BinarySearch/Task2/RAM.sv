/* 1 port 32x8 RAM
 * 1 synchronous port for reading and writing
 * writing is controlled by the write enable
 * @param data_width - word width
 * @param addr_width - address width
 * @input [1] clk - clock
 * @input [1] wr_en - write enable
 * @input [data_width] w_d - write data
 * @input [addr_width] addr - address for write and read
 * @output [data_width] data - read data
 */
module RAM
#(parameter
    DATA_WIDTH = 8,
    ADDR_WIDTH = 5
)(
  input logic clk, wr_en,
  input logic [DATA_WIDTH - 1:0] w_d,
  input logic [ADDR_WIDTH - 1:0] addr,
  output logic [DATA_WIDTH - 1:0] data
);

  logic [DATA_WIDTH - 1:0] RAM [0:2 ** (ADDR_WIDTH) - 1];

  initial begin
    $readmemh("mem.txt", RAM);
  end

  always_ff @(posedge clk) begin
    if (wr_en) RAM[addr] <= w_d;
    data <= RAM[addr];
  end
endmodule

module RAM_testbench();
  logic clk, wr_en;
  logic [4:0] addr;
  logic [7:0] w_d, data;

  RAM dut(.*);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    integer i;
    wr_en <= 0;     @(posedge clk);
    for (i = 0; i < 32; i++) begin
      addr <= i;    @(posedge clk);
                    @(posedge clk);
    end
    $stop;
  end
endmodule
