/*
 * tt_prim_mux2.v
 *
 * TT Primitive
 * Mux2
 *
 * Copyright (c) 2023 Sylvain Munaut <tnt@246tNt.com>
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_prim_mux2 (
	input  wire a,
	input  wire b,
	output wire x,
	input  wire s
);

	assign x = s ? b : a;

endmodule // tt_prim_mux2
