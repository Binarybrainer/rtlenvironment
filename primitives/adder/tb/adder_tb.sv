`include "tb_utils.sv"

module adder_tb;

reg a;
reg b;
reg cin;

wire sum;
wire cout;

integer i;

adder dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

// auto dump waveform
`DUMP_WAVE(adder_tb)


task run_random_test;

begin

    for(i=0;i<20;i++) begin

        `RAND_RANGE(a,0,1);
        `RAND_RANGE(b,0,1);
        `RAND_RANGE(cin,0,1);

        #1;

        `ASSERT_EQ({cout,sum}, a+b+cin);

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