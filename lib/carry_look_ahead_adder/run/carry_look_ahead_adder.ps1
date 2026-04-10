# PowerShell script equivalent of your Bash file

$MODULE = "carry_look_ahead_adder"
$BASE   = "lib/$MODULE"

# Ensure build directory exists
if (-Not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Compile with iverilog
& iverilog -g2012 `
    -o "build/${MODULE}_tb.vvp" `
    "$BASE/rtl/${MODULE}.v" `
    "$BASE/tb/${MODULE}_tb.sv" `
    "utils/tb/tb_utils.sv"

# Run simulation
& vvp "build/${MODULE}_tb.vvp"

# Open waveform in GTKWave
& gtkwave "sim/waveform/${MODULE}_tb.vcd"
