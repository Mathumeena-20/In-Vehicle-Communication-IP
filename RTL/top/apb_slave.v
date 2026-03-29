module apb_slave (
    input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [7:0] PADDR,
    input [31:0] PWDATA,
    output reg [31:0] PRDATA,

    output reg [31:0] CTRL,
    output reg [31:0] TX_ID,
    output reg [31:0] TX_DATA,
    output reg [31:0] FILTER_ID,
    output reg [31:0] MASK
);

// Write logic
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        CTRL <= 0;
        TX_ID <= 0;
        TX_DATA <= 0;
        FILTER_ID <= 0;
        MASK <= 0;
    end else if (PSEL && PENABLE && PWRITE) begin
        case (PADDR)
            8'h00: CTRL      <= PWDATA;
            8'h08: TX_ID     <= PWDATA;
            8'h0C: TX_DATA   <= PWDATA;
            8'h20: FILTER_ID <= PWDATA;
            8'h24: MASK      <= PWDATA;
        endcase
    end
end

// Read logic
always @(*) begin
    case (PADDR)
        8'h00: PRDATA = CTRL;
        8'h08: PRDATA = TX_ID;
        8'h0C: PRDATA = TX_DATA;
        8'h20: PRDATA = FILTER_ID;
        8'h24: PRDATA = MASK;
        default: PRDATA = 0;
    endcase
end

endmodule