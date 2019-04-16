module F(w, x, y, z, f);
  input  logic w, x, y, z;
  output logic f;

  logic y1, y2;
  but b2 (.A1(w), .B1(y), .A2(x), .B2(z), .Y1(y1), .Y2(y2));

  assign f = y1 | y2;
endmodule

module but(A1, B1, A2, B2, Y1, Y2);
  input logic A1, B1, A2, B2;
  output logic Y1, Y2;

  always_comb begin
      if ( (A1 & B1)==1'b1 && (A2 & B2)==1'b0) Y1 = 1;
      else Y1 = 0;
      if ( (A2 & B2)==1'b1 && (A1 & B1)==1'b0) Y2 = 1;
      else Y2 = 0;
    end
endmodule

module F_testbench();
  logic w, x, y, z, f;

  F dut (.w, .x, .y, .z, .f);

  initial begin
    integer i;
    for (i = 0; i < 16; i++) begin
      {w, x, y, z} = i; #5;
      if ((i == 5 || i == 7 || i == 10 || i == 11 || i == 13 || i == 14)) begin
        if (f != 1) $display("error! F = %d but output false", i);
      end else if (f == 1)
        $display("error! F = %d but output true", i);
    end
  end
endmodule
