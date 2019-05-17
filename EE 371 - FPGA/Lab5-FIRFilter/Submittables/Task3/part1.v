/* top-level interface to record voice input from a microphone, filter the result with an N-tap
 * FIR filter, and playback with a speaker
 * @param N - log2(Tap)
 * @param DATA_WIDTH - input size
 * @input [1] CLOCK_50 - DE1-SoC built-in 50MHz clock
 * Other signals - internal signals used by the starter kit to configure the microphone
 * @calling modules filter fl, fr - run the filter module
 *					@input clk - CLOCK_50
 *					@input in - write_templ/write_tempr
 *					@output out - read_templ/read_tempr
 * @calling modules DFF acl, acr - the accumulators
 *					@input clk - CLOCK_50
 *					@input reset - reset
 *					@input d - writedata_left/writedata_right
 *					@output q - accl/accr
 */
module part1 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK,
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	// last 2**N samples
	parameter N = 8;
	parameter DATA_WIDTH = 24;

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;

	// Local wires.
	wire read_ready, write_ready, read, write;
	wire signed[23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	wire signed[23:0] noise;
	wire signed[23:0] write_templ, write_tempr, read_templ, read_tempr;
	wire signed[23:0] accl, accr;
	wire emptyl, emptyr, fulll, fullr;
	/////////////////////////////////
	// Your code goes here
	/////////////////////////////////

	assign read = read_ready;
	assign write = write_ready;
	noise_generator (CLOCK_50, 1'b1, noise);
	filter #(.FILTER_WIDTH(N)) fl(.clock(CLOCK_50), .in(write_templ), .out(read_templ));
	filter #(.FILTER_WIDTH(N)) fr(.clock(CLOCK_50), .in(write_tempr), .out(read_tempr));

	assign write_templ = (readdata_left >>> N);
	assign write_tempr = (readdata_right >>> N);


	D_FF acl(.clk(CLOCK_50), .reset(reset), .d(writedata_left), .q(accl));
	D_FF acr(.clk(CLOCK_50), .reset(reset), .d(writedata_right), .q(accr));

	assign writedata_left = write_templ + (~read_templ + 1) + accl;
	assign writedata_right = write_tempr + (~read_tempr + 1) + accr;

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface.
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule
