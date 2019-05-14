module divider (Clock, Resetn, s, LA, EB, DataA, DataB, R, Q, Done);
	parameter n = 8, logn = 3;
	input Clock, Resetn, s, LA, EB;
	input [n-1:0] DataA, DataB;
	output [n-1:0] R, Q;
	output reg Done;
	wire Cout, z;
	wire [n-1:0] DataR;
	wire [n:0] Sum;
	reg [1:0] y, Y;
	reg [n-1:0] A, B;
	reg [logn-1:0] Count;
	reg EA, Rsel, LR, ER, ER0, LC, EC, R0;
	integer k;

// control circuit

	parameter S1 = 2'b00, S2 = 2'b01, S3 = 2'b10;

	always @(s, y,  z)
	begin: State_table
		case (y)
			S1:	if (s == 0) Y = S1;
				else Y = S2;
			S2:	if (z == 0) Y = S2;
				else Y = S3;
			S3:	if (s == 1) Y = S3;
				else Y = S1;
			default: Y = 2'bxx;
		endcase
	end

	always @(posedge Clock, negedge Resetn)
	begin: State_flipflops
		if (Resetn == 0)
			y <= S1;
		else
			y <= Y;
	end

	always @(y, s, Cout, z)
	begin: FSM_outputs
		// defaults
		LR = 0; ER = 0; ER0 = 0; LC = 0; EC = 0; EA = 0;
		Rsel = 0; Done = 0;
		case (y)
			S1:	begin
					LC = 1; ER = 1;
					if (s == 0)
					begin
						LR = 1; ER0 = 0;
					end
					else
					begin
						LR = 0; EA = 1; ER0 = 1;
					end
				end
			S2:	begin
					Rsel = 1; ER = 1; ER0 = 1; EA = 1;
					if (Cout) LR = 1;
					else LR = 0;
					if (z == 0) EC = 1;
					else EC = 0;
				end
			S3:	Done = 1;
		endcase
	end

//datapath circuit

	regne RegB (DataB, Clock, Resetn, EB, B);
		defparam RegB.n = n;
	shiftlne ShiftR (DataR, LR, ER, R0, Clock, R);
		defparam ShiftR.n = n;
	muxdff FF_R0 (1'b0, A[n-1], ER0, Clock, R0);
	shiftlne ShiftA (DataA, LA, EA, Cout, Clock, A);
		defparam ShiftA.n = n;
	assign Q = A;
	downcount Counter (Clock, EC, LC, Count, Q);
		defparam Counter.n = logn;

	assign z = (Count == 0);
	assign Sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1;
	assign Cout = Sum[n];

	// define the n 2-to-1 multiplexers
	assign DataR = Rsel ? Sum : 0;

endmodule

module divider_testbench();
	reg Clock, Resetn, s, LA, EB, Done;
	reg [7:0] DataA, DataB, R, Q;

	divider dut (.*);

	parameter CLOCK_PERIOD = 100;
	initial begin
		Clock <= 0;
		forever #(CLOCK_PERIOD / 2) Clock <= ~Clock;
	end

	initial begin
		Resetn <= 0; s <= 0; @(posedge Clock);
		Resetn <= 1; s <= 1; DataA <= 255; DataB <= 100; LA <= 1; EB <= 1; @(posedge Clock);
		repeat(20)					@(posedge Clock);
	end

	initial begin

	end
endmodule
