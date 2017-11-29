## Stay with 240 MHz for now (need to adjust MMCM if we change the input frequency here)
create_clock -name sys_clk -period 4.167 [get_ports sysclk_in_p]
