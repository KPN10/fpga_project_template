#!/bin/bash
clear

cd /shared/scripts

project_name="template"
commit_hash=$(git rev-parse HEAD)
major=1
minor=0
patch=0
version="${major}.${minor}.${patch}"

QPATH="/home/developer/quartus_lite/quartus/bin"
export PATH=$PATH:$QPATH

cd ..

if [ ! -f "build_number.txt" ]; then
    build_new=1
    echo 1 > build_number.txt
else
    build_prev=$(cat "build_number.txt")
    build_new=$(($build_prev + 1))
    echo $build_new > build_number.txt
fi

content="\
\`define DEPTH 8\n\
\`define COMMIT_HASH_DEPTH 160\n\
\`define COMMIT_HASH \`COMMIT_HASH_DEPTH'h${commit_hash}\n\
\`define MAJOR \`DEPTH'd${major}\n\
\`define MINOR \`DEPTH'd${minor}\n\
\`define PATCH \`DEPTH'd${patch}\n\
\`define BUILD \`DEPTH'd${build_new}\
"
echo -e $content > hdl_src/project_info.svh

# quartus_sh -t scripts/create_quartus.tcl\
#     -projectname "template"\
#     -family "CYCLONEV"\
#     -device "5CEBA4F23C7"

# quartus_sh -t scripts/create_quartus.tcl\
#     -projectname "template"\
#     -family "CYCLONEIV E"\
#     -device "EP4CE22F17C6"

if [ $1 == "de0_cv" ]; then
    quartus_sh -t scripts/create_quartus.tcl\
        -projectname $project_name\
        -board "de0_cv"
elif [ $1 == "de0_nano" ]; then
    quartus_sh -t scripts/create_quartus.tcl\
        -projectname $project_name\
        -board "de0_nano"
fi

quartus_sh -t scripts/flow.tcl

if [ ! -d "artifacts" ]; then
    mkdir artifacts
fi

cd artifacts
dir_name="${project_name}_${commit_hash}_v${version}_b${build_new}"
if [ ! -d $dir_name ]; then
    mkdir $dir_name
    if [ -d "../output_files" ]; then
        cp -R ../output_files/* $dir_name/
    fi
else
    echo ""
fi

cd ..
cd scripts/
