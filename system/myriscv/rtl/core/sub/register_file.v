module register_file(
    input clk,

    input [4:0] rs1_address,
    input [4:0] rs2_address,
    input [4:0] rd_address,
    input [31:0] rd_data,

    input REGctrl,
    
    output [31:0] rs1_data,
    output [31:0] rs2_data
);

reg [31:0] register_file0;
reg [31:0] register_file [1:31];
wire write_en;

always @(posedge clk) begin
    if (write_en & rd_address != 5'b0) begin
        register_file[rd_address] <= rd_data; 
    end
end

assign write_en = REGctrl;

assign rs1_data = (rd_address == 5'b0) ? 32'b0 : register_file[rs1_address];
assign rs2_data = (rd_address == 5'b0) ? 32'b0 : register_file[rs2_address];

// assign register_file0 = 32'b0;

endmodule