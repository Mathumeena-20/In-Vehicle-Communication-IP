module bit_destuff (
    input clk,
    input rst_n,
    input in_bit,
    output reg out_bit
);

reg [2:0] count;
reg last_bit;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        last_bit <= 0;
        out_bit <= 0;
    end else begin

        if (in_bit == last_bit)
            count <= count + 1;
        else
            count <= 1;

        // Skip stuffed bit
        if (count == 5) begin
            count <= 0;
        end else begin
            out_bit <= in_bit;
        end

        last_bit <= in_bit;
    end
end

endmodule