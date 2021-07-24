//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_includes.vh
// Description     : Include file for WB DSP Testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:38:15 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:38:15 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!



`define WB_RAM0 32'h2000_0000
`define WB_RAM1 32'h2000_2000
`define WB_RAM2 32'h2000_4000
`define WB_RAM3 32'h2000_6000

`define WB_GPIO 32'h4000_0000
`define WB_GPIO_R_IN    `WB_GPIO + 32'h0    // Read inputs
`define WB_GPIO_R_OUT   `WB_GPIO + 32'h4    // Write outptus
`define WB_GPIO_R_OE    `WB_GPIO + 32'h8    // Output Enable
`define WB_GPIO_R_INTE  `WB_GPIO + 32'hC    // Interrupt Enable
`define WB_GPIO_R_PTRIG `WB_GPIO + 32'h10   // Trigger
`define WB_GPIO_R_AUX   `WB_GPIO + 32'h14   // Aux inputs
`define WB_GPIO_R_CTRL  `WB_GPIO + 32'h18   // Control
`define WB_GPIO_F_CTRL_INTE 0
`define WB_GPIO_B_CTRL_INTE (1 << `WB_GPIO_F_CTRL_INTE)
`define WB_GPIO_F_CTRL_INTS 1
`define WB_GPIO_B_CTRL_INTS (1 << `WB_GPIO_F_CTRL_INTS)
`define WB_GPIO_R_INTS  `WB_GPIO + 32'h1C   // Interrupt Status
`define WB_GPIO_R_ECLK  `WB_GPIO + 32'h20   // Enable GPIO E-Clk
`define WB_GPIO_R_NEC   `WB_GPIO + 32'h24   // Select active edge of e-clk

`define WB_SYSCON_BASE_ADDRESS 32'h4000_1000
`define WB_SYSCON_R_IDENTIFICATION_OFFSET 0
`define WB_SYSCON_R_IDENTIFICATION `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_IDENTIFICATION_OFFSET  //Identificaton
`define F_IDENTIFICATION_PLATFORM  07:00
`define B_IDENTIFICATION_FPGA      8'h01

`define F_IDENTIFICATION_RESERVED  15:08

`define F_IDENTIFICATION_MINOR_REV 23:16
`define B_IDENTIFICATION_MINOR_REV 8'h01

`define F_IDENTIFICATION_MAJOR_REV 31:24
`define B_IDENTIFICATION_MAJOR_REV 8'h00

`define WB_SYSCON_R_STATUS_OFFSET 4
`define WB_SYSCON_R_STATUS `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_STATUS_OFFSET  //System Status
`define F_STATUS_LOCKED  0
`define F_STATUS_UNUSED  31:1

`define WB_SYSCON_R_CONTROL_OFFSET 8
`define WB_SYSCON_R_CONTROL `WB_SYSCON_BASE_ADDRESS + `WB_SYSCON_R_CONTROL_OFFSET  //System Control
`define F_CONTROL_LEDS   1:0
`define B_CONTROL_LEDS_GPIO 2'b00
`define B_CONTROL_LEDS_PC   2'b01
`define B_CONTROL_LEDS_DSP  2'b10
`define B_CONTROL_LEDS_TBD  2'b11

