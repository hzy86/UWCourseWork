module accumulator #(parameter DATA_WIDTH = 24) (clock, reset, in, out);

	input  logic clock, reset;
	input  logic signed[DATA_WIDTH-1:0] in;
	output logic signed[DATA_WIDTH-1:0] out;

	logic overflow;

	always@(posedge clock or posedge reset) begin
	    if(reset) begin
	        out <= 'b0;
	        overflow <= 'b0;
	    end else begin
					out <= out + in;
	        // {overflow, out} <= out + in;
	    end
	end

endmodule
