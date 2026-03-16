#!/bin/bash

mkdir -p build

iverilog -g2012 \
-I utils/tb \
-o build/multiplexer_tb.vvp \
primitives/multiplexer/rtl/multiplexer.v \
primitives/multiplexer/tb/multiplexer_tb.sv \
utils/tb/tb_utils.sv

vvp build/multiplexer_tb.vvp