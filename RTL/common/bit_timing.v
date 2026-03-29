module bit_timing (
    input clk,
    input rst_n,
    output reg bit_clk
);

parameter DIV = 10;
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        bit_clk <= 0;
    end else begin
        if (cnt == DIV-1) begin
            cnt <= 0;
            bit_clk <= ~bit_clk;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule