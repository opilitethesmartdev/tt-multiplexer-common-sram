/*
 * tt_gf_wrapper.v
 *
 * GF180MCU Top Level Wrapper for TinyTapeout Multiplexer
 *
 * Copyright (c) 2024
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "tt_defs.vh"

module tt_gf_wrapper (
`ifdef USE_POWER_PINS
	inout wire VDPWR,
	inout wire VAPWR,
	inout wire VGND,
`endif
	inout wire [73:0] pad_raw
);

	wire [43:0] io_ana;
	wire [43:0] io_in;
	wire [43:0] io_out;
	wire [43:0] io_oex;
	wire        k_zero;
	wire        k_one;

	// Control pads (0..5)
	assign io_in[43:38] = pad_raw[5:0];

	// Analog pads (6..17)
	assign io_in[37:32] = pad_raw[32:27];
	assign io_in[11:6]  = pad_raw[24:19];

	// Outputs (18..25)
	assign io_in[25:18] = pad_raw[16:9];

	// Bidirectional IOs (26..33)
	assign io_in[33:26] = pad_raw[44:37];

	// Inputs (34..43)
	assign io_in[1] = pad_raw[54]; // u_rst_n
	assign io_in[0] = pad_raw[55]; // u_clk
	assign io_in[9] = pad_raw[46];
	assign io_in[8:2] = pad_raw[53:47];

	// Expose the twelve analog-capable pads used by tt_top.
	// Keep both directions connected so user analog switches can pass
	// signals between the physical pads and the user modules.
	assign io_ana[12:7] = pad_raw[24:19];
	assign pad_raw[24:19] = io_ana[12:7];
	assign io_ana[37:32] = pad_raw[32:27];
	assign pad_raw[32:27] = io_ana[37:32];

	// Drive output and bidirectional pads only when their output enables
	// are asserted. GF180 uses active-high output enables.
	assign pad_raw[16:9] = io_oex[25:18] ? io_out[25:18] : 8'bz;
	assign pad_raw[44:37] = io_oex[33:26] ? io_out[33:26] : 8'bz;

	tt_top top_I (
`ifdef USE_POWER_PINS
		.VDPWR  (VDPWR),
		.VAPWR  (VAPWR),
		.VGND   (VGND),
`endif
		.io_ana (io_ana),
		.io_in  (io_in),
		.io_out (io_out),
		.io_oex (io_oex),
		.k_zero (k_zero),
		.k_one  (k_one)
	);

endmodule // tt_gf_wrapper

`default_nettype wire
