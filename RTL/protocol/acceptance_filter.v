module acceptance_filter (
    input [10:0] rx_id,
    input [10:0] filter_id,
    input [10:0] mask,
    output accept
);

assign accept = ((rx_id & mask) == (filter_id & mask));

endmodule
