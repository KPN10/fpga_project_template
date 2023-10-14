package require cmdline
package require ::quartus::project

set parameters {
    {projectname.arg "" "Project Name"}
    {family.arg "" "FPGA Family"}
    {device.arg "" "FPGA Device"}
    {board.arg "" "Dev board"}
}
array set arg [::cmdline::getoptions argv $parameters]

set required_parameters {projectname}
foreach parameter $required_parameters {
    if {$arg($parameter) == ""} {
        puts stderr "Missing required parameter: -$parameter"
        exit 1
    }
}

set src_dir "hdl_src"
set hdl_files "synchronizer.sv,project_info.sv,project_info_viewer.sv,blinker.v,counter.vhd,debouncer.sv,seven_segment.sv"
set sdc_files "design.sdc"

set project_name $arg(projectname)
project_new $project_name -overwrite

set board_name $arg(board)

if {$board_name != ""} {
    if {$board_name == "de0_cv"} {
        set device_family CYCLONEV
        set device 5CEBA4F23C7
        set hdl_top_file "boards/$board_name/top.v"
        set_global_assignment -name VERILOG_FILE $hdl_top_file
        set_global_assignment -name SYSTEMVERILOG_FILE hdl_src/wrapper_de0_cv.sv
    } elseif {$board_name == "de0_nano"} {
        set device_family "CYCLONEIV E"
        set device EP4CE22F17C6
        set hdl_top_file "boards/$board_name/top.sv"
        set_global_assignment -name SYSTEMVERILOG_FILE $hdl_top_file
        set_global_assignment -name SYSTEMVERILOG_FILE hdl_src/wrapper_de0_nano.sv
    }
    
    set board_sdc_file "boards/$board_name/board.sdc"  
    set_global_assignment -name VERILOG_MACRO "$board_name=1"
    set_global_assignment -name SDC_FILE $board_sdc_file
} else {
    if {$arg(family) == ""} {
        puts stderr "Missing required parameter: -family"
        exit 1
    } else {
        set device_family $arg(family)
    }

    if {$arg(device) == ""} {
        puts stderr "Missing required parameter: -device"
        exit 1
    } else {
        set device $arg(device)
    }

    set hdl_top_file "boards/undefined/top.sv"
    set_global_assignment -name SYSTEMVERILOG_FILE $hdl_top_file
}

if {[regexp {,} $hdl_files]} {
    set hdl_file_list [split $hdl_files ,]
} else {
    set hdl_file_list $hdl_files
}

if {[regexp {,} $sdc_files]} {
    set sdc_file_list [split $sdc_files ,]
} else {
    set sdc_file_list $sdc_files
}

foreach hdl_file $hdl_file_list {
    set hdl_file_extension [file extension $hdl_file]

    if {$hdl_file_extension == ".v"} {
        set_global_assignment -name VERILOG_FILE $src_dir/$hdl_file
    } elseif {$hdl_file_extension == ".sv"} {
        set_global_assignment -name SYSTEMVERILOG_FILE $src_dir/$hdl_file
    } elseif {$hdl_file_extension == ".vhd"} {
        set_global_assignment -name VHDL_FILE $src_dir/$hdl_file
    }
}

foreach sdc_file $sdc_file_list {
    set_global_assignment -name SDC_FILE $src_dir/$sdc_file
}

set top_name top

set_global_assignment -name FAMILY $device_family
set_global_assignment -name DEVICE $device
set_global_assignment -name TOP_LEVEL_ENTITY $top_name
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id $top_name
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id $top_name
set_global_assignment -name PARTITION_COLOR 16764057 -section_id $top_name
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "ACTIVE SERIAL X1"
set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name STRATIXII_CONFIGURATION_DEVICE EPCS64
set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id $top_name
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name EDA_SIMULATION_TOOL "<None>"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT NONE -section_id eda_simultation

# Compiler Assignments
# ====================
# set_global_assignment -name VERILOG_INPUT_VERSION VERILOG_2001
set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2005
set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
set_global_assignment -name OPTIMIZATION_MODE "AGGRESSIVE PERFORMANCE"
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL


if {$board_name == "de0_cv"} {
    set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ
}

# set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"

proc set_ {name str} {
    if {$name != ""} {
        source boards/$name/$str.tcl
    } else {
        source boards/undefined/$str.tcl
    }
}

# Pin & Location Assignments
# ==========================
set_ $board_name "pins_location"

# Fitter Assignments
# ==================
set_ $board_name "pins_fitter"

project_close
