

 * External User IOs & SRAM Interface :

   - 34 Bidirectional IOs (`uio[33:0]`)
   -  2 Dedicated inputs for clock and reset (`clk` and `rst_n`)
   -  2 Analog pins (`ana[1:0]`)
   - Shared 512x32 SRAM Interface (`c4m_arrakeen_sram_512x32`):
     . `sram_cs_n` (active low chip select)
     . `sram_we_n` (active low write enable)
     . `sram_wmask[3:0]` (4-bit byte write mask)
     . `sram_addr[8:0]` (9-bit address for 512 entries)
     . `sram_wdata[31:0]` (32-bit write data to SRAM)
     . `sram_rdata[31:0]` (32-bit read data from SRAM)


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
