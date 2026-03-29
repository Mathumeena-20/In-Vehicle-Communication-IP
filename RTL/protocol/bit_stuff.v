module bit_stuff (
    input clk,
    input rst_n,
    input in_bit,
    output reg out_bit
);

reg [2:0] count;
reg last;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
        last <= 0;
    end else begin
        if (in_bit == last)
            count <= count + 1;
        else
            count <= 1;

        if (count == 5) begin
            out_bit <= ~in_bit;
            count <= 0;
        end else begin
            out_bit <= in_bit;
        end

        last <= in_bit;
    end
end

endmodule