`include "utils/tb/tb_utils.sv"

module dff_tb;

reg d;
reg clk;
reg rst_n;
reg en;

wire q;

integer i;

dff dut (.*);

// auto dump waveform
`DUMP_WAVE(dff_tb)


task run_clk;
begin
    fork
        forever #5 clk = ~clk;
    join_none
end
endtask

task init_value;
begin
    clk = 0;
    rst_n = 1;
    d = 0;
    en = 1;
end
    
endtask //automatic

task release_reset;
    input integer duration;
begin
    repeat(duration) @(posedge clk);
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
    run_clk();
    release_reset(5);
    run_random_test();

    `TEST_PASS

    `TEST_FINISH

    #10 $finish;

end

endmodule