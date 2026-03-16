`ifndef TB_UTILS_SV
`define TB_UTILS_SV

// ======================================================
// Test start / end
// ======================================================

`define TEST_START \
    $display("===================================="); \
    $display("TEST START: %m"); \
    $display("TIME: %0t", $time); \
    $display("====================================");

`define TEST_FINISH \
    $display("===================================="); \
    $display("TEST FINISH: %m"); \
    $display("TIME: %0t", $time); \
    $display("====================================");


// ======================================================
// Waveform dump
// ======================================================

`define DUMP_WAVE(top) \
initial begin \
    $dumpfile({"sim/waveform/", `"top`", ".vcd"}); \
    $dumpvars(0, top); \
end


// ======================================================
// Assertions
// ======================================================

`define ASSERT_EQ(actual,expected) \
    if ((actual) !== (expected)) begin \
        $error("[ASSERT_EQ FAIL] time=%0t actual=%0d expected=%0d", \
        $time,actual,expected); \
    end


`define ASSERT_NEQ(a,b) \
    if ((a) === (b)) begin \
        $error("[ASSERT_NEQ FAIL] time=%0t value=%0d", \
        $time,a); \
    end


// ======================================================
// Random helper
// ======================================================

`define RAND_RANGE(var,min,max) \
    var = $urandom_range(max,min)


// ======================================================
// Delay helper
// ======================================================

`define RANDOM_DELAY(max) \
    #($urandom_range(max))


// ======================================================
// Test pass
// ======================================================

`define TEST_PASS \
    $display("******** TEST PASS ********");


// ======================================================
// Test fail
// ======================================================

`define TEST_FAIL \
    begin \
        $display("******** TEST FAIL ********"); \
        $finish; \
    end


`endif