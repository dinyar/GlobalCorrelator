## Stay with 240 MHz for now
# create_clock -name sys_clk -period 4.167 [get_ports sysclk_in_p]
## 40 MHz input clock
create_clock -name sys_clk -period 25 [get_ports sysclk_in_p]
