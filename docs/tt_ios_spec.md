

 * Standard Pinout Configuration (`main` branch) :

   - **10 Dedicated Inputs**: `ui[9:0]`
     - These pins are dedicated inputs to the user project. They are multiplexed through the TinyTapeout control logic.
   - **8 Dedicated Outputs**: `uo[7:0]`
     - These pins are dedicated outputs from the user project. They are multiplexed through tristate buffers.
   - **8 Bidirectional I/Os**: `uio[7:0]`
     - These pins can be configured as inputs, outputs, or tristate bidirectional lines by the user project. `uio_oe` controls the output enable.
   - **22 Analog External Pins**: `ana[21:0]`
     - These pins are available for analog functionalities, typically connected to external analog components.
   - **Mux Control Inputs**: Three dedicated inputs (`ctrl_ena`, `ctrl_sel_inc`, `ctrl_sel_rst_n`) are used to control the multiplexer and select the active user design. These are separate from the user-accessible `ui` signals.

 * Shared SRAM Interface (`c4m_arrakeen_sram_512x32`) :
   - `sram_cs_n` (active low chip select)
   - `sram_we_n` (active low write enable)
   - `sram_wmask[3:0]` (4-bit byte write mask)
   - `sram_addr[8:0]` (9-bit address for 512 entries)
   - `sram_wdata[31:0]` (32-bit write data to SRAM)
   - `sram_rdata[31:0]` (32-bit read data from SRAM)


 * Experimental Pinout Configuration (`experimental-all-bidir` branch) :

   - **34 Bidirectional I/Os**: `uio[33:0]`
     - In this experimental configuration, nearly all general-purpose digital pins are made bidirectional, offering maximum flexibility. `uio_oe` controls the output enable.
   - **2 Dedicated Inputs**: `clk` and `rst_n`
     - These pins are dedicated for clock and reset signals.
   - **2 Analog Pins**: `ana[1:0]`
     - These pins are available for analog functionalities.
   - **Mux Control Inputs**: Three dedicated inputs (`ctrl_ena`, `ctrl_sel_inc`, `ctrl_sel_rst_n`) are used to control the multiplexer and select the active user design. These are separate from the user-accessible `ui` signals.

 * Input path ( Controller -> User module ) :

   - Distribution tree

     . Equal number of buffers from root to each module

     . Each stage is a AND gate so we can disable inactive
       branches

     . Disabled modules are guaranteed to have '0' as input
       ( so prefer active low reset !!! ). This means there
       is a buffer right before each user module.

   - Try to match routing between the different lines.

     . If space allows, include guard traces to better match
       the parasitics between each input path

     . Different modules might still get different routing length
       though, so no matching between modules )

   - Probably a vertical "spine" with horizontal branches


 * Output path ( User module -> Controller ) :

   - Using TBUFs

     . Might experiment with a first stage of MUX4 and see in the timing
       how this affect things

     . Output of inactive modules should have no influence on the final
       output (i.e. no assumptions on what the user module outputs)


   - Probably a vertical "spine" with horizontal branches


 * External config :

   - The only function provided by the controller is selecting the active
     design. So no internal clock gen, or reset gen or anything like that.
     Theses are assumed to be provided externally.

   - Config interface is a simple 'rst' / 'inc' 2 wire interface to select the
     active design. (i.e. pulse reset then send 200 pulses to enable design
     #200 for instance).

   - All internal enable signals will be combinatorially derived from the
     selected instance ID. (but still inactive until the 'global enable' line
     is set, see below)

   - External 'global enable' line is also provided to actually enable the
     design when ready


 * Design grids :

    - Let call the 'base' (smallest) design dimensions H x W.
      
      Designs can be 1H or 2H in height
      Designs can be 1W, 2W or 4W in width.

      This should provide between 1x up to 8x the area while still making
      it easy to keep alignement to a grid and keep "routing" lanes clear.

    - Grid size would be something like :

      . 16 designs wide
        (8 left and 8 right of the vertical "spine")

      . 24 designs tall
        (2*12 'distribution blocks')

    - See attached pdf


 * Other :

   - Provide an "enable" signal to the module which tells it if it's the
     active module or not

   - Outside of the controller, but I would have wire `user_clk` and
     `user_clk2` to two IOs, along with a few IOs configured to be GPIO of the
     mgmt core.

     This way if the caravel works fine, we 'jumper' those externaly to the
     pins needed to drive/control the user designs and not require an external
     control uC.
