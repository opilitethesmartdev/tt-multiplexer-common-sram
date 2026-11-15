// Compatibility source-list shim for hackclub-asic-pg.
//
// The GF180 pad-to-multiplexer mapping is implemented by
// ol2/tt_top/tt_gf_wrapper.v. Older project build lists still include
// rtl/tt_gf_gpio.v, so preserve that source path while forwarding the
// current generic GPIO implementation and behavioural shared-SRAM model.

`include "tt_gpio.v"
`include "c4m_arrakeen_sram_512x32.v"
