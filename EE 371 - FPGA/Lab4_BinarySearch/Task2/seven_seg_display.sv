/* 
 * Hexadecimal display module for 5 bits input
 * @param data_width - word width
 * @param addr_width - address width
 * @output [1] HEX0, HEX1 - HEX display on board
 * @input [1] found - found the correct address
 * @input [4:0] result_addr - address of the data to be displayed
 */
module seven_seg_display(HEX0, HEX1, found, result_addr);
	output logic [6:0] HEX0, HEX1;
	input logic found;
	input logic [4:0] result_addr;

	// cases logic used for display
	logic da1; // address hex tens digit 0(1'b0) to 1(1'b1)
	logic [3:0] da0; // address hex ones digit 0(4'b0000) to F(4'b1111)
	
	// This block controls tens and ones digits for address display
	assign da1 = result_addr[4];
	assign da0 = result_addr[3:0];
	
	always_comb begin
		if (da1 == 0)						  // HEX1-0 displays write address
			HEX1 = 7'b1000000;			  //0
		else
			HEX1 = 7'b1001111;			  //1
		
		case (da0)
			4'b0000: HEX0 = 7'b1000000; //0
			4'b0001: HEX0 = 7'b1001111; //1
			4'b0010: HEX0 = 7'b0100100; //2
			4'b0011: HEX0 = 7'b0110000; //3
			4'b0100: HEX0 = 7'b0011001; //4
			4'b0101: HEX0 = 7'b0010010; //5
			4'b0110: HEX0 = 7'b0000010; //6
			4'b0111: HEX0 = 7'b1111000; //7
			4'b1000: HEX0 = 7'b0000000; //8
			4'b1001: HEX0 = 7'b0010000; //9
			4'b1010: HEX0 = 7'b0001000; //A
			4'b1011: HEX0 = 7'b0000011; //b
			4'b1100: HEX0 = 7'b1000110; //C
			4'b1101: HEX0 = 7'b0100001; //d
			4'b1110: HEX0 = 7'b0000110; //E
			4'b1111: HEX0 = 7'b0001110; //F
			default: HEX0 = 7'b1111111; //x
		endcase
	end
	
endmodule

/* seven_seg_display testbench for simulation
module seven_seg_display_testbench();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [3:0] read;
	logic [3:0] data;
	logic [4:0] addr, read_addr;
	
	seven_seg_display dut(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, addr, data, read_addr, read);
	
	initial begin
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00000; #10; // addr = 0 data = 0 read = 0 read_addr = 0
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00001; #10; // addr = 1 data = 1 read = 1 read_addr = 1
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00010; #10; // addr = 4 data = 3 read = 3 read_addr = 2
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00011; #10; // addr = 9 data = 8 read = 8 read_addr = 3
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00100; #10; // addr = 10 data = 9 read = 9 read_addr = 4
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00101; #10; // addr = 19 data = 10 read = 10 read_addr = 5
		addr = 5'b00000; data = 4'b0000; read = 4'b0000; read_addr = 5'b00110; #10; // addr = 20 data = 10 read = 10 read_addr = 6
		$stop;  // END
	end
endmodule
*/