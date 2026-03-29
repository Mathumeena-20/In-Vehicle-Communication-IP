module can_fd_rx (
    input clk,
    input rst_n,
    input mode_fd,
    input can_rx,

    input [10:0] filter_id,
    input [10:0] mask,

    output reg [10:0] rx_id,
    output reg [63:0] rx_data,
    output reg rx_valid,

    output reg crc_error,
    output reg bit_error,

    output rx_error,
    output rx_success
);

//////////////////////////////////////////
// INTERNAL SIGNALS
//////////////////////////////////////////

reg [7:0] bit_cnt;
reg [1:0] state;

// 🔥 PIPELINE SHIFT REGISTERS
reg [127:0] shift_stage1;
reg [127:0] shift_stage2;

wire destuffed_bit;
wire accept;

//////////////////////////////////////////
// DESTUFF MODULE
//////////////////////////////////////////
bit_destuff destuff_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_bit(can_rx),
    .out_bit(destuffed_bit)
);

//////////////////////////////////////////
// ACCEPTANCE FILTER
//////////////////////////////////////////
acceptance_filter filt_inst (
    .rx_id(rx_id),
    .filter_id(filter_id),
    .mask(mask),
    .accept(accept)
);

//////////////////////////////////////////
// ERROR OUTPUT
//////////////////////////////////////////
assign rx_error   = crc_error | bit_error;
assign rx_success = rx_valid;

//////////////////////////////////////////
// STATES
//////////////////////////////////////////
localparam IDLE = 2'd0,
           RECEIVE = 2'd1,
           DONE = 2'd2;

//////////////////////////////////////////
// PIPELINE SHIFT LOGIC
//////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_stage1 <= 0;
        shift_stage2 <= 0;
    end else if (state == RECEIVE) begin
        shift_stage1 <= {shift_stage1[126:0], destuffed_bit};
        shift_stage2 <= shift_stage1; // 🔥 pipeline stage
    end
end

//////////////////////////////////////////
// MAIN FSM
//////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_cnt <= 0;
        rx_valid <= 0;
        crc_error <= 0;
        bit_error <= 0;
        rx_id <= 0;
        rx_data <= 0;
    end else begin

        case (state)

        //////////////////////////////////////////
        // IDLE
        //////////////////////////////////////////
        IDLE: begin
            rx_valid <= 0;
            bit_cnt <= 0;

            if (destuffed_bit == 0) begin // SOF detect
                state <= RECEIVE;
            end
        end

        //////////////////////////////////////////
        // RECEIVE
        //////////////////////////////////////////
        RECEIVE: begin
            bit_cnt <= bit_cnt + 1;

            // Frame length simplified
            if (bit_cnt == (mode_fd ? 100 : 20)) begin
                state <= DONE;
            end
        end

        //////////////////////////////////////////
        // DONE
        //////////////////////////////////////////
        DONE: begin
            // 🔥 USE PIPELINED DATA
            rx_id   <= shift_stage2[127:117];
            rx_data <= shift_stage2[63:0];

            //////////////////////////////////////
            // SIMPLE CRC CHECK (placeholder)
            //////////////////////////////////////
            if (shift_stage2[20:0] == 0)
                crc_error <= 0;
            else
                crc_error <= 1;

            //////////////////////////////////////
            // BIT ERROR (basic check)
            //////////////////////////////////////
            bit_error <= 0; // can extend later

            //////////////////////////////////////
            // FILTER CHECK
            //////////////////////////////////////
            if (accept && !crc_error)
                rx_valid <= 1;
            else
                rx_valid <= 0;

            state <= IDLE;
        end

        //////////////////////////////////////////
        default: state <= IDLE;

        endcase
    end
end

endmodule