
################################################################
# This is a generated script based on design: system_wrapper
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
set scripts_vivado_version 2016.1
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
# source system_wrapper_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name system_wrapper

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

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

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
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set gpio_button [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_button ]
  set gpio_led [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_led ]
  set iic_fmc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_fmc ]

  # Create ports
  set adc_clk_in_n [ create_bd_port -dir I adc_clk_in_n ]
  set adc_clk_in_p [ create_bd_port -dir I adc_clk_in_p ]
  set adc_data_in_n [ create_bd_port -dir I -from 7 -to 0 adc_data_in_n ]
  set adc_data_in_p [ create_bd_port -dir I -from 7 -to 0 adc_data_in_p ]
  set adc_or_in_n [ create_bd_port -dir I adc_or_in_n ]
  set adc_or_in_p [ create_bd_port -dir I adc_or_in_p ]
  set spi0_clk_o [ create_bd_port -dir O spi0_clk_o ]
  set spi0_csn_0_o [ create_bd_port -dir O spi0_csn_0_o ]
  set spi0_csn_1_o [ create_bd_port -dir O spi0_csn_1_o ]
  set spi0_csn_2_o [ create_bd_port -dir O spi0_csn_2_o ]
  set spi0_csn_i_1 [ create_bd_port -dir I spi0_csn_i_1 ]
  set spi0_sdi_i [ create_bd_port -dir I spi0_sdi_i ]
  set spi0_sdo_i [ create_bd_port -dir I spi0_sdo_i ]
  set spi0_sdo_o [ create_bd_port -dir O spi0_sdo_o ]

  # Create instance: axi_ad9467_0, and set properties
  set axi_ad9467_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_ad9467:1.0 axi_ad9467_0 ]

  # Create instance: axi_dmac_0, and set properties
  set axi_dmac_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 axi_dmac_0 ]
  set_property -dict [ list \
CONFIG.AXI_SLICE_SRC {true} \
CONFIG.DMA_DATA_WIDTH_SRC {16} \
 ] $axi_dmac_0

  # Create instance: axi_gpio_0_button, and set properties
  set axi_gpio_0_button [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0_button ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {2} \
CONFIG.C_INTERRUPT_PRESENT {1} \
 ] $axi_gpio_0_button

  # Create instance: axi_gpio_0_led, and set properties
  set axi_gpio_0_led [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0_led ]
  set_property -dict [ list \
CONFIG.C_ALL_OUTPUTS {1} \
CONFIG.C_GPIO_WIDTH {4} \
 ] $axi_gpio_0_led

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {33.333336} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_CLK0_FREQ {100000000} \
CONFIG.PCW_CLK1_FREQ {200000000} \
CONFIG.PCW_CLK2_FREQ {33333336} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {<Select>} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_ENET0_RESET_IO {<Select>} \
CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET1_RESET_ENABLE {0} \
CONFIG.PCW_ENET1_RESET_IO {<Select>} \
CONFIG.PCW_ENET_RESET_ENABLE {1} \
CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
CONFIG.PCW_EN_4K_TIMER {0} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_DDR {1} \
CONFIG.PCW_EN_EMIO_SPI0 {1} \
CONFIG.PCW_EN_EMIO_TTC0 {1} \
CONFIG.PCW_EN_ENET0 {1} \
CONFIG.PCW_EN_QSPI {1} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {0} \
CONFIG.PCW_EN_RST2_PORT {0} \
CONFIG.PCW_EN_RST3_PORT {0} \
CONFIG.PCW_EN_SDIO0 {1} \
CONFIG.PCW_EN_SPI0 {1} \
CONFIG.PCW_EN_TTC0 {1} \
CONFIG.PCW_EN_UART1 {1} \
CONFIG.PCW_EN_USB0 {1} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {6} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {5} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {4} \
CONFIG.PCW_FCLK_CLK0_BUF {true} \
CONFIG.PCW_FCLK_CLK1_BUF {true} \
CONFIG.PCW_FCLK_CLK2_BUF {true} \
CONFIG.PCW_FCLK_CLK3_BUF {true} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK3_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C0_I2C0_IO {<Select>} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C0_RESET_ENABLE {0} \
CONFIG.PCW_I2C0_RESET_IO {<Select>} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_IO {<Select>} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
CONFIG.PCW_I2C_RESET_SELECT {<Select>} \
CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_DIRECTION {inout} \
CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_DIRECTION {inout} \
CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_10_PULLUP {disabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_DIRECTION {inout} \
CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_11_PULLUP {disabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_DIRECTION {inout} \
CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_12_PULLUP {disabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_DIRECTION {inout} \
CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_13_PULLUP {disabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_DIRECTION {inout} \
CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_14_PULLUP {disabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_DIRECTION {inout} \
CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_15_PULLUP {disabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_DIRECTION {out} \
CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_DIRECTION {out} \
CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_DIRECTION {out} \
CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_DIRECTION {out} \
CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_DIRECTION {out} \
CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_DIRECTION {out} \
CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_DIRECTION {out} \
CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_DIRECTION {in} \
CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_DIRECTION {in} \
CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_DIRECTION {in} \
CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_DIRECTION {in} \
CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_DIRECTION {in} \
CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_DIRECTION {in} \
CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_DIRECTION {inout} \
CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_DIRECTION {in} \
CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_DIRECTION {inout} \
CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_2_PULLUP {disabled} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_DIRECTION {out} \
CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_DIRECTION {in} \
CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_DIRECTION {inout} \
CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_DIRECTION {inout} \
CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_DIRECTION {inout} \
CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_DIRECTION {inout} \
CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_DIRECTION {in} \
CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_DIRECTION {inout} \
CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_DIRECTION {inout} \
CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_DIRECTION {inout} \
CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_DIRECTION {inout} \
CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_3_PULLUP {disabled} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_DIRECTION {inout} \
CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_DIRECTION {inout} \
CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_DIRECTION {inout} \
CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_DIRECTION {inout} \
CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_DIRECTION {inout} \
CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_DIRECTION {inout} \
CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_DIRECTION {in} \
CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_46_PULLUP {disabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_DIRECTION {inout} \
CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_DIRECTION {out} \
CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_DIRECTION {in} \
CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_DIRECTION {inout} \
CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_4_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_DIRECTION {in} \
CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_DIRECTION {inout} \
CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_DIRECTION {out} \
CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_DIRECTION {inout} \
CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_DIRECTION {inout} \
CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_5_PULLUP {disabled} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_DIRECTION {out} \
CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_6_PULLUP {disabled} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_DIRECTION {out} \
CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_7_PULLUP {disabled} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_DIRECTION {out} \
CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_8_PULLUP {disabled} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_DIRECTION {inout} \
CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#UART 1#UART 1#SD 0#GPIO#Enet 0#Enet 0} \
CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_sclk#reset#qspi_fbclk#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#gpio[47]#tx#rx#wp#gpio[51]#mdc#mdio} \
CONFIG.PCW_NAND_CYCLES_T_AR {1} \
CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
CONFIG.PCW_NAND_CYCLES_T_RC {11} \
CONFIG.PCW_NAND_CYCLES_T_REA {1} \
CONFIG.PCW_NAND_CYCLES_T_RR {1} \
CONFIG.PCW_NAND_CYCLES_T_WC {11} \
CONFIG.PCW_NAND_CYCLES_T_WP {1} \
CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
CONFIG.PCW_NAND_NAND_IO {<Select>} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_CS0_T_PC {1} \
CONFIG.PCW_NOR_CS0_T_RC {11} \
CONFIG.PCW_NOR_CS0_T_TR {1} \
CONFIG.PCW_NOR_CS0_T_WC {11} \
CONFIG.PCW_NOR_CS0_T_WP {1} \
CONFIG.PCW_NOR_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_CS1_T_PC {1} \
CONFIG.PCW_NOR_CS1_T_RC {11} \
CONFIG.PCW_NOR_CS1_T_TR {1} \
CONFIG.PCW_NOR_CS1_T_WC {11} \
CONFIG.PCW_NOR_CS1_T_WP {1} \
CONFIG.PCW_NOR_CS1_WE_TIME {0} \
CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
CONFIG.PCW_NOR_NOR_IO {<Select>} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.361} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.351} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.386} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.391} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.112} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.093} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.019} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.009} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_IO1_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS0_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_BAUD_RATE {115200} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART0_UART0_IO {<Select>} \
CONFIG.PCW_UART1_BAUD_RATE {115200} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
CONFIG.PCW_UIPARAM_DDR_AL {0} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CL {7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {101.239} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {79.5025} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {60.536} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {71.7715} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {104.5365} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {70.676} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {59.1615} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {81.319} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB1_RESET_ENABLE {0} \
CONFIG.PCW_USB1_RESET_IO {<Select>} \
CONFIG.PCW_USB1_USB1_IO {<Select>} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
CONFIG.PCW_USE_CROSS_TRIGGER {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_M_AXI_GP1 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $processing_system7_0



  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {6} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dmac_0_m_dest_axi [get_bd_intf_pins axi_dmac_0/m_dest_axi] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_gpio_0_button_GPIO [get_bd_intf_ports gpio_button] [get_bd_intf_pins axi_gpio_0_button/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_led_GPIO [get_bd_intf_ports gpio_led] [get_bd_intf_pins axi_gpio_0_led/GPIO]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_fmc] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0_led/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_0_button/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ad9467_0/s_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins axi_dmac_0/s_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]

  # Create port connections
  connect_bd_net -net SPI0_MISO_I_1 [get_bd_ports spi0_sdi_i] [get_bd_pins processing_system7_0/SPI0_MISO_I]
  connect_bd_net -net SPI0_MOSI_I_1 [get_bd_ports spi0_sdo_i] [get_bd_pins processing_system7_0/SPI0_MOSI_I]
  connect_bd_net -net SPI0_SS_I_1 [get_bd_ports spi0_csn_i_1] [get_bd_pins processing_system7_0/SPI0_SS_I]
  connect_bd_net -net adc_clk_in_n_1 [get_bd_ports adc_clk_in_n] [get_bd_pins axi_ad9467_0/adc_clk_in_n]
  connect_bd_net -net adc_clk_in_p_1 [get_bd_ports adc_clk_in_p] [get_bd_pins axi_ad9467_0/adc_clk_in_p]
  connect_bd_net -net adc_data_in_n_1 [get_bd_ports adc_data_in_n] [get_bd_pins axi_ad9467_0/adc_data_in_n]
  connect_bd_net -net adc_data_in_p_1 [get_bd_ports adc_data_in_p] [get_bd_pins axi_ad9467_0/adc_data_in_p]
  connect_bd_net -net adc_or_in_n_1 [get_bd_ports adc_or_in_n] [get_bd_pins axi_ad9467_0/adc_or_in_n]
  connect_bd_net -net adc_or_in_p_1 [get_bd_ports adc_or_in_p] [get_bd_pins axi_ad9467_0/adc_or_in_p]
  connect_bd_net -net axi_ad9467_0_adc_clk [get_bd_pins axi_ad9467_0/adc_clk] [get_bd_pins axi_dmac_0/fifo_wr_clk]
  connect_bd_net -net axi_ad9467_0_adc_data [get_bd_pins axi_ad9467_0/adc_data] [get_bd_pins axi_dmac_0/fifo_wr_din]
  connect_bd_net -net axi_ad9467_0_adc_valid [get_bd_pins axi_ad9467_0/adc_valid] [get_bd_pins axi_dmac_0/fifo_wr_en]
  connect_bd_net -net axi_dmac_0_fifo_wr_overflow [get_bd_pins axi_ad9467_0/adc_dovf] [get_bd_pins axi_dmac_0/fifo_wr_overflow]
  connect_bd_net -net axi_dmac_0_irq [get_bd_pins axi_dmac_0/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_gpio_0_button_ip2intc_irpt [get_bd_pins axi_gpio_0_button/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc_0/irq] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_ad9467_0/s_axi_aclk] [get_bd_pins axi_dmac_0/m_dest_axi_aclk] [get_bd_pins axi_dmac_0/s_axi_aclk] [get_bd_pins axi_gpio_0_button/s_axi_aclk] [get_bd_pins axi_gpio_0_led/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_ad9467_0/delay_clk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net processing_system7_0_SPI0_MOSI_O [get_bd_ports spi0_sdo_o] [get_bd_pins processing_system7_0/SPI0_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI0_SCLK_O [get_bd_ports spi0_clk_o] [get_bd_pins processing_system7_0/SPI0_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI0_SS1_O [get_bd_ports spi0_csn_1_o] [get_bd_pins processing_system7_0/SPI0_SS1_O]
  connect_bd_net -net processing_system7_0_SPI0_SS2_O [get_bd_ports spi0_csn_2_o] [get_bd_pins processing_system7_0/SPI0_SS2_O]
  connect_bd_net -net processing_system7_0_SPI0_SS_O [get_bd_ports spi0_csn_0_o] [get_bd_pins processing_system7_0/SPI0_SS_O]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_ad9467_0/s_axi_aresetn] [get_bd_pins axi_dmac_0/m_dest_axi_aresetn] [get_bd_pins axi_dmac_0/s_axi_aresetn] [get_bd_pins axi_gpio_0_button/s_axi_aresetn] [get_bd_pins axi_gpio_0_led/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_ad9467_0/s_axi/axi_lite] SEG_axi_ad9467_0_axi_lite
  create_bd_addr_seg -range 0x20000000 -offset 0x60000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_ad9467_0/s_axi/reg0] SEG_axi_ad9467_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dmac_0/s_axi/axi_lite] SEG_axi_dmac_0_axi_lite
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dmac_0/s_axi/reg0] SEG_axi_dmac_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0_button/S_AXI/Reg] SEG_axi_gpio_0_button_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0_led/S_AXI/Reg] SEG_axi_gpio_0_led_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41800000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_intc_0/s_axi/Reg] SEG_axi_intc_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port spi0_sdi_i -pg 1 -y 320 -defaultsOSRD
preplace port DDR -pg 1 -y 370 -defaultsOSRD
preplace port adc_clk_in_n -pg 1 -y 560 -defaultsOSRD
preplace port spi0_csn_2_o -pg 1 -y 670 -defaultsOSRD
preplace port gpio_led -pg 1 -y 70 -defaultsOSRD
preplace port adc_clk_in_p -pg 1 -y 540 -defaultsOSRD
preplace port spi0_clk_o -pg 1 -y 450 -defaultsOSRD
preplace port gpio_button -pg 1 -y 210 -defaultsOSRD
preplace port spi0_sdo_i -pg 1 -y 300 -defaultsOSRD
preplace port adc_or_in_n -pg 1 -y 640 -defaultsOSRD
preplace port spi0_csn_i_1 -pg 1 -y 900 -defaultsOSRD
preplace port spi0_csn_1_o -pg 1 -y 650 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 390 -defaultsOSRD
preplace port adc_or_in_p -pg 1 -y 620 -defaultsOSRD
preplace port spi0_csn_0_o -pg 1 -y 630 -defaultsOSRD
preplace port spi0_sdo_o -pg 1 -y 510 -defaultsOSRD
preplace port iic_fmc -pg 1 -y -110 -defaultsOSRD
preplace portBus adc_data_in_n -pg 1 -y 600 -defaultsOSRD
preplace portBus adc_data_in_p -pg 1 -y 580 -defaultsOSRD
preplace inst axi_iic_0 -pg 1 -lvl 1 -y -10 -defaultsOSRD
preplace inst axi_intc_0 -pg 1 -lvl 4 -y 590 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 3 -y 210 -defaultsOSRD
preplace inst axi_ad9467_0 -pg 1 -lvl 2 -y 630 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 4 -y 780 -defaultsOSRD
preplace inst axi_gpio_0_led -pg 1 -lvl 5 -y 80 -defaultsOSRD
preplace inst axi_gpio_0_button -pg 1 -lvl 5 -y 220 -defaultsOSRD
preplace inst axi_dmac_0 -pg 1 -lvl 3 -y 630 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 4 -y 130 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 610 -defaultsOSRD
preplace netloc axi_gpio_0_button_GPIO 1 5 1 NJ
preplace netloc processing_system7_0_DDR 1 5 1 NJ
preplace netloc axi_gpio_0_button_ip2intc_irpt 1 3 3 900 370 NJ 350 1760
preplace netloc axi_dmac_0_fifo_wr_overflow 1 1 2 NJ 470 NJ
preplace netloc axi_ad9467_0_adc_data 1 2 1 460
preplace netloc adc_or_in_n_1 1 0 2 NJ 640 N
preplace netloc axi_ad9467_0_adc_valid 1 2 1 470
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 2 3 510 350 NJ 350 1250
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 4 1 1290
preplace netloc axi_iic_0_iic2intc_irpt 1 1 3 NJ -10 NJ -10 NJ
preplace netloc axi_dmac_0_irq 1 3 1 850
preplace netloc adc_data_in_n_1 1 0 2 NJ 600 N
preplace netloc processing_system7_0_M_AXI_GP0 1 3 3 860 -110 NJ -110 1780
preplace netloc adc_data_in_p_1 1 0 2 NJ 580 N
preplace netloc adc_or_in_p_1 1 0 2 NJ 620 N
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 3 2 910 380 1240
preplace netloc processing_system7_0_FCLK_RESET0_N 1 2 4 NJ 870 NJ 870 NJ 870 1760
preplace netloc processing_system7_0_SPI0_SS2_O 1 5 1 NJ
preplace netloc axi_dmac_0_m_dest_axi 1 3 2 870 510 NJ
preplace netloc adc_clk_in_n_1 1 0 2 NJ 560 N
preplace netloc SPI0_MISO_I_1 1 0 6 NJ -140 NJ -140 NJ -140 NJ -140 NJ -140 1800
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 1 4 NJ -100 NJ -100 NJ -100 1280
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 0 5 -120 740 120 800 490 490 890 360 1290
preplace netloc xlconcat_0_dout 1 3 2 920 500 1240
preplace netloc SPI0_SS_I_1 1 0 6 NJ 900 NJ 900 NJ 900 NJ 900 NJ 900 1790
preplace netloc processing_system7_0_SPI0_SS1_O 1 5 1 NJ
preplace netloc processing_system7_0_SPI0_MOSI_O 1 5 1 NJ
preplace netloc SPI0_MOSI_I_1 1 0 6 NJ -130 NJ -130 NJ -130 NJ -130 NJ -130 1770
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ
preplace netloc axi_ad9467_0_adc_clk 1 2 1 440
preplace netloc axi_iic_0_IIC 1 1 5 NJ -120 NJ -120 NJ -120 NJ -120 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 3 1 870
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 -130 720 140 790 450 300 880 390 1300 860 1770
preplace netloc processing_system7_0_SPI0_SS_O 1 5 1 NJ
preplace netloc processing_system7_0_SPI0_SCLK_O 1 5 1 NJ
preplace netloc axi_gpio_0_led_GPIO 1 5 1 NJ
preplace netloc axi_intc_0_irq 1 4 1 1270
preplace netloc processing_system7_0_FCLK_CLK1 1 1 5 NJ 880 NJ 880 NJ 880 NJ 880 1780
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 0 5 -120 -90 NJ -90 NJ -90 NJ -90 1270
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 4 1 1260
preplace netloc adc_clk_in_p_1 1 0 2 NJ 540 N
levelinfo -pg 1 -170 0 300 680 1090 1540 1850 -top -150 -bot 920
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


