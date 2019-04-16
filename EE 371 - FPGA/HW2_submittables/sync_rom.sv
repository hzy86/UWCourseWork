parameter romVals = "truthtable8.txt";
parameter addr_width = 8;
parameter data_width = 8;
module sync_rom
(
  input  logic clk,
  input  logic [addr_width - 1:0] addr,
  output logic [data_width - 1:0] data
);
  logic [data_width - 1:0] rom [0:2 ** (addr_width) - 1];
  logic [data_width - 1:0] data_reg;

  initial
    $readmemh(romVals, rom);

  always_ff @(posedge clk)
    data_reg <= rom[addr];

  assign data = data_reg;
endmodule

module sync_rom_testbench();
  logic clk;
  logic [addr_width - 1:0] addr;
  logic [data_width - 1:0] data;

  sync_rom dut(.clk, .addr, .data);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  initial begin
    integer i;
    for (i = 0; i < 2 ** (addr_width); i++) begin
      addr <= i; @(posedge clk);
    end
    $stop;
  end
endmodule
