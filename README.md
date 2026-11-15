# The Tiny Tapeout Multiplexer (GF180MCU with Shared SRAM Interface)

[![formal](https://github.com/opilitethesmartdev/tt-multiplexer-common-sram/actions/workflows/formal.yaml/badge.svg)](https://github.com/opilitethesmartdev/tt-multiplexer-common-sram/actions/workflows/formal.yaml)

This repository is a customized fork of the Tiny Tapeout multiplexer targeting the **GF180MCU** process node (`gf180mcuD`).

## Key Features

1. **Shared SRAM Interface (`c4m-arrakeen` 512x32)**:
   - Configured the multiplexer to provide a shared **512x32 SRAM** memory interface (`c4m_arrakeen_sram_512x32`) to each user design slot.
   - User designs receive dedicated memory interface lines:
     - `sram_cs_n`: Chip select (active low)
     - `sram_we_n`: Write enable (active low)
     - `sram_wmask[3:0]`: 4-bit byte write mask
     - `sram_addr[8:0]`: 9-bit address for 512 words
     - `sram_wdata[31:0]`: 32-bit write data input to SRAM
     - `sram_rdata[31:0]`: 32-bit read data output from SRAM
   - Outward SRAM control and write lines are multiplexed across active branches to the central SRAM macro, and read data is routed back through zeroing buffers to the active design.

2. **Standard Pinout (`main` branch)**:
   - Preserves the default TinyTapeout pinout allocation for GF180MCU, including the following user-accessible signals:
     - **10 Dedicated Inputs**: `ui_in[9:0]` (including `u_clk` and `u_rst_n`)
     - **8 Dedicated Outputs**: `uo_out[7:0]`
     - **8 Bidirectional I/Os**: `uio_in[7:0]`, `uio_out[7:0]`, `uio_oe[7:0]` (output enable)
     - **Analog Pins**: 22 external analog pins (`analog[21:0]`) and 8 internal user-accessible analog pins.
   - **Mux Control Inputs**: Three dedicated inputs (`ctrl_ena`, `ctrl_sel_inc`, `ctrl_sel_rst_n`) are used to control the multiplexer and select the active user design. These are separate from the user-accessible `ui_in` signals.

3. **Experimental Branch (`experimental-all-bidir`)**:
   - For a custom pinout variant where all general-purpose digital IOs are bidirectional, see the [`experimental-all-bidir`](https://github.com/opilitethesmartdev/tt-multiplexer-common-sram/tree/experimental-all-bidir) branch.

## Overview & Architecture

Curious to learn how the multiplexer works? Read the [explainer](docs/INFO.md) or inspect the top-level implementation in [`rtl/tt_top.v`](rtl/tt_top.v).

## License

See the [LICENSE](LICENSE)
