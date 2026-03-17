`include "utils/tb/tb_utils.sv"

module carry_look_ahead_adder_tb;

parameter WIDTH = 32;

// 1. Signals
reg  [WIDTH-1:0] a, b;
reg  ci;
wire [WIDTH-1:0] sum;
wire co;

// 2. Instantiate module under test (MUT)
carry_look_ahead_adder #(.WIDTH(WIDTH)) uut (
    .a(a),
    .b(b),
    .ci(ci),
    .sum(sum),
    .co(co)
);

// auto dump waveform
`DUMP_WAVE(carry_look_ahead_adder_tb)

integer i;

task run_random_test;

begin

    for(i=0;i<20;i++) begin

        `RAND_RANGE(a,0,10);
        `RAND_RANGE(b,0,10);
        `RAND_RANGE(ci,0,1);

        #1;

        `ASSERT_EQ({co,sum}, a+b+ci);

        `RANDOM_DELAY(5);

    end

end

endtask


initial begin

    `TEST_START

    run_random_test();

    `TEST_PASS

    `TEST_FINISH

    #10 $finish;

end

endmodule