#!/bin/bash

image_name="quartus_lite_22.1std"
workspace_path="/mnt/developing/workspace/fpga_project_template"
qpath="/home/developer/quartus_lite/quartus/bin"

# docker run\
#     --rm -v /sys:/sys:ro -v $workspace_path:/shared -v /tmp/.X11-unix:/tmp/.X11-unix\
#     -e DISPLAY -e "QT_X11_NO_MITSHM=1"\
#     --privileged -v /dev/bus/usb:/dev/bus/usb quartus_lite_22.1std

docker run\
    -v $workspace_path:/shared\
    -i -t\
    --rm\
    $image_name\
    /bin/bash /shared/scripts/build.sh de0_cv

docker run\
    -v $workspace_path:/shared\
    -i -t\
    --rm\
    --privileged -v /dev/bus/usb:/dev/bus/usb\
    $image_name\
    /bin/bash /shared/scripts/program.sh de0_cv
