set common_offset [expr 0x44A10000]
set channel_offset [expr 0x44A10000+(1<<12)]
set vio_regs_offset [expr 0x44A10000+(1<<12)*2]
set offset 0
proc program_bit_file {} {
  open_hw
  connect_hw_server
  open_hw_target
  set_property PROGRAM.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.bit} [get_hw_devices xcku5p_0]
  set_property PROBES.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.ltx} [get_hw_devices xcku5p_0]
  set_property FULL_PROBES.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.ltx} [get_hw_devices xcku5p_0]
  current_hw_device [get_hw_devices xcku5p_0]
  refresh_hw_device [lindex [get_hw_devices xcku5p_0] 0]
  set_property PROBES.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.ltx} [get_hw_devices xcku5p_0]
  set_property FULL_PROBES.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.ltx} [get_hw_devices xcku5p_0]
  set_property PROGRAM.FILE {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.runs/impl_1/drp_example_wrapper.bit} [get_hw_devices xcku5p_0]
  program_hw_devices [get_hw_devices xcku5p_0]
  refresh_hw_device [lindex [get_hw_devices xcku5p_0] 0]
  #display_hw_ila_data [ get_hw_ila_data hw_ila_data_1 -of_objects [get_hw_ilas -of_objects [get_hw_devices xcku5p_0] -filter {CELL_NAME=~"drp_example_i/system_ila_1/inst/ila_lib"}]]
  #save_wave_config {/home/chiwei/work/checkout/kcu116/kcu116_prbs_test/kcu116_prbs_test.hw/hw_1/wave/hw_ila_data_1/hw_ila_data_1.wcfg}
  #exit
}
proc gtye_common_api {} {
  global common_offset
  global offset
  source ~/bin/gtye_common_api.tcl
  set offset $common_offset
  dump_gtye_common_api
}
proc gtye_channel_api {} {
  global channel_offset
  global offset
  source ~/bin/gtye_channel_api.tcl
  set channel_offset [expr 0x44A10000+(1<<12)]
  set offset $channel_offset
  dump_gtye_channel_api
}
proc vio_regs_api {} {
  global vio_regs_offset
  global offset
  source ~/bin/vio_regs_api.tcl
  set offset $vio_regs_offset
  dump_vio_regs_api
}
proc gty_vio_api {} {
  source ~/bin/gty_vio_api.tcl
  dump_gty_vio_api
}
proc gty_ne_loopback {} {
  source ~/bin/gty_ne_loopback.tcl
}
proc prbs_test_ini {} {
  puts "gtye_common_api : [gtye_common_api]"
  puts "gtye_channel_api: [gtye_channel_api]"
  puts "vio_regs_api    : [vio_regs_api]"
#  puts "gty_vio_api     : [gty_vio_api]"
  puts "gty_ne_loopback : [gty_ne_loopback]"
}
proc external_loopback { {testpattern 5} } {
  global offset
  global vio_regs_offset
  set offset $vio_regs_offset
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "PRBS error count reset: [prbs_reset]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_enable $testpattern: [prbs_enable $testpattern]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_forceerr: [prbs_forceerr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  set offset $vio_regs_offset
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "prbs_disable: [prbs_disable]"
}
proc serial_loopback { {testpattern 5} } {
  global offset
  global vio_regs_offset
  set offset $vio_regs_offset
  puts "near_end_pma_loopback_enable: [near_end_pma_loopback_enable]"
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "PRBS error count reset: [prbs_reset]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_enable $testpattern: [prbs_enable $testpattern]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_forceerr: [prbs_forceerr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  set offset $vio_regs_offset
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "prbs_disable: [prbs_disable]"
  puts "near_end_pma_loopback_enable: [near_end_pma_loopback_disable]"
}
proc parallel_loopback { {testpattern 5} } {
  global offset
  global vio_regs_offset
  set offset $vio_regs_offset
  puts "near_end_pcs_loopback_enable: [near_end_pcs_loopback_enable]"
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "PRBS error count reset: [prbs_reset]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_enable $testpattern: [prbs_enable $testpattern]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "prbs_forceerr: [prbs_forceerr]"
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  puts "Error count : [prbs_error_cnt]"
  exec sleep 5
  set offset $vio_regs_offset
  puts "init_done: [init_done]"
  puts "rxprbslocked: [rxprbslocked]"
  puts "rxprbserr: [rxprbserr]"
  puts "prbs_disable: [prbs_disable]"
  puts "near_end_pcs_loopback_enable: [near_end_pcs_loopback_disable]"
}
proc help_prbs_test {} {
  puts "program_bit_file"
  puts "gtye_common_api"
  puts "gtye_channel_api"
  puts "vio_regs_api"
  puts "gty_vio_api"
  puts "gty_ne_loopback"
  puts "prbs_enable"
  puts "prbs_reset"
  puts "prbs_error_cnt"
  puts "prbs_forceerr"
  puts "prbs_disable"
  puts "near_end_pcs_loopback_enable"
  puts "near_end_pcs_loopback_disable"
  puts "near_end_pma_loopback_enable"
  puts "near_end_pma_loopback_disable"
  puts "prbs_test_ini"
  puts "external_loopback"
  puts "serial_loopback"
  puts "parallel_loopback"
}
proc work_settings {} {
  global vio_regs_offset
  global offset
  set offset $vio_regs_offset
  txpostcursor 10
  txprecursor 10
  rxlpmen 0
}
