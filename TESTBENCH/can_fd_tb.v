module can_fd_tb;

reg clk=0;
always #5 clk=~clk;

reg rst_n;
reg mode_fd;
reg tx_start;

reg [10:0] tx_id;
reg [63:0] tx_data;

wire can_tx;
wire can_rx;

assign can_rx = can_tx;

can_fd_top dut (
    .clk(clk),
    .rst_n(rst_n),
    .mode_fd(mode_fd),
    .brs_enable(1),
    .tx_start(tx_start),
    .tx_id(tx_id),
    .tx_data(tx_data),
    .tx_len(8),
    .rx_id(),
    .rx_data(),
    .rx_valid(),
    .can_tx(can_tx),
    .can_rx(can_rx)
);

initial begin
    rst_n=0;
    #20 rst_n=1;

    // CAN
    mode_fd=0;
    tx_id=11'h123;
    tx_data=64'hAABBCCDD;
    tx_start=1;
    #10 tx_start=0;

    // CAN-FD
    #200;
    mode_fd=1;
    tx_start=1;
    #10 tx_start=0;

    #1000 $finish;
end

endmodule