`include "primitives/arithmetic/full_adder/rtl/full_adder.v"

module carry_look_ahead_adder #(
    parameter WIDTH = 32
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  ci,

    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] P,
    output [WIDTH:0] C,
    output co
);

genvar i;

wire [WIDTH-1:0] G;
wire [WIDTH-1:0] P;
wire [WIDTH:0]   C;

assign G = a & b;
assign P = a ^ b;

assign C[0] = ci;

generate
    for(i=0;i<WIDTH;i=i+1) begin : ADD
        assign C[i+1] = G[i] | (P[i] & C[i]);
        assign sum[i] = P[i] ^ C[i];
    end
endgenerate

assign co = C[WIDTH];

endmodule