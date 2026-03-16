#!/bin/bash
# primitives/dff/run/run_dff.sh
mkdir -p build

iverilog -g2012 \
-o build/dff_tb.vvp \
primitives/dff/rtl/dff.v \
primitives/dff/tb/dff_tb.sv \
utils/tb/tb_utils.sv

vvp build/dff_tb.vvp
gtkwave sim/waveform/dff_tb.vcd