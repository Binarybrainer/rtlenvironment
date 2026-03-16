`include "tb_utils.sv"

module multiplexer_tb;

reg a;
reg b;
reg sel;

wire out;

integer i;

multiplexer dut (.*);

// auto dump waveform
`DUMP_WAVE(multiplexer_tb)


task run_random_test;

begin

    for(i=0;i<20;i++) begin

        `RAND_RANGE(a,0,1);
        `RAND_RANGE(b,0,1);
        `RAND_RANGE(sel,0,1);

        #1;
        if (sel == 1) begin
            `ASSERT_EQ(out , b);
        end 
        else begin
            `ASSERT_EQ(out , a);
        end

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