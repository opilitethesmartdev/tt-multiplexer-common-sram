#!/usr/bin/env python3

#
# Generate a dummy config for the format tests filling
# all slots with the same module
#
# Copyright (c) 2023 Matt Venn <matt@mattvenn.net>
# Copyright (c) 2023 Sylvain Munaut <tnt@246tNt.com>
# SPDX-License-Identifier: Apache-2.0
#

import argparse
import tt

parser = argparse.ArgumentParser()
parser.add_argument("--module")
args = parser.parse_args()

cfg = tt.TinyTapeout.get_config()

print("modules:")
for x in range(cfg.tt.grid.x):
    for y in range(cfg.tt.grid.y):
        print(f'  - name: "{args.module}"')
        print(f'    pg_vdd: false')
