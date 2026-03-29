module can_fd_top (

    input clk,
    input rst_n,

    // ---------------- APB ----------------
    input PCLK,
    input PRESETn,
    input PSEL,
    input PENABLE,
    input PWRITE,
    input [7:0] PADDR,
    input [31:0] PWDATA,
    output [31:0] PRDATA,

    // ---------------- CAN BUS ----------------
    output can_tx,
    input  can_rx,

    // ---------------- INTERRUPT ----------------
    output irq
);

//////////////////////////////////////////////////
// APB REGISTERS
//////////////////////////////////////////////////
wire [31:0] CTRL, TX_ID, TX_DATA, FILTER_ID, MASK;

apb_slave apb (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .CTRL(CTRL),
    .TX_ID(TX_ID),
    .TX_DATA(TX_DATA),
    .FILTER_ID(FILTER_ID),
    .MASK(MASK)
);

//////////////////////////////////////////////////
// CONTROL SIGNALS
//////////////////////////////////////////////////
wire mode_fd  = CTRL[1];
wire tx_start = CTRL[0];

wire [10:0] tx_id = TX_ID[10:0];

// 🔥 FIX: Extend to 64-bit
wire [63:0] tx_data = {32'b0, TX_DATA};

//////////////////////////////////////////////////
// BIT TIMING
//////////////////////////////////////////////////
wire bit_clk;

bit_timing bt (
    .clk(clk),
    .rst_n(rst_n),
    .bit_clk(bit_clk)
);

//////////////////////////////////////////////////
// CRC
//////////////////////////////////////////////////
wire [20:0] crc_val;

crc crc_inst (
    .clk(bit_clk),
    .rst_n(rst_n),
    .mode_fd(mode_fd),
    .data(tx_data),
    .crc_out(crc_val)
);

//////////////////////////////////////////////////
// TX SIGNALS
//////////////////////////////////////////////////
wire tx_error, tx_success;
wire arb_lost;

//////////////////////////////////////////////////
// RX SIGNALS
//////////////////////////////////////////////////
wire rx_error, rx_success;
wire [10:0] rx_id;
wire [63:0] rx_data;
wire rx_valid;

//////////////////////////////////////////////////
// ERROR MANAGEMENT
//////////////////////////////////////////////////
wire [7:0] TEC, REC;
wire error_passive, bus_off;

error_manager err_mgr (
    .clk(clk),
    .rst_n(rst_n),

    .tx_error(tx_error),
    .rx_error(rx_error),
    .tx_success(tx_success),
    .rx_success(rx_success),

    .TEC(TEC),
    .REC(REC),

    .error_passive(error_passive),
    .bus_off(bus_off)
);

//////////////////////////////////////////////////
// TX MODULE
//////////////////////////////////////////////////
can_fd_tx tx (
    .clk(bit_clk),
    .rst_n(rst_n),
    .mode_fd(mode_fd),
    .tx_start(tx_start),
    .tx_id(tx_id),
    .tx_data(tx_data),

    // 🔥 FIX: proper width
    .tx_len(6'd8),

    .crc(crc_val),
    .can_rx(can_rx),
    .bus_off(bus_off),

    .can_tx(can_tx),
    .arb_lost(arb_lost),
    .tx_error(tx_error),
    .tx_success(tx_success)
);

//////////////////////////////////////////////////
// RX MODULE
//////////////////////////////////////////////////
can_fd_rx rx (
    .clk(bit_clk),
    .rst_n(rst_n),
    .mode_fd(mode_fd),
    .can_rx(can_rx),

    .filter_id(FILTER_ID[10:0]),
    .mask(MASK[10:0]),

    .rx_id(rx_id),
    .rx_data(rx_data),
    .rx_valid(rx_valid),

    .crc_error(),
    .bit_error(),

    .rx_error(rx_error),
    .rx_success(rx_success)
);

//////////////////////////////////////////////////
// INTERRUPT LOGIC
//////////////////////////////////////////////////
interrupt_ctrl intr (
    .clk(clk),
    .rst_n(rst_n),
    .tx_done(tx_success),
    .rx_done(rx_valid),
    .error(error_passive | bus_off),
    .irq(irq)
);

endmodule