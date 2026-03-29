module error_manager (
    input clk,
    input rst_n,

    // From TX/RX
    input tx_error,
    input rx_error,
    input tx_success,
    input rx_success,

    // Outputs
    output reg [7:0] TEC,
    output reg [7:0] REC,
    output reg error_passive,
    output reg bus_off
);

//////////////////////////////////////////
// COUNTER LOGIC (CAN STANDARD STYLE)
//////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        TEC <= 0;
        REC <= 0;
    end else begin

        // ---------------- TX ERROR ----------------
        if (tx_error) begin
            if (TEC <= 248)
                TEC <= TEC + 8;   // TX errors increment fast
            else
                TEC <= 255;
        end
        else if (tx_success && TEC > 0) begin
            TEC <= TEC - 1;
        end

        // ---------------- RX ERROR ----------------
        if (rx_error) begin
            if (REC < 255)
                REC <= REC + 1;
        end
        else if (rx_success && REC > 0) begin
            REC <= REC - 1;
        end
    end
end

//////////////////////////////////////////
// STATE LOGIC
//////////////////////////////////////////
always @(*) begin
    error_passive = (TEC >= 128) || (REC >= 128);
    bus_off       = (TEC >= 255);
end

endmodule