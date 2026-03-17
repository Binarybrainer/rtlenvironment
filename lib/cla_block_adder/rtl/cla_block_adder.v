`include "lib/carry_look_ahead_adder/rtl/carry_look_ahead_adder.v"

module cla_block_adder #(
    parameter BLOCK = 8,
    parameter BLOCK_SIZE = 4,
    parameter WIDTH = BLOCK*BLOCK_SIZE
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  ci,

    output [WIDTH-1:0] sum,
    output co
);

genvar i;

wire [BLOCK-1:0] GP;
wire [BLOCK-1:0] GG;
wire [BLOCK:0] C;

wire [WIDTH-1:0] P;

assign P = a ^ b;

assign C[0] = ci;

generate
    for(i=0;i<BLOCK;i=i+1) begin : ADD
        assign GP[i] = &P[BLOCK_SIZE*i+BLOCK_SIZE-1:BLOCK_SIZE*i];
        assign C[i+1] = GG[i] | (GP[i] & C[i]);

        carry_look_ahead_adder #(.WIDTH(4)) uut (
            .a(a[BLOCK_SIZE*i+BLOCK_SIZE-1:BLOCK_SIZE*i]),
            .b(b[BLOCK_SIZE*i+BLOCK_SIZE-1:BLOCK_SIZE*i]),
            .ci(C[i]),
            .sum(sum[BLOCK_SIZE*i+BLOCK_SIZE-1:BLOCK_SIZE*i]),
            .co(GG[i])
        );
    end

    
endgenerate

assign co = C[BLOCK];

endmodule