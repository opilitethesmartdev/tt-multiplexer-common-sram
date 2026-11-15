/*
 * tt_um_test.v
 *
 * Test user module
 *
 * Copyright (c) 2023 Sylvain Munaut <tnt@246tNt.com>
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_test (
	// Power
`ifdef USE_POWER_PINS
	input wire VDPWR,
	input wire VAPWR,
	input wire VGND,
`endif

	// User interface
	input  wire [7:0]  ui_in,	// Dedicated inputs
	output wire [7:0]  uo_out,	// Dedicated outputs
	input  wire [7:0]  uio_in,	// IOs: Input path
	output wire [7:0]  uio_out,	// IOs: Output path
	output wire [7:0]  uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire        ena,
	input  wire        clk,
	input  wire        rst_n,
	output wire        sram_cs_n,
	output wire        sram_we_n,
	output wire [3:0]  sram_wmask,
	output wire [8:0]  sram_addr,
	output wire [31:0] sram_wdata,
	input  wire [31:0] sram_rdata
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
				sram_addr_reg <= {1'b0, ui_in};
				if (uio_in[0]) begin
					sram_we_n_reg  <= 1'b0;
					sram_wdata_reg <= {24'h123456, ui_in};
				end else begin
					sram_we_n_reg  <= 1'b1;
				end
			end else begin
				sram_cs_n_reg <= 1'b1;
				sram_we_n_reg <= 1'b1;
			end
		end

	assign uo_out  = ui_in[0] ? cnt : sram_rdata[7:0];
	assign uio_out = ui_in[0] ? cnt : 8'h00;
	assign uio_oe  = ui_in[0] ? 8'hff : 8'h00;

	assign sram_cs_n  = sram_cs_n_reg;
	assign sram_we_n  = sram_we_n_reg;
	assign sram_wmask = 4'hF;
	assign sram_addr  = sram_addr_reg;
	assign sram_wdata = sram_wdata_reg;

endmodule // tt_um_test

`default_nettype wire
