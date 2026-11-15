# The Tiny Tapeout Multiplexer (GF180MCU with Shared SRAM Interface)

[![formal](https://github.com/opilitethesmartdev/tt-multiplexer-common-sram/actions/workflows/formal.yaml/badge.svg)](https://github.com/opilitethesmartdev/tt-multiplexer-common-sram/actions/workflows/formal.yaml)

This repository is a customized fork of the Tiny Tapeout multiplexer targeting the **GF180MCU** process node (`gf180mcuD`).

## Key Modifications

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

2. **Bidirectional User IO Configuration**:
   - Updated the user IO layout so that all general-purpose digital user IO pins (34 total) are **bidirectional** (`uio_in[33:0]`, `uio_out[33:0]`, `uio_oe[33:0]`).
   - Retained 2 dedicated input pins for clock and reset (`clk` and `rst_n`) and 2 analog pins (`ana[1:0]`).
   - Gives user modules complete flexibility to configure any user pin as an input, output, or tristate bidirectional line.

## Overview & Architecture

Curious to learn how the multiplexer works? Read the [explainer](docs/INFO.md) or inspect the top-level implementation in [`rtl/tt_top.v`](rtl/tt_top.v).

## License

See the [LICENSE](LICENSE)
