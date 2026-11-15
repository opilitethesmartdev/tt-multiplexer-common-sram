/*
 * tt_um_formal.v
 *
 * User module for formal connectivity proof
 *
 * Copyright (c) 2023 Matt Venn <matt@mattvenn.net>
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_formal (
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
    
    // let solver drive the outputs
    rand reg [7:0] anyseq1; assign uo_out   = anyseq1;
    // bidirectional outputs
    rand reg [7:0] anyseq2; assign uio_out  = anyseq2;
    // bidirectional enables
    rand reg [7:0] anyseq3; assign uio_oe   = anyseq3;

    rand reg        anyseq_cs_n;  assign sram_cs_n  = anyseq_cs_n;
    rand reg        anyseq_we_n;  assign sram_we_n  = anyseq_we_n;
    rand reg [3:0]  anyseq_wmask; assign sram_wmask = anyseq_wmask;
    rand reg [8:0]  anyseq_addr;  assign sram_addr  = anyseq_addr;
    rand reg [31:0] anyseq_wdata; assign sram_wdata = anyseq_wdata;
    
    always @(*) begin
        if(ena) begin
            // if design is enabled, looped back inputs must = outputs
            assert(ui_in == uo_out);
            // bidirectional outputs, only should match if oe is set
            assert(uio_in == (uio_out & uio_oe));
        end else begin
            // otherwise inputs must be 0
            assert(ui_in == 0);
            // design is in reset 
            assert(rst_n == 0);
            // no clock
            assert(clk == 0);
        end
    end

endmodule // tt_um_formal

`default_nettype wire
