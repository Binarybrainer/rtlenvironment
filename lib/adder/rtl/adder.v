`include "primitives/full_adder/rtl/full_adder.v"

module adder #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input ci,

    output [WIDTH-1:0] sum,
    output wire co
);
genvar i;

wire [WIDTH-1:0] cin; 
wire [WIDTH-1:0] cout;

generate
    for(i=0;i<WIDTH;i=i+1) begin : ADD
        full_adder u_adder (
            .a  (a[i]),
            .b  (b[i]),
            .cin(cin[i]),
            .sum (sum[i]),
            .cout(cout[i])
        );
    end
endgenerate

assign cin[0] = ci;
assign co = cout[WIDTH-1];
assign cin[WIDTH-1:1] = cout[WIDTH-2:0];
endmodule