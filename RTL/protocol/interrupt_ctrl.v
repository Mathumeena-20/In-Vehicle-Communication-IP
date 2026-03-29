module interrupt_ctrl (
    input clk,
    input rst_n,
    input tx_done,
    input rx_done,
    input error,

    output reg irq
);

reg [2:0] int_status;
reg [2:0] int_enable = 3'b111;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        int_status <= 0;
    else begin
        if (tx_done) int_status[0] <= 1;
        if (rx_done) int_status[1] <= 1;
        if (error)   int_status[2] <= 1;
    end
end

always @(*) begin
    irq = |(int_status & int_enable);
end

endmodule