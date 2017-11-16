## Stay with 240 MHz for now

create_clock -name sys_clk -period 4.167 [get_ports sysclk_in_p]

# FROM UG1224 VCU118 board user guide, chapter 3, section Programmable User Clock 1
set_property IOSTANDARD LVDS [get_ports sysclk_in_p]
set_property IOSTANDARD LVDS [get_ports sysclk_in_n]
set_property PACKAGE_PIN H32 [get_ports sysclk_in_p]
set_property PACKAGE_PIN G32 [get_ports sysclk_in_n]

# FROM UG1224 VCU118 board user guide, chapter 3, section Linear BPI Flash Memory
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property CONFIG_MODE BPI16 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
##set_property CFGBVS GND [current_design] ## not on ultrascale+
set_property CONFIG_VOLTAGE 1.8 [current_design]

# FROM UG899 IO & Clock Planning, chapter 2, "Setting Device Configuration Modes"
# keep configuration pin reserved for configuration
set_property BITSTREAM.CONFIG.PERSIST YES [current_design]

# Table 3-29 of UG1224 VCU118 board user guide
# Also /Vivado/2016.4/data/boards/board_files/vcu118/1.0/part0_pins.xml
set_property IOSTANDARD LVCMOS12 [get_ports {leds[*]}]
set_property PACKAGE_PIN AY30 [get_ports {leds[0]}]
set_property PACKAGE_PIN BB32 [get_ports {leds[1]}]
# push-button SW 10 pin GPIO_SW_N
set_property IOSTANDARD LVCMOS18 [get_ports rst_in]
set_property PACKAGE_PIN BB24 [get_ports rst_in]
#set_false_path -from rst_in -to rst_tmp

