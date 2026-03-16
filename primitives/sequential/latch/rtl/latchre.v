module latch (
    input d,
    input rst_n,
    input clk,
    input en,

    output reg q
);

always @(*) begin
    if (rst_n == 1'b0) q = 1'b0;
    else if (en == 1'b1) begin
        q = d;
    end 
    else q = q;
end
endmodule
