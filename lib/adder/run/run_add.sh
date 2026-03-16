#!/bin/bash

mkdir -p build

iverilog -g2012 \
-o build/adder_tb.vvp \
lib/adder/rtl/adder.v \
lib/adder/tb/adder_tb.sv \
utils/tb/tb_utils.sv

vvp build/adder_tb.vvp