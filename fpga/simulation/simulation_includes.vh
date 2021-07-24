//                              -*- Mode: Verilog -*-
// Filename        : wb_dsp_includes.vh
// Description     : Include file for WB DSP Testing
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:38:15 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:38:15 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!


//
// Hierarchy 
//
`define TB          testbench
`define WB_RST      `TB.wb_rst
`define WB_CLK      `TB.wb_clk
`define CLK_1MS     `TB.clk_1ms
`define DUT         `TB.dut
`define SYSCON      `DUT.syscon

`define UART_MASTER0      `TB.uart_master0
`define UART_MASTER1      `TB.uart_master1
`define UART_CLK          `TB.clk_tb
`define UART_CONFIG       `TB.uart_tasks.uart_config
`define UART_WRITE_BYTE   `TB.uart_tasks.uart_write_byte
`define UART_READ_BYTE    `TB.uart_tasks.uart_read_byte
`define UART_WRITE_WORD   `TB.uart_tasks.uart_write_word
`define UART_READ_WORD    `TB.uart_tasks.uart_read_word
`define UART_BUSY         `TB.uart_tasks.uart_busy

//
// Time Defines
//
`define mS *1000000
`define nS *1
`define uS *1000
`define Wait #
`define wait #
`define khz *1000

//
// Taken from http://asciitable.com/
//
`define LINE_FEED       8'h0A
`define CARRIAGE_RETURN 8'h0D
`define SPACE_CHAR      8'h20
`define NUMBER_0        8'h30
`define NUMBER_9        8'h39
`define LETTER_A        8'h41
`define LETTER_Z        8'h5A
`define LETTER_a        8'h61
`define LETTER_f        8'h66
`define LETTER_z        8'h7a

//
// Test Defines
//
`define TEST_TASKS      `TB.test_tasks
`define TEST_PASSED     `TEST_TASKS.test_passed
`define TEST_FAILED     `TEST_TASKS.test_failed
`define TEST_COMPARE    `TEST_TASKS.compare_values
`define TEST_RANGE      `TEST_TASKS.compare_range
`define TEST_COMPLETE   `TEST_TASKS.all_tests_completed

`define TEST_CASE       `TB.test_case
`define SIMULATION_NAME `TEST_CASE.simulation_name
`define NUMBER_OF_TESTS `TEST_CASE.number_of_tests

`define test_failed     `TB.test_failed
