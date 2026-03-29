module tx_fsm (
    input clk,
    input rst_n,
    input start,
    output reg [3:0] state
);

localparam IDLE=0, SOF=1, ARB=2, CTRL=3, DATA=4, CRC=5, ACK=6, EOF=7;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else begin
        case(state)
            IDLE: if (start) state <= SOF;
            SOF:  state <= ARB;
            ARB:  state <= CTRL;
            CTRL: state <= DATA;
            DATA: state <= CRC;
            CRC:  state <= ACK;
            ACK:  state <= EOF;
            EOF:  state <= IDLE;
        endcase
    end
end

endmodule