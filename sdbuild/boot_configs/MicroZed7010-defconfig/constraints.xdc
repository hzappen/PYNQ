
# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 34
# ----------------------------------------------------------------------------

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS25} [get_ports iic_fmc_scl]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS25} [get_ports iic_fmc_sda]
# ad9467 on FMC
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adc_clk_in_p]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adc_clk_in_n]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adc_data_or_p]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports adc_data_or_n]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[0]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[0]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[1]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[1]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[2]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[2]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[3]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[3]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[4]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[4]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[5]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[5]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[6]}]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[6]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_p[7]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVDS_25 DIFF_TERM 1} [get_ports {adc_data_in_n[7]}]

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 35
# ----------------------------------------------------------------------------
## spi to FMC
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS25} [get_ports spi_csn_adc]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS25} [get_ports spi_csn_clk]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS25} [get_ports spi_clk]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS25} [get_ports spi_sdio]

# ----------------------------------------------------------------------------
# User LEDs - Bank 34 - Carrier
# ----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports {gpio_led[0]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS25} [get_ports {gpio_led[1]}]
# ----------------------------------------------------------------------------
# User LEDs - Bank 35
# ----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS25} [get_ports {gpio_led[2]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS25} [get_ports {gpio_led[3]}]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 35
# ----------------------------------------------------------------------------
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS25} [get_ports {gpio_button[0]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS25} [get_ports {gpio_button[1]}]


#


# clocks
create_clock -period 4.000 -name adc_clk [get_ports adc_clk_in_p]
set_clock_groups -asynchronous -group adc_clk


