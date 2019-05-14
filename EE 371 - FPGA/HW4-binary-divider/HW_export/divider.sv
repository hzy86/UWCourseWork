module divider
#(parameter n = 8, logn = 3)
( input logic clock, resetn, s, LA, EB,
  input logic [n-1:0] DataA, DataB,
  output logic [n-1:0] R, Q,
  output logic Done
);
	logic cout, z;
	logic [n-1:0] DataR, A, B;
	logic [n:0] sum;
	logic [logn-1:0] count;
	logic EA, Rsel, LR, ER, ER0, LC, EC, R0, EQ;
	integer k;

// control circuit

	enum{s1, s2, s3}ps, ns;
	always_comb begin
		case (ps)
			s1:	if (s == 0) ns = s1;
				  else ns = s2;
			s2: if (z == 0) ns = s2;
          else ns = s3;
			s3:	if (s == 1) ns = s3;
				  else ns = s1;
			default: ns = ps;
		endcase
	end

	always_ff @(posedge clock or negedge resetn) begin
		if (resetn == 0)
			ps <= s1;
		else
			ps <= ns;
	end

	always_comb begin
		// defaults
    LR = 0; ER = 0; ER0 = 0; LC = 0; EC = 0; EA = 0;
		Rsel = 0; Done = 0;
		case (ps)
			s1:	begin
  					LC = 1; ER = 1;
  					if (s == 0) begin
  						LR = 1; ER0 = 0;
  					end else begin
  						LR = 0; EA = 1; ER0 = 1;
  					end
				  end
      s2:	begin
					Rsel = 1; ER = 1; ER0 = 1; EA = 1;
					if (cout) LR = 1;
					else LR = 0;
					if (z == 0) EC = 1;
					else EC = 0;
				end
			s3:	Done = 1;
		endcase
	end

//datapath circuit

	regne RegB (.R(DataB), .clock, .resetn, .E(EB), .Q(B));
		defparam RegB.n = n;
	shiftlne ShiftR (.R(DataR), .L(LR), .E(ER), .w(R0), .clock, .Q(R));
		defparam ShiftR.n = n;
	muxdff FF_R0 (.D0(1'b0), .D1(A[n-1]), .Sel(ER0), .clock, .Q(R0));
	shiftlne ShiftA (.R(DataA), .L(LA), .E(EA), .w(cout), .clock, .Q(A));
		defparam ShiftA.n = n;
	assign Q = A;
	downcount Counter (.clock, .E(EC), .L(LC), .R(n-1), .Q(count));
		defparam Counter.n = logn;

	assign z = (count == 0);
	assign sum = {1'b0, R[n-2:0], R0} + {1'b0, ~B} + 1;
	assign cout = sum[n];

	// define the n 2-to-1 multiplexers
	assign DataR = Rsel ? sum : 0;

endmodule

module divider_testbench();
	logic clock, resetn, s, LA, Done, EB;
	logic [7:0] DataA, DataB, R, Q;

	divider dut (.*);

	parameter clock_PERIOD = 100;
	initial begin
		clock <= 0;
		forever #(clock_PERIOD / 2) clock <= ~clock;
	end

	initial begin
    // ------------------------- Case 1 - 255/100 --------------------------------------
		resetn <= 0; s <= 0; EB <= 1; LA <= 1;@(posedge clock);
		resetn <= 1; s <= 0; DataA <= 255; DataB <= 100;  LA <= 1;@(posedge clock);
    s <= 1; LA <= 0;            @(posedge clock);
		repeat(20)					@(posedge clock);

    // ------------------------- Case 2 - 255/10 --------------------------------------
    resetn <= 0; s <= 0; EB <= 1; LA <= 1;@(posedge clock);
		resetn <= 1; s <= 0; DataA <= 255; DataB <= 10;  LA <= 1;@(posedge clock);
    s <= 1; LA <= 0;            @(posedge clock);
		repeat(20)					@(posedge clock);
    $stop;
	end
endmodule
