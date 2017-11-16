# All taken from Appendix A of UG1260: KCU1500 user guide

# 300 MHz SYSCLK0
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysclk_in_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports sysclk_in_n]
set_property PACKAGE_PIN BA34 [get_ports sysclk_in_p]
set_property PACKAGE_PIN BB34 [get_ports sysclk_in_n]

# Appendix A of UG1260: KCU1500 user guide
set_property IOSTANDARD LVCMOS18 [get_ports {leds[*]}]
set_property PACKAGE_PIN AW25 [get_ports {leds[0]}]
set_property PACKAGE_PIN AY25 [get_ports {leds[1]}]
# push-button 
set_property IOSTANDARD LVCMOS18 [get_ports rst_in]
set_property PACKAGE_PIN BE26 [get_ports rst_in]
