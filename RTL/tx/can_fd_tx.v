module can_fd_tx (
    input clk,
    input rst_n,
    input mode_fd,
    input tx_start,
    input [10:0] tx_id,
    input [63:0] tx_data,
    input [5:0] tx_len,
    input [20:0] crc,
    input can_rx,
    input bus_off,

    output can_tx,
    output reg arb_lost,
    output tx_error,
    output tx_success
);

reg [7:0] bit_cnt;
reg [3:0] state;

// 🔥 PIPELINE REGISTERS
reg [63:0] data_stage1, data_stage2;
reg [20:0] crc_stage1, crc_stage2;
reg can_tx_raw;

wire can_tx_stuffed;

localparam IDLE=0, SOF=1, ARB=2, CTRL=3, DATA=4, CRC=5, ACK=6, EOF=7;

//////////////////////////////////////////
// PIPELINE
//////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_stage1 <= 0;
        crc_stage1  <= 0;
    end else if (tx_start) begin
        data_stage1 <= tx_data;
        crc_stage1  <= crc;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_stage2 <= 0;
        crc_stage2  <= 0;
    end else begin
        data_stage2 <= data_stage1;
        crc_stage2  <= crc_stage1;
    end
end

//////////////////////////////////////////
// BIT STUFF
//////////////////////////////////////////
bit_stuff bs_inst (
    .clk(clk),
    .rst_n(rst_n),
    .in_bit(can_tx_raw),
    .out_bit(can_tx_stuffed)
);

assign can_tx = can_tx_stuffed;

//////////////////////////////////////////
// STATUS SIGNALS
//////////////////////////////////////////
assign tx_error   = arb_lost;
assign tx_success = (state == EOF);

//////////////////////////////////////////
// FSM
//////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_cnt <= 0;
        can_tx_raw <= 1;
        arb_lost <= 0;
    end else begin

        arb_lost <= 0;

        if (bus_off) begin
            state <= IDLE;
            can_tx_raw <= 1;
        end else begin

        case(state)

        IDLE: begin
            can_tx_raw <= 1;
            bit_cnt <= 0;
            if (tx_start) state <= SOF;
        end

        SOF: begin
            can_tx_raw <= 0;
            state <= ARB;
            bit_cnt <= 0;
        end

        ARB: begin
            can_tx_raw <= tx_id[10-bit_cnt];

            // arbitration check
            if (can_tx_raw == 1 && can_rx == 0)
                arb_lost <= 1;

            bit_cnt <= bit_cnt + 1;

            if (arb_lost)
                state <= IDLE;
            else if (bit_cnt == 10)
                state <= CTRL;
        end

        CTRL: begin
            can_tx_raw <= mode_fd;
            bit_cnt <= 0;
            state <= DATA;
        end

        DATA: begin
            can_tx_raw <= data_stage2[63-bit_cnt];
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == (mode_fd ? (tx_len*8-1) : 7))
                state <= CRC;
        end

        CRC: begin
            can_tx_raw <= crc_stage2[20-bit_cnt];
            bit_cnt <= bit_cnt + 1;

            if (bit_cnt == (mode_fd ? 20 : 14))
                state <= ACK;
        end

        ACK: state <= EOF;

        EOF: begin
            can_tx_raw <= 1;
            state <= IDLE;
        end

        endcase
        end
    end
end

endmodule