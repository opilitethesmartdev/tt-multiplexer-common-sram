/*
 * tt_formal.v
 *
 * Formal connectivity check
 *
 * Copyright (c) 2023 Matt Venn <matt@mattvenn.net>
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`timescale 1ns / 100ps
`include "tt_defs.vh"

module tt_formal;

	// Signals
	// -------

	// DUT signals
	wire [43:0] io_in;
	wire [43:0] io_out;
	wire [43:0] io_oex;
	wire        k_zero;
	wire        k_one;


	// DUT
	// ---

	tt_top #(
		.N_PADS (44),
		.G_X    (`TT_G_X),
		.G_Y    (`TT_G_Y),
		.N_IO   (`TT_N_IO),
		.N_O    (`TT_N_O),
		.N_I    (`TT_N_I)
	) dut_I (
		.io_in       (io_in),
		.io_out      (io_out),
		.io_oex      (io_oex),
		.k_zero      (k_zero),
		.k_one       (k_one)
	);

	// loop back bidirectional outs to ins, depending on output enable
`ifdef OE_POLARITY_NEGATIVE
	assign io_in[`TT_N_I + `TT_N_IO - 1 : `TT_N_I] = io_out[`TT_N_I + `TT_N_IO - 1 : `TT_N_I] & (~io_oex[`TT_N_I + `TT_N_IO - 1 : `TT_N_I]);
`else
	assign io_in[`TT_N_I + `TT_N_IO - 1 : `TT_N_I] = io_out[`TT_N_I + `TT_N_IO - 1 : `TT_N_I] & io_oex[`TT_N_I + `TT_N_IO - 1 : `TT_N_I];
`endif

endmodule // tt_formal

`default_nettype wire
