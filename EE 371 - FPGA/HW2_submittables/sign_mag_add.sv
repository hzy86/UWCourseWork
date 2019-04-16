// Code from "FPGA prototyping by SystemVerilog examples" by P. Chu

module sign_mag_add
   #(parameter N=4)
   (
    input  logic [N-1:0] a, b,
    output logic [N-1:0] sum
   );

   // signal declaration
   logic [N-2:0]  mag_a, mag_b, mag_sum, max, min;
   logic sign_a, sign_b, sign_sum;

   //body
   always_comb
   begin
      // separate magnitude and sign
      mag_a = a[N-2:0];
      mag_b = b[N-2:0];
      sign_a = a[N-1];
      sign_b = b[N-1];
      // sort according to magnitude
      if (mag_a > mag_b)
         begin
            max = mag_a;
            min = mag_b;
            sign_sum = sign_a;
         end
      else
         begin
            max = mag_b;
            min = mag_a;
            sign_sum = sign_b;
         end
      // add/sub magnitude
      if (sign_a==sign_b)
         mag_sum = max + min;
      else
         mag_sum = max - min;
      // form output
      sum = {sign_sum, mag_sum};
   end
endmodule

`timescale 1ns / 1ps
module sign_mag_add_testbench();
  logic [7:0] a, b, sum;

  sign_mag_add #(8) dut (.a, .b, .sum);

  initial begin
    integer i, j;
    for (i = 0; i <= 1; i++) begin
      for (j = 0; j <= 1; j++) begin
        a[3] = i; b[3] = j;
        a[2:0] = 1; b[2:0] = 7; #5; // a < b with overflow
        a[2:0] = 1; b[2:0] = 2; #5; // a < b with no overflow
        a[2:0] = 1; b[2:0] = 0; #5; // a > b with no overflow
      end
    end

  end
endmodule
