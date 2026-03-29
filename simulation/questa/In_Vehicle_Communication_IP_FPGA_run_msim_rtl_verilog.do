transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/top {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/top/can_fd_top.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/top {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/top/apb_slave.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/tx {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/tx/can_fd_tx.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/rx {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/rx/can_fd_rx.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/interrupt_ctrl.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/error_manager.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/crc.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/bit_stuff.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/bit_destuff.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/protocol {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/protocol/acceptance_filter.v}
vlog  -work work +incdir+D:/VLSI/In-Vehicle\ Communication\ IP\ (CAN\ +\ CAN-FD)/RTL/common {D:/VLSI/In-Vehicle Communication IP (CAN + CAN-FD)/RTL/common/bit_timing.v}

