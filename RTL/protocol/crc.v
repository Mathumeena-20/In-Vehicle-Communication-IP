module crc (
    input clk,
    input rst_n,
    input mode_fd,
    input [63:0] data,
    output reg [20:0] crc_out
);

reg [20:0] crc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        crc <= 0;
    else begin
        if (mode_fd)
            crc <= {crc[19:0], data[0]} ^ (crc[20] ? 21'h102899 : 0);
        else
            crc <= {crc[13:0], data[0]} ^ (crc[14] ? 15'h4599 : 0);
    end
end

always @(*) crc_out = crc;

endmodule