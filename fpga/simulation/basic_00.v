//                              -*- Mode: Verilog -*-
// Filename        : basic_00.v
// Description     : Basic Function Test Case
// Author          : Phil Tracton
// Created On      : Mon Apr 15 17:10:49 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 17:10:49 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!
module test_case (/*AUTOARG*/ ) ;
`include "simulation_includes.vh"

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "basic_00";
   parameter number_of_tests = 89;


   initial begin

      $display("Basic Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.UART_VALID);
      repeat (100) @(posedge `WB_CLK);


      repeat (50) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end

endmodule // test_case
