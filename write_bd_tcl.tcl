
################################################################
# This is a generated script based on design: drp_example
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source drp_example_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku5p-ffvb676-2-e
   set_property BOARD_PART xilinx.com:kcu116:part0:1.2 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name drp_example

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:user:drp_bridge:1.0\
user.org:user:freq_counter:1.0\
user.org:user:gty_64_156_28G_top:1.0\
xilinx.com:ip:jtag_axi:1.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:vio:3.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set default_sysclk_300 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk_300 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $default_sysclk_300
  set gty_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gty_0 ]
  set mgtrefclk_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 mgtrefclk_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   ] $mgtrefclk_0

  # Create ports
  set clk_out2 [ create_bd_port -dir O -type clk clk_out2 ]
  set ext_reset_in [ create_bd_port -dir I -type rst ext_reset_in ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $ext_reset_in

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $axi_interconnect_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.AXI_DRP {false} \
   CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {101.475} \
   CONFIG.CLKOUT1_PHASE_ERROR {77.836} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.INTERFACE_SELECTION {Enable_DRP} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_DYN_RECONFIG {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]
  set_property -dict [ list \
   CONFIG.AXI_DRP {false} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {144.719} \
   CONFIG.CLKOUT1_PHASE_ERROR {114.212} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
   CONFIG.INTERFACE_SELECTION {Enable_DRP} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {8} \
   CONFIG.MMCM_COMPENSATION {AUTO} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PHASE_DUTY_CONFIG {false} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
   CONFIG.USE_DYN_RECONFIG {true} \
 ] $clk_wiz_1

  # Create instance: drp_bridge_0, and set properties
  set drp_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:drp_bridge:1.0 drp_bridge_0 ]
  set_property -dict [ list \
   CONFIG.DRP_ADDR_WIDTH {7} \
   CONFIG.DRP_COUNT {3} \
 ] $drp_bridge_0

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /drp_bridge_0/S_AXI]

  # Create instance: drp_bridge_1, and set properties
  set drp_bridge_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:drp_bridge:1.0 drp_bridge_1 ]
  set_property -dict [ list \
   CONFIG.DRP_ADDR_WIDTH {10} \
   CONFIG.DRP_COUNT {5} \
 ] $drp_bridge_1

  set_property -dict [ list \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
   CONFIG.MAX_BURST_LENGTH {1} \
 ] [get_bd_intf_pins /drp_bridge_1/S_AXI]

  # Create instance: freq_counter_0, and set properties
  set freq_counter_0 [ create_bd_cell -type ip -vlnv user.org:user:freq_counter:1.0 freq_counter_0 ]

  # Create instance: gty_64_156_28G_top_0, and set properties
  set gty_64_156_28G_top_0 [ create_bd_cell -type ip -vlnv user.org:user:gty_64_156_28G_top:1.0 gty_64_156_28G_top_0 ]

  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
   CONFIG.C_AUX_RESET_HIGH {0} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $proc_sys_reset_0

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [ list \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {4} \
   CONFIG.C_NUM_OF_PROBES {1} \
   CONFIG.C_PROBE0_TYPE {0} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:drp_rtl:1.0} \
   CONFIG.C_SLOT_0_TYPE {0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:drp_rtl:1.0} \
   CONFIG.C_SLOT_1_TYPE {0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:drp_rtl:1.0} \
   CONFIG.C_SLOT_2_TYPE {0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:drp_rtl:1.0} \
   CONFIG.C_SLOT_3_TYPE {0} \
 ] $system_ila_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {3} \
   CONFIG.C_NUM_PROBE_OUT {2} \
 ] $vio_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins drp_bridge_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins drp_bridge_1/S_AXI]
  connect_bd_intf_net -intf_net default_sysclk1_300_1 [get_bd_intf_ports default_sysclk_300] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net drp_bridge_0_DRP0 [get_bd_intf_pins clk_wiz_0/s_drp] [get_bd_intf_pins drp_bridge_0/DRP0]
connect_bd_intf_net -intf_net [get_bd_intf_nets drp_bridge_0_DRP0] [get_bd_intf_pins drp_bridge_0/DRP0] [get_bd_intf_pins system_ila_1/SLOT_0_DRP]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_intf_nets drp_bridge_0_DRP0]
  connect_bd_intf_net -intf_net drp_bridge_0_DRP1 [get_bd_intf_pins clk_wiz_1/s_drp] [get_bd_intf_pins drp_bridge_0/DRP1]
connect_bd_intf_net -intf_net [get_bd_intf_nets drp_bridge_0_DRP1] [get_bd_intf_pins drp_bridge_0/DRP1] [get_bd_intf_pins system_ila_1/SLOT_1_DRP]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_intf_nets drp_bridge_0_DRP1]
  connect_bd_intf_net -intf_net drp_bridge_1_DRP0 [get_bd_intf_pins drp_bridge_1/DRP0] [get_bd_intf_pins gty_64_156_28G_top_0/drp_common]
connect_bd_intf_net -intf_net [get_bd_intf_nets drp_bridge_1_DRP0] [get_bd_intf_pins drp_bridge_1/DRP0] [get_bd_intf_pins system_ila_1/SLOT_2_DRP]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_intf_nets drp_bridge_1_DRP0]
  connect_bd_intf_net -intf_net drp_bridge_1_DRP1 [get_bd_intf_pins drp_bridge_1/DRP1] [get_bd_intf_pins gty_64_156_28G_top_0/drp]
connect_bd_intf_net -intf_net [get_bd_intf_nets drp_bridge_1_DRP1] [get_bd_intf_pins drp_bridge_1/DRP1] [get_bd_intf_pins system_ila_1/SLOT_3_DRP]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_intf_nets drp_bridge_1_DRP1]
  connect_bd_intf_net -intf_net drp_bridge_1_DRP2 [get_bd_intf_pins drp_bridge_1/DRP2] [get_bd_intf_pins gty_64_156_28G_top_0/drp_vio]
  connect_bd_intf_net -intf_net gty_64_156_28G_top_0_gty [get_bd_intf_ports gty_0] [get_bd_intf_pins gty_64_156_28G_top_0/gty]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net mgtrefclk_0_1 [get_bd_intf_ports mgtrefclk_0] [get_bd_intf_pins gty_64_156_28G_top_0/mgtrefclk]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins proc_sys_reset_0/interconnect_aresetn]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins clk_wiz_0/dclk] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins clk_wiz_1/dclk] [get_bd_pins drp_bridge_0/AXI_aclk] [get_bd_pins drp_bridge_1/AXI_aclk] [get_bd_pins freq_counter_0/CLKIN] [get_bd_pins freq_counter_0/REF_CLK_I] [get_bd_pins gty_64_156_28G_top_0/hb_gtwiz_reset_clk_freerun_in] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins system_ila_1/clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_ports clk_out2] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins system_ila_1/probe0]
  set_property -dict [ list \
HDL_ATTRIBUTE.DEBUG {true} \
 ] [get_bd_nets clk_wiz_1_clk_out1]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net freq_counter_0_FREQ_CNT_O [get_bd_pins freq_counter_0/FREQ_CNT_O] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net gty_64_156_28G_top_0_link_down_latched_out [get_bd_pins gty_64_156_28G_top_0/link_down_latched_out] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net gty_64_156_28G_top_0_link_status_out [get_bd_pins gty_64_156_28G_top_0/link_status_out] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins freq_counter_0/RST_I] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net reset_1 [get_bd_ports ext_reset_in] [get_bd_pins clk_wiz_0/reset] [get_bd_pins clk_wiz_1/reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net reset_block_peripheral_aresetn [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins drp_bridge_0/AXI_aresetn] [get_bd_pins drp_bridge_1/AXI_aresetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins gty_64_156_28G_top_0/link_down_latched_reset_in] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net vio_0_probe_out1 [get_bd_pins gty_64_156_28G_top_0/hb_gtwiz_reset_all_in] [get_bd_pins vio_0/probe_out1]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x44A00000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs drp_bridge_0/S_AXI/reg0] SEG_drp_bridge_0_reg0
  create_bd_addr_seg -range 0x00008000 -offset 0x44A10000 [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs drp_bridge_1/S_AXI/reg0] SEG_drp_bridge_1_reg0


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


