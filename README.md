# 🚗 CAN + CAN-FD IP Core Documentation

📡 Verilog | FPGA | Automotive Communication

---

## 📑 Table of Contents

* Introduction
* Features
* Technologies
* Architecture
* Quickstart
* Documentation
* Results
* Project Structure
* Conclusion

---

## 📖 Introduction

The **CAN + CAN-FD IP Core** is a Verilog RTL project that implements a high-performance Controller Area Network (CAN) and CAN-FD protocol with an integrated APB interface.

This design enables reliable communication between embedded processors and automotive nodes, supporting both classical CAN and high-speed CAN-FD modes.

The project demonstrates a complete **VLSI front-end flow**, including:

* RTL Design
* Simulation (ModelSim)
* Synthesis & Timing Analysis (Quartus)
* FPGA Implementation

---

## ✨ Features

The CAN-FD Controller provides the following features:

⚡ APB Protocol Support (Register Read/Write)

🚗 CAN & CAN-FD Frame Support

🔁 Transmitter & Receiver (Full Communication)

📦 FIFO-based Data Handling

🔄 Bit Stuffing & De-stuffing

🧮 CRC Generation & Checking

⚖️ Arbitration Handling

⚠️ Error Management System

* Bit Error
* CRC Error
* Form Error
* ACK Error

📊 Error Counters (TEC / REC)

🧩 Acceptance Filtering

🔔 Interrupt Generation

🧠 Pipelined Design for High Performance

---

## 🛠️ Technologies

Technologies used in this project:

* **Language:** Verilog HDL
* **Simulation:** ModelSim
* **Synthesis & FPGA:** Quartus Prime Lite
* **Target Device:** Cyclone V

---

==================== CAN-FD IP CORE ====================

```
            +----------------------------------+
            |          APB INTERFACE           |
            |     (Configuration & Control)    |
            +----------------+-----------------+
                             |
    ---------------------------------------------------------
    |                         |                            |
    v                         v                            v


+--------------------+   +--------------------+   +----------------------+
|    TX SUBSYSTEM    |   |   COMMON BLOCKS    |   |    RX SUBSYSTEM      |
+--------------------+   +--------------------+   +----------------------+

| - Frame Generator  |   | - FIFO             |   | - Frame Decoder      |
| - Arbitration      |   | - Bit Timing       |   | - Bit Destuffing     |
| - Bit Stuffing     |   | - Clock Sync       |   | - CRC Checker        |
| - CRC Generator    |   |                    |   | - Acceptance Filter  |
| - TX Control FSM   |   |                    |   | - RX Control FSM     |


    |                         |                            |
    ---------------------------------------------------------
                             |
                             v
                +----------------------------+
                |     ERROR MANAGEMENT       |
                |   (TEC, REC, Bus State)    |
                +-------------+--------------+
                              |
                              v
                +----------------------------+
                |     INTERRUPT CONTROL      |
                |   (TX / RX / ERROR IRQ)    |
                +-------------+--------------+
                              |
                              v
                             IRQ

              ===== CAN BUS INTERFACE =====
                  can_tx       can_rx
```


## 🧠 Architecture

### 🏗️ System Overview

The design consists of the following major blocks:

* **APB Slave Interface**
  Handles configuration and register access

* **CAN-FD TX (Transmitter)**
  Frame generation, arbitration, CRC, bit stuffing

* **CAN-FD RX (Receiver)**
  Frame decoding, de-stuffing, CRC check

* **Protocol Blocks**

  * Arbitration
  * Bit Stuffing / De-stuffing
  * CRC
  * Error Handling

* **Common Blocks**

  * FIFO
  * Bit Timing

* **Error Manager**
  Maintains TEC/REC counters and bus state

* **Interrupt Controller**
  Generates interrupts for TX/RX/Error events

---

### FSM Design

## CAN TX FSM

<img width="750" height="484" alt="Screenshot 2026-03-30 145736" src="https://github.com/user-attachments/assets/c0c34531-c81e-404b-afb6-b28c928164c5" />

<img width="1022" height="591" alt="Screenshot 2026-03-30 145816" src="https://github.com/user-attachments/assets/3d7c59f1-16a8-4350-a8fc-d3c876544916" />

## 🔄 Transmission FSM Overview

This diagram represents the frame transmission flow with collision handling.

- **Initial → IFG → Idle**  
  System waits and prepares for transmission.

- **PRE → SFD → Data → Pad → FCS**  
  Frame is transmitted step-by-step:
  - Preamble (sync)
  - Start of Frame
  - Data
  - Padding (if needed)
  - CRC (error check)

- **Collision Handling (Jam & Retry)**  
  If a collision occurs:
  - Jam signal is sent
  - Transmission is retried

- **Success / Fail**
  - Success → Move to next packet  
  - Fail → Return to initial state  

This FSM ensures reliable data transmission with error detection and recovery.

---

## 🚀 Bit Timing & Mathematical Modeling 

# 🚗 🧠 STEP 1: ASSUMPTIONS (YOUR DESIGN)

From your project:

* System clock ( f_{clk} ) = **100 MHz** *(typical in FPGA unless you changed it)*
* You want CAN speeds like:

  * Classical CAN → **500 kbps**
  * CAN-FD → **2 Mbps / 5 Mbps**

---

# 🚗 🧠 STEP 2: BIT RATE EQUATION

\text{Bit Rate} = \frac{f_{clk}}{BRP \times (SyncSeg + PropSeg + PhaseSeg1 + PhaseSeg2)}

---

# 🚗 🧠 STEP 3: DEFINE SEGMENTS (STANDARD VALUES)

Typical CAN configuration:

| Segment   | Value |
| --------- | ----- |
| SyncSeg   | 1     |
| PropSeg   | 2     |
| PhaseSeg1 | 4     |
| PhaseSeg2 | 3     |

👉 Total:

```text
Total TQ = 1 + 2 + 4 + 3 = 10
```

---

# 🚗 🧠 STEP 4: CALCULATE FOR 500 kbps

We use:

```text
Bit Rate = 500,000
Clock = 100,000,000
Total TQ = 10
```

---

## Solve for BRP:

BRP = \frac{f_{clk}}{BitRate \times TQ}

---

### Substitute:

```text
BRP = 100,000,000 / (500,000 × 10)
BRP = 100,000,000 / 5,000,000
BRP = 20
```

---

# 🚗 ✅ RESULT (CLASSICAL CAN)

```text
BRP = 20
TQ = 10
Bit Rate = 500 kbps
```

---

# 🚗 🧠 STEP 5: CALCULATE FOR 2 Mbps (CAN-FD)

```text
Bit Rate = 2,000,000
```

---

### Calculate BRP:

```text
BRP = 100,000,000 / (2,000,000 × 10)
BRP = 100,000,000 / 20,000,000
BRP = 5
```

---

# 🚗 ✅ RESULT (CAN-FD)

```text
BRP = 5
TQ = 10
Bit Rate = 2 Mbps
```

---

# 🚗 🧠 STEP 6: TIME QUANTA VALUE

TQ = \frac{BRP}{f_{clk}}

---

### Example (500 kbps):

```text
TQ = 20 / 100 MHz = 200 ns
Bit Time = 200 ns × 10 = 2 µs
```

---

# 🚗 🧠 STEP 7: SAMPLE POINT (VERY IMPORTANT)

```text
Sample Point = (SyncSeg + PropSeg + PhaseSeg1) / Total
             = (1 + 2 + 4) / 10
             = 70%
```

👉 Ideal range:

```text
60% – 80% ✅
```

---

# 🚀 🔥 FINAL VALUES (YOUR DESIGN)

| Mode   | BRP | TQ | Bit Rate |
| ------ | --- | -- | -------- |
| CAN    | 20  | 10 | 500 kbps |
| CAN-FD | 5   | 10 | 2 Mbps   |

---

# 🚀 🔥 HOW TO USE IN YOUR RTL

In `bit_timing.v`:

```verilog
parameter BRP = 20;   // for 500 kbps
```

For CAN-FD:

```verilog
parameter BRP = 5;
```
...

## 🚀 Quickstart

Follow these steps to run the project:

### 1️⃣ Clone Repository

```
git clone <your-repo-link>
cd CAN_FD_IP
```

### 2️⃣ Run Simulation (ModelSim)

```
vlib work
vlog RTL/**/*.v TESTBENCH/*.v
vsim apb_can_fd_tb
run -all
```

### 3️⃣ FPGA Implementation (Quartus)

* Add all `.v` files
* Set top module → `can_fd_top`
* Add `constraints.sdc`
* Click **Compile Design**

---

## 📚 Documentation

### 🔄 Data Flow

**Transmission:**

```
APB → TX FIFO → CAN TX → Bus
```

**Reception:**

```
Bus → CAN RX → FIFO → APB
```

---

### ⚙️ Key Modules

| Module              | Function                  |
| ------------------- | ------------------------- |
| can_fd_top.v        | Top-level integration     |
| can_fd_tx.v         | CAN-FD transmitter        |
| can_fd_rx.v         | CAN-FD receiver           |
| error_manager.v     | Error handling & counters |
| bit_stuff.v         | Bit stuffing logic        |
| bit_destuff.v       | Bit de-stuffing           |
| crc.v               | CRC generation/check      |
| arbitration.v       | Bus arbitration           |
| acceptance_filter.v | ID filtering              |
| fifo.v              | Data buffering            |
| bit_timing.v        | Bit timing control        |

---

## 📊 Results

✔ Simulation Successful (ModelSim)

✔ Quartus Compilation Successful

✔ Timing Closure Achieved

✔ FMAX Achieved: ~250 MHz

✔ Resource Utilization: <1%

✔ Error Management Verified

---

## 📁 Project Structure

```
CAN_FD_IP/
 ├── RTL/
 │    ├── top/
 │    ├── tx/
 │    ├── rx/
 │    ├── protocol/
 │    ├── common/
 │
 ├── TESTBENCH/
 ├── UVM/
 ├── output_files/
 ├── constraints.sdc
 └── README.md
```

---

## ⭐ Conclusion

This project demonstrates a complete **CAN-FD IP Core design** with APB integration, making it highly valuable for:

* VLSI RTL Design Roles
* FPGA Development
* Automotive Semiconductor Industry

The design showcases **protocol-level understanding, timing closure, and modular RTL architecture**, aligning with industry standards.

---
