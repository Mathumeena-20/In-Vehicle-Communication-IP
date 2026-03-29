module arbitration (
    input clk,
    input rst_n,
    input tx_bit,
    input rx_bit,
    output reg lost
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        lost <= 0;
    else begin
        if (tx_bit == 1 && rx_bit == 0)
            lost <= 1;   // lost arbitration
        else
            lost <= 0;
    end
end

endmodule