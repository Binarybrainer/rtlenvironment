#!/bin/bash

mkdir -p build

iverilog -g2012 \
-I utils/tb \
-o build/adder_tb.vvp \
primitives/adder/rtl/adder.v \
primitives/adder/tb/adder_tb.sv \
utils/tb/tb_utils.sv

vvp build/adder_tb.vvp