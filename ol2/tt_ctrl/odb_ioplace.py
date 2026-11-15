#
# OpenDB script for custom IO placement for tt_ctrl
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
	tti = tt.TinyTapeout(modules=False)

	# Terminal name mapping
	bterm_map = {b.getName(): b for b in reader.block.getBTerms()}

	# Find die, layers, and the PDK's manufacturing grid
	die_area = reader.block.getDieArea()
	layer_ns = reader.tech.findLayer(tti.cfg.tt.spine.vlayer)
	layer_we = reader.tech.findLayer(tti.cfg.tt.spine.hlayer)
	manufacturing_grid = reader.tech.getManufacturingGrid()

	# Vertical spine
	for pn, pp in tti.layout.ply_ctrl_vspine.items():
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn.replace('spine','spine_top')), pp, 'N', manufacturing_grid=manufacturing_grid)
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn.replace('spine','spine_bot')), pp, 'S', manufacturing_grid=manufacturing_grid)

	# IO Top
	for pn, pp in tti.layout.ply_ctrl_io_top.items():
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn), pp, 'N', manufacturing_grid=manufacturing_grid)

	# IO Bottom
	for pn, pp in tti.layout.ply_ctrl_io_bot.items():
		tt_odb.place_pin(die_area, layer_ns, bterm_map.pop(pn), pp, 'S', manufacturing_grid=manufacturing_grid)

	# Place any remaining unplaced pins (e.g. SRAM pins)
	if bterm_map:
		remaining = list(bterm_map.items())
		step = (die_area.yMax() - die_area.yMin()) // (len(remaining) + 1)
		y = die_area.yMin() + step
		for name, bterm in remaining:
			tt_odb.place_pin(die_area, layer_we, bterm_map.pop(name), y, 'E', manufacturing_grid=manufacturing_grid)
			y += step


if __name__ == "__main__":
	io_place()
