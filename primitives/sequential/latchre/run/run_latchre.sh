#!/bin/bash

MODULE=latchre
BASE=primitives/sequential/$MODULE

mkdir -p build
echo -e "\033[32mRunning $MODULE test...\033[0m"
iverilog -g2012 \
-o build/${MODULE}_tb.vvp \
$BASE/rtl/${MODULE}.v \
$BASE/tb/${MODULE}_tb.sv \
utils/tb/tb_utils.sv

vvp build/${MODULE}_tb.vvp

gtkwave sim/waveform/latch_tb.vcd