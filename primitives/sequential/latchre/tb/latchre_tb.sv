`include "utils/tb/tb_utils.sv"

module latch_tb;

reg d;
reg rst_n;
reg en;

wire q;

integer i;

latchre dut (
    .d(d),
    .en(en),
    .q(q),
    .rst_n(rst_n)
);

// auto dump waveform
`DUMP_WAVE(latch_tb)


task run_en;
begin
    fork
        forever #5 en = ~en;
    join_none
end
endtask

task init_value;
begin
    rst_n = 1;
    d = 0;
    en = 1;
end
    
endtask //automatic

task release_reset;
    input integer duration;
begin
    repeat(duration) @(posedge en);
    rst_n = 1;
end
endtask

task run_random_test;
begin

    for(i=0;i<20;i++) begin

        `RAND_RANGE(d,0,1);

        `RANDOM_DELAY(5);

    end

end

endtask


initial begin

    `TEST_START

    init_value();
    run_en();
    release_reset(5);
    run_random_test();

    `TEST_PASS

    `TEST_FINISH

    #10 $finish;

end

endmodule