#
# OpenDB script for custom IO placement for tt_mux
#
# Copyright (c) 2023 Sylvain Munaut <tnt@246tNt.com>
# SPDX-License-Identifier: Apache-2.0
#

import os
import sys

sys.path.append('../../py')
import tt
import tt_odb

import click

from reader import click_odb


@click.command()
@click_odb
def io_place(
	reader,
):

	# Load TinyTapeout
	ti = tt.TinyTapeout(modules=False)

	# Terminal name mapping
	bterm_map = {b.getName(): b for b in reader.block.getBTerms()}

	# Find die, layers, and the PDK's manufacturing grid
	die_area = reader.block.getDieArea()
	layer_ns = reader.tech.findLayer(tti.cfg.tt.spine.vlayer)
	layer_we = reader.tech.findLayer(tti.cfg.tt.spine.hlayer)
	manufacturing_grid = reader.tech.getManufacturingGrid()

	# User block bottom
	for pn, pp in tti.layout.ply_mux_bot.items():
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn), pp, 'S', manufacturing_grid=manufacturing_grid)

	# User block top
	for pn, pp in tti.layout.ply_mux_top.items():
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn), pp, 'N', manufacturing_grid=manufacturing_grid)

	# H spine
	for pn, pp in tti.layout.ply_mux_port.items():
		tt_odb.place_pin(die_area, layer_we, bterm_map.pop(pn), pp, 'E', manufacturing_grid=manufacturing_grid)

	# Place any remaining unplaced pins
	if bterm_map:
		remaining = list(bterm_map.items())
		step = (die_area.yMax() - die_area.yMin()) // (len(remaining) + 1)
		y = die_area.yMin() + step
		for name, bterm in remaining:
			tt_odb.place_pin(die_area, layer_we, bterm_map.pop(name), y, 'W', manufacturing_grid=manufacturing_grid)
			y += step

if __name__ == "__main__":
	io_place()
