#!/bin/bash

MODULE=half_adder
BASE=primitives/arithmetic/$MODULE

mkdir -p build

iverilog -g2012 \
-o build/${MODULE}_tb.vvp \
$BASE/rtl/${MODULE}.v \
$BASE/tb/${MODULE}_tb.sv \
utils/tb/tb_utils.sv

vvp build/${MODULE}_tb.vvp