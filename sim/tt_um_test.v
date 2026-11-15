/*
 * tt_um_test.v
 *
 * Test user module
 *
 * Copyright (c) 2023 Sylvain Munaut <tnt@246tNt.com>
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "tt_defs.vh"

module tt_um_test #(
	parameter integer N_IO = `TT_N_IO,
	parameter integer N_O  = `TT_N_O,
	parameter integer N_I  = `TT_N_I
)(
	// Power
`ifdef USE_POWER_PINS
	input wire VDPWR,
	input wire VAPWR,
	input wire VGND,
`endif

	// User interface
	input  wire [N_I-1:0]  ui_in,	// Dedicated inputs
	output wire [N_O-1:0]  uo_out,	// Dedicated outputs
	input  wire [N_IO-1:0] uio_in,	// IOs: Input path
	output wire [N_IO-1:0] uio_out,	// IOs: Output path
	output wire [N_IO-1:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire            ena,
	input  wire            clk,
	input  wire            rst_n,
	output wire            sram_cs_n,
	output wire            sram_we_n,
	output wire [3:0]      sram_wmask,
	output wire [8:0]      sram_addr,
	output wire [31:0]     sram_wdata,
	input  wire [31:0]     sram_rdata
);

	reg rst_n_i;
	reg [7:0] cnt;
	reg [31:0] sram_wdata_reg;
	reg [8:0]  sram_addr_reg;
	reg        sram_we_n_reg;
	reg        sram_cs_n_reg;

	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			rst_n_i <= 1'b0;
		else
			rst_n_i <= 1'b1;

	always @(posedge clk or negedge rst_n_i)
		if (~rst_n_i) begin
			cnt <= 0;
			sram_cs_n_reg  <= 1'b1;
			sram_we_n_reg  <= 1'b1;
			sram_addr_reg  <= 9'd0;
			sram_wdata_reg <= 32'd0;
		end else begin
			cnt <= cnt + 1;
			if (ena) begin
				sram_cs_n_reg <= 1'b0;
				sram_addr_reg <= {7'd0, ui_in};
				if (uio_in[0]) begin
					sram_we_n_reg  <= 1'b0;
					sram_wdata_reg <= {30'h1234567, ui_in};
				end else begin
					sram_we_n_reg  <= 1'b1;
				end
			end else begin
				sram_cs_n_reg <= 1'b1;
				sram_we_n_reg <= 1'b1;
			end
		end

	assign uo_out  = (N_O > 0) ? ((ui_in[0]) ? {N_O{1'b1}} : {N_O{1'b0}}) : {N_O{1'b0}};
	assign uio_out = {N_IO{cnt[0]}};
	assign uio_oe  = {N_IO{ena}};

	assign sram_cs_n  = sram_cs_n_reg;
	assign sram_we_n  = sram_we_n_reg;
	assign sram_wmask = 4'hF;
	assign sram_addr  = sram_addr_reg;
	assign sram_wdata = sram_wdata_reg;

endmodule // tt_um_test

`default_nettype wire
