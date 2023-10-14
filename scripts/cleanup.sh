#!/bin/bash

remove_dir() {
    if [ -d $1 ]; then
        rm -dR $1
    fi
}

remove_file() {
    if [ -f $1 ]; then
        rm -f $1
    fi
}

remove_files() {
    find . -name "$1" -type f -delete
}

cd ..
remove_dir "db"
remove_dir "incremental_db"
remove_dir ".qsys_edit"
remove_dir "output_files"
remove_dir "artifacts"
remove_files "*.txt"
remove_file "*.qws"
remove_file "*.qdf"
remove_file "*.qpf"
remove_file "*.qsf"
remove_file "hdl_src/project_info.svh"
