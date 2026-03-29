module rx_fsm (
    input clk,
    input rst_n,
    input bit_in,
    output reg [3:0] state
);

localparam IDLE=0, RECEIVE=1, DONE=2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else begin
        case(state)
            IDLE: if (bit_in == 0) state <= RECEIVE;
            RECEIVE: state <= DONE;
            DONE: state <= IDLE;
        endcase
    end
end

endmodule