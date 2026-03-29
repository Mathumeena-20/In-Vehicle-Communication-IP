create_clock -name clk -period 10.0 [get_ports clk]

create_clock -name PCLK -period 20.0 [get_ports PCLK]

create_generated_clock -name bit_clk \
-source [get_ports clk] \
[get_pins bit_timing|bit_clk]