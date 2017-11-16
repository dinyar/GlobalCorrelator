##set_property CFGBVS GND [current_design] ## not on ultrascale+
set_property CONFIG_VOLTAGE 1.8 [current_design]

# FROM UG899 IO & Clock Planning, chapter 2, "Setting Device Configuration Modes"
# keep configuration pin reserved for configuration
set_property BITSTREAM.CONFIG.PERSIST YES [current_design]
