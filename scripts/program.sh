#!/bin/bash

cd /shared/scripts
QPATH="/home/developer/quartus_lite/quartus/bin"
export PATH=$PATH:$QPATH

blaster_list=$(jtagconfig)
echo $blaster_list

if [ $1 == "de0_cv" ]; then
    CABLE_NAME=1
elif [ $1 == "de0_nano" ]; then
    CABLE_NAME=2
fi

quartus_pgm -c $CABLE_NAME -z --mode=JTAG --operation="p;../output_files/template.sof"
# quartus_pgm -z --mode=JTAG --operation="p;../output_files/template.sof"
