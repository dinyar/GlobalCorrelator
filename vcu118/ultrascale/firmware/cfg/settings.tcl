set obj [get_projects top]
set_property "default_lib" "xil_defaultlib" $obj
set_property "simulator_language" "Mixed" $obj
set_property "source_mgmt_mode" "DisplayOnly" $obj
set_property "target_language" "VHDL" $obj
set_property "board_part" "xilinx.com:vcu118:part0:1.0" $obj
