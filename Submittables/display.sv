/* displays the count on the 7-segment displays (HEXes)
 * input:  count
 * output:
 *            HEX5 HEX4 HEX3 HEX2 HEX1 HEX0
 * (count==0)   C   L    E    A    R    0
 * (0, 25)                         #    #
 * (count==25)  F   U    L    L    2    5
 */
module display(count, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
  input logic [5:0] count;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  // padding count to 32-bit
  logic [31:0] num;
  assign num = {26'b0, count};

  // function that returns the HEX sequence for the given integer within (0, 9)
  // returns sequence for 0 if the input is out of range
  function automatic [6:0] num_display;
    input [31:0] num;
    logic [6:0] HEX;
    case(num)
      0: HEX = 7'b1000000;
      1: HEX = 7'b1111001;
      2: HEX = 7'b0100100;
      3: HEX = 7'b0110000;
      4: HEX = 7'b0011001;
      5: HEX = 7'b0010010;
      6: HEX = 7'b0000010;
      7: HEX = 7'b1111000;
      8: HEX = 7'b0000000;
      9: HEX = 7'b0010000;
      default: HEX = 7'b1000000;
    endcase
    num_display = HEX;
  endfunction

  // displays HEX sequence according to the current count
	assign HEX0 = num_display(num % 10);
	always_comb begin
		if (num == 0) begin             // CLEAR0 when padded count = 0
			HEX1 = 7'b0001000;
			HEX2 = 7'b0001000;
			HEX3 = 7'b0000110;
			HEX4 = 7'b1000111;
			HEX5 = 7'b1000110;
		end else if (num == 25) begin   // FULL25 when padded count = 25
			HEX1 = num_display(num / 10);
			HEX2 = 7'b1000111;
			HEX3 = 7'b1000111;
			HEX4 = 7'b1000001;
			HEX5 = 7'b0001110;
		end else begin
			HEX1 = num_display(num / 10);  // count when padded count is within (0, 25)
			HEX2 = 7'b1111111;
			HEX3 = 7'b1111111;
			HEX4 = 7'b1111111;
			HEX5 = 7'b1111111;
		end
	end
endmodule

module display_testbench();
  logic [5:0] count;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  display dut (.count, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5);
  initial begin
    integer i;
    for (i = 0; i < 26; i++) begin
      count = i[5:0]; #5;
    end
  end

endmodule
