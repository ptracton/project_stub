//                              -*- Mode: Verilog -*-
// Filename        : uart_basic_00.v
// Description     : Basic UART to WB Master Test
// Author          : Phil Tracton
// Created On      : Tue Jul 27 22:17:10 2021
// Last Modified By: Phil Tracton
// Last Modified On: Tue Jul 27 22:17:10 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module test_case (/*AUTOARG*/ ) ;

`include "system_includes.vh"
`include "simulation_includes.vh"
   
   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "uart_basic_00";
   parameter number_of_tests = 896;


   initial begin
      $display("UART Basic Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.UART_VALID);
      repeat (100) @(posedge `WB_CLK);

      repeat (2000) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end
   
endmodule // test_case
