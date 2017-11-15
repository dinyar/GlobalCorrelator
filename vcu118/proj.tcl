## try non-project mode
set outputDir "test"
file mkdir $outputDir
create_project top $outputDir  -part xcvu9p-flga2104-2L-e-es1 -force
set_property board_part xilinx.com:vcu118:part0:1.0 [current_project]
set_property target_language VHDL [current_project]


add_files dummy_blinker.vhd 
add_files ultra_constants.vhd 
add_files ultra_data_types.vhd 
add_files bram_sdp.vhd 
add_files ultra_buffer.vhd 
add_files null_algo.vhd 
add_files top.vhd  
add_files -fileset sim_1 tb.vhd 
add_files -fileset constrs_1 base.xdc 
add_files -fileset constrs_1 pblocks.tcl 

import_files -force -norecurse

set_property top top [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_runs synth_1
wait_on_run synth_1

#open_run synth_1 -name synth_1
#source pblocks.tcl
