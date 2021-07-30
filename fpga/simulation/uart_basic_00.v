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
   parameter number_of_tests = 4;
   
   reg [31:0] cpu_read;
   
   initial begin
      cpu_read = 0;
      
      $display("UART Basic Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.UART_VALID);
      repeat (100) @(posedge `WB_CLK);

      `CPU_WRITES(`WB_RAM0,    4'hF, 32'h0123_4567);
      `CPU_WRITES(`WB_RAM1+4,  4'hF, 32'h89AB_CDEF);
      `CPU_WRITES(`WB_RAM2+8,  4'hF, 32'hAA55_CC77);
      `CPU_WRITES(`WB_RAM3+12, 4'hF, 32'hBB66_DD99);
      
      repeat (500) @(posedge `WB_CLK);

      `CPU_READS(`WB_RAM0,    4'hF, 32'h0123_4567, cpu_read);
      `CPU_READS(`WB_RAM2+8,  4'hF, 32'hAA55_CC77, cpu_read);
      `CPU_READS(`WB_RAM3+12, 4'hF, 32'hBB66_DD99, cpu_read);
      `CPU_READS(`WB_RAM1+4,  4'hF, 32'h89AB_CDEF, cpu_read);
      
      repeat (2000) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end
   
endmodule // test_case
