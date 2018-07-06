
#set_property PACKAGE_PIN Y24 [get_ports clk_out2]
#set_property IOSTANDARD LVCMOS25 [get_ports clk_out2]

#set_property PACKAGE_PIN AB7 [get_ports ext_reset_in]
#set_property IOSTANDARD LVCMOS15 [get_ports ext_reset_in]

set_property PACKAGE_PIN P20 [get_ports clk_out2]
set_property IOSTANDARD LVCMOS18 [get_ports clk_out2]
set_property PACKAGE_PIN B9 [get_ports ext_reset_in]
set_property IOSTANDARD LVCMOS18 [get_ports ext_reset_in]

set_property IOSTANDARD DIFF_SSTL12 [get_ports default_sysclk_300_clk_p]
set_property PACKAGE_PIN K22 [get_ports default_sysclk_300_clk_p]
set_property PACKAGE_PIN K23 [get_ports default_sysclk_300_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports default_sysclk_300_clk_n]

set_property PACKAGE_PIN M2 [get_ports gty_0_grx_p]
set_property PACKAGE_PIN M1 [get_ports gty_0_grx_n]
set_property PACKAGE_PIN N5 [get_ports gty_0_gtx_p]
set_property PACKAGE_PIN N4 [get_ports gty_0_gtx_n]
#set_property PACKAGE_PIN P6 [get_ports mgtrefclk_0_clk_n]
#set_property PACKAGE_PIN P7 [get_ports mgtrefclk_0_clk_p]
set_property PACKAGE_PIN M6 [get_ports mgtrefclk_0_clk_n]
set_property PACKAGE_PIN M7 [get_ports mgtrefclk_0_clk_p]

#set_property PACKAGE_PIN M6 [get_ports { gty_refclk1n_i[1] }]; # MGTREFCLK1N_226   INPUT
#set_property PACKAGE_PIN M7 [get_ports { gty_refclk1p_i[1] }]; # MGTREFCLK1P_226   INPUT
#set_property PACKAGE_PIN P6 [get_ports { gty_refclk0n_i[1] }]; # MGTREFCLK0N_226   INPUT
#set_property PACKAGE_PIN P7 [get_ports { gty_refclk0p_i[1] }]; # MGTREFCLK0P_226   INPUT



set_clock_groups -name rxoutclk_clk -asynchronous -group [get_clocks -of_objects [get_pins {drp_example_i/gty_64_156_28G_top_0/inst/example_wrapper_inst/gty_64_156_28G_inst/inst/gen_gtwizard_gtye4_top.gty_64_156_28G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[2].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/RXOUTCLK}]] -group [get_clocks clk_freerun]
set_clock_groups -name clkout0_clk -asynchronous -group [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -group [get_clocks clk_freerun]
set_false_path -from [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks {drp_example_i/bufg_gt_0/U0/BUFG_GT_O[0]}]
set_false_path -from [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_1/inst/plle4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks {drp_example_i/bufg_gt_0/U0/BUFG_GT_O[0]}] -to [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks clk_freerun] -to [get_clocks -of_objects [get_pins drp_example_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]]

set_clock_groups -name txoutclk_clk -asynchronous -group [get_clocks -of_objects [get_pins {drp_example_i/gty_64_156_28G_top_0/inst/example_wrapper_inst/gty_64_156_28G_inst/inst/gen_gtwizard_gtye4_top.gty_64_156_28G_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[2].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST/TXOUTCLK}]] -group [get_clocks clk_freerun]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
