module error_handler (
    input clk,
    input rst_n,
    input crc_err,
    input bit_err,
    output reg [7:0] TEC,
    output reg [7:0] REC
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        TEC <= 0;
        REC <= 0;
    end else begin
        if (bit_err) TEC <= TEC + 1;
        if (crc_err) REC <= REC + 1;
    end
end

endmodule