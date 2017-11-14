#!/bin/bash
( rm -r xsim.dir/ || true ) 
for f in ultra_constants.vhd  ultra_data_types.vhd bram_sdp.vhd ultra_buffer.vhd null_algo.vhd dummy_blinker.vhd top.vhd tb.vhd; do 
    xvhdl $f | tee X; grep ERROR X && break;
done | tee xvhdl_sh.log
grep ERROR xvhdl_sh.log && exit 1;
#echo " --- press <return> if the VHDL compilation was ok, <ctrl>-C otherwise." ; read 

xelab testbench -s test && \
xsim test -R
