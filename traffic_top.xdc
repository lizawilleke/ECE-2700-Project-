## Nexys A7 constraints for traffic_top
## Pin names follow Digilent's Nexys A7 master XDC -- double-check against your board revision.

## Clock (100 MHz)
set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }]

## Reset: CPU_RESETN (active low)
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { resetn }]

## Day/night switch: SW0
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { sw_night }]

## Pedestrian button: BTNC
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { btn_ped }]

## Vehicle lights on LEDs
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { ns_red }]      ;# LED0
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { ns_yellow }]   ;# LED1
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { ns_green }]    ;# LED2
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { ew_red }]      ;# LED3
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { ew_yellow }]   ;# LED4
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports { ew_green }]    ;# LED5

## Pedestrian signals on LEDs
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { ped_walk }]      ;# LED6
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { ped_dont_walk }] ;# LED7

## Pedestrian countdown (binary) on LED8-LED13
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[0] }] ;# LED8
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[1] }] ;# LED9
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[2] }] ;# LED10
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[3] }] ;# LED11
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[4] }] ;# LED12
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { ped_countdown[5] }] ;# LED13
