// Listing 7.8
module fifo
   #(
    parameter DATA_WIDTH=8, // number of bits in a word
              ADDR_WIDTH=4  // number of address bits
   )
   (
    input  logic clk, reset,
    input  logic rd, wr,
    input  logic [2*DATA_WIDTH-1:0] w_data,
    output logic empty, full,
    output logic [DATA_WIDTH-1:0] r_data
   );

   //signal declaration
   logic [ADDR_WIDTH-1:0] w_addr, r_addr;
   logic wr_en, full_tmp;

   // body
   // write enabled only when FIFO is not full
   assign wr_en = wr & ~full_tmp;
   assign full = full_tmp;

   // instantiate fifo control unit
   fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) c_unit
      (.*, .full(full_tmp));

   // instantiate register file
   reg_file
      #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) f_unit (.*);
endmodule

module fifo_testbench();
  logic clk, reset, rd, wr, empty, full;
  logic [15:0] w_data;
  logic [7:0] r_data;

  fifo dut(.*);

  parameter CLOCK_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(CLOCK_PERIOD / 2) clk <= ~clk;
  end

  integer i;
  initial begin
    // ----------- test case 1 - write  to full --------------------
    reset <= 1;           @(posedge clk);
    reset <= 0; wr <= 1; rd <= 0; w_data <= 'h0011; @(posedge clk);
    repeat(20) @(posedge clk);
    // ----------- test case 2 - read  to empty --------------------
    wr <= 0; rd <= 1; w_data <= 'h0011; @(posedge clk);
    repeat(40) @(posedge clk);
    // ----------- test case 2 - read write together --------------------
    wr <= 1; rd <= 1; w_data <= 'h2233; @(posedge clk);
    repeat(40) @(posedge clk);
    $stop;
  end
endmodule
