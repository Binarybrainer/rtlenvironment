module dff (
    input d,
    input rst_n,
    input clk,
    input en,

    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) q <= 1'b0;
    else if (en == 1'b1) begin
        q <= d;
    end 
    else q <= q;
end
endmodule
