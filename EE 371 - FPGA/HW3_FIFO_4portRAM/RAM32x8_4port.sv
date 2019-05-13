/* 4 port 32x8 RAM
 * a synchronous 8-bit write port, an async 8-bit read port
 * a sync 32-bit read port to read 4 words at a time
 * a sync 4-bit read port to read a half word
 */
module RAM32x8_4port
#(parameter
    DATA_WIDTH = 8,
    ADDR_WIDTH = 5
)(
  input logic clk, reset, wr_en, startCyc,
  input logic [DATA_WIDTH - 1:0] w_d,
  input logic [ADDR_WIDTH - 1:0] w_s,
  input logic [ADDR_WIDTH - 1:0] r_s1, r_s2, r_s3,

  output logic [DATA_WIDTH - 1:0] r_d1,
  output logic [4 * DATA_WIDTH - 1:0] r_d2,
  output logic [DATA_WIDTH / 2 - 1:0] r_d3
);

  logic [DATA_WIDTH - 1:0] RAM [0:2 ** (ADDR_WIDTH) - 1];
  logic [ADDR_WIDTH - 1:0] rs1, rs2, rs3;
  integer count;

  initial begin
    $readmemh("mem.txt", RAM);
  end

  enum{normal, cycling}ps, ns;
  always_comb begin
    case(ps)
      normal: begin
        if (startCyc) ns = cycling;
        else ns = normal;
      end
      cycling: begin
        if (rs1 >= 2 ** (ADDR_WIDTH) - 1) ns = normal;
        else ns = cycling;
      end
    endcase
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      ps <= normal;
      count <= 0;
    end else begin
      ps <= ns;
      if (ps == cycling) begin
        rs1 <= count;
        if (count % 4 == 0) rs2 <= count;
        rs3 <= 0;
      end else begin
        count <= 0; rs1 <= r_s1; rs2 <= r_s2; rs3 <= r_s3;
      end
      if (ps != ns) count <= 0;
      else if (count >= 31) count <= 31;
      else count <= count + 1;
    end
    if (wr_en)
      RAM[w_s] <= w_d;
    r_d2 <= read_4(rs2);
    r_d3 <= read_half(rs3);
  end

  assign r_d1 = RAM[rs1];

  function automatic [4 * DATA_WIDTH - 1:0] read_4;
    input [ADDR_WIDTH - 1:0] addr;
    reg [ADDR_WIDTH - 1:0] addr_tmp;
    addr_tmp = (addr > 28)?28:addr;
    read_4 = {RAM[addr_tmp + 3], RAM[addr_tmp + 2], RAM[addr_tmp + 1], RAM[addr_tmp]};
  endfunction

  function automatic [DATA_WIDTH / 2 - 1:0] read_half;
    input [ADDR_WIDTH - 1:0] addr;
    read_half = RAM[addr][DATA_WIDTH / 2 - 1:0];
  endfunction
endmodule

module RAM32x8_4port_testbench();
  logic clk, reset, wr_en, startCyc;
  logic [4:0] r_s1, r_s2, r_s3, w_s;
  logic [7:0] r_d1, w_d;
  logic [31:0] r_d2;
  logic [3:0] r_d3;

  RAM32x8_4port dut (.clk, .reset, .startCyc, .wr_en, .w_d, .w_s, .r_s1, .r_s2, .r_s3, .r_d1, .r_d2, .r_d3);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  integer i;
  initial begin
    reset <= 1; wr_en <= 0; @(posedge clk);
    reset <= 0; startCyc <= 1;     @(posedge clk);
    // ------ test case 1 - the count cycle -----------
    startCyc <= 0;     @(posedge clk);
    repeat(40) @(posedge clk);
    startCyc <= 1;     @(posedge clk);
    startCyc <= 0;     @(posedge clk);
    // ------ test case 2 - the write enable -----------
    wr_en <= 1; @(posedge clk);
    for (i = 0; i < 40; i++) begin
      w_d <= i; w_s <= i; @(posedge clk);
    end
    // ------ test case 3 - the read at any address & verify write -----------
    for (i = 0; i < 40; i++) begin
      r_s1 <= i; r_s2 <= i; r_s3 <= i; @(posedge clk);
    end
    $stop;
  end
endmodule
