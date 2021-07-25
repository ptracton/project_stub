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

`include "system_includes.vh"
`include "simulation_includes.vh"

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "basic_00";
   parameter number_of_tests = 896;

   reg [31:0] read32;
   reg [15:0] read16;
   reg [07:0] read8;
   integer    i;
   integer    loop_size;

   initial begin

      $display("Basic Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.SPI_VALID);
      repeat (100) @(posedge `WB_CLK);

      loop_size = 128;

      $display("32 Bit Access");
      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE32 (`WB_RAM0 + i, `WB_FULL_WORD, i);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE32 (`WB_RAM1 + i, `WB_FULL_WORD, ( 1<<16 | i));
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE32 (`WB_RAM2 + i, `WB_FULL_WORD, (2<<16 |i) );
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE32 (`WB_RAM3 + i, `WB_FULL_WORD, (3 << 16 | i));
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ32 (`WB_RAM0 + i, `WB_FULL_WORD, read32);
         `TEST_COMPARE("READING32 0", read32, i);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ32 (`WB_RAM1 + i, `WB_FULL_WORD, read32);
         `TEST_COMPARE("READING32 1", read32, (1 << 16 | i ));
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ32 (`WB_RAM2 + i, `WB_FULL_WORD, read32);
         `TEST_COMPARE("READING32 2", read32, (2 << 16 | i ));
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ32 (`WB_RAM3 + i, `WB_FULL_WORD, read32);
         `TEST_COMPARE("READING32 3", read32, (3 << 16 | i ));
      end

      repeat (2000) @(posedge `WB_CLK);
      
      $display("16 Bit Access");
      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE16 (`WB_RAM0 + i, `WB_UPPER_HALF_WORD, i);
         `SPI_WRITE16 (`WB_RAM0 + i, `WB_LOWER_HALF_WORD, i+1);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE16 (`WB_RAM1 + i, `WB_UPPER_HALF_WORD, ( 1<<8 | i));
         `SPI_WRITE16 (`WB_RAM1 + i + 1, `WB_LOWER_HALF_WORD, ( 1<<8 | (i+1)));
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE16 (`WB_RAM2 + i, `WB_UPPER_HALF_WORD, ( 2<<8 | i));
         `SPI_WRITE16 (`WB_RAM2 + i + 1, `WB_LOWER_HALF_WORD, ( 2<<8 | (i+1)));         
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE16 (`WB_RAM3 + i, `WB_UPPER_HALF_WORD, ( 3<<8 | i));
         `SPI_WRITE16 (`WB_RAM3 + i + 1, `WB_LOWER_HALF_WORD, ( 3<<8 | (i+1)));         
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ16 (`WB_RAM0 + i, `WB_UPPER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 0/0", read16, i);
         `SPI_READ16 (`WB_RAM0 + i+1, `WB_LOWER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 0/0", read16, i+1);         
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ16 (`WB_RAM1 + i, `WB_UPPER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/0", read16, (1 << 8 | i ));
         `SPI_READ16 (`WB_RAM1 + i + 1, `WB_LOWER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/1", read16, (1 << 8 | (i + 1) ));         
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ16 (`WB_RAM2 + i, `WB_UPPER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/0", read16, (2 << 8 | i ));
         `SPI_READ16 (`WB_RAM2 + i + 1, `WB_LOWER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/1", read16, (2 << 8 | (i + 1) ));                  
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ16 (`WB_RAM3 + i, `WB_UPPER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/0", read16, (3 << 8 | i ));
         `SPI_READ16 (`WB_RAM3 + i + 1, `WB_LOWER_HALF_WORD, read16);
         `TEST_COMPARE("READING16 1/1", read16, (3 << 8 | (i + 1) ));         
      end
      
      repeat (2000) @(posedge `WB_CLK);
      
      $display("8 Bit Access");
      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE8 (`WB_RAM0 + i,     `WB_BYTE_0, i);
         `SPI_WRITE8 (`WB_RAM0 + i + 1, `WB_BYTE_1, i+1);
         `SPI_WRITE8 (`WB_RAM0 + i + 2, `WB_BYTE_2, i+2);
         `SPI_WRITE8 (`WB_RAM0 + i + 3, `WB_BYTE_3, i+3);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE8 (`WB_RAM1 + i,     `WB_BYTE_0, i);
         `SPI_WRITE8 (`WB_RAM1 + i + 1, `WB_BYTE_1, i+1);
         `SPI_WRITE8 (`WB_RAM1 + i + 2, `WB_BYTE_2, i+2);
         `SPI_WRITE8 (`WB_RAM1 + i + 3, `WB_BYTE_3, i+3);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE8 (`WB_RAM2 + i,     `WB_BYTE_0, i);
         `SPI_WRITE8 (`WB_RAM2 + i + 1, `WB_BYTE_1, i+1);
         `SPI_WRITE8 (`WB_RAM2 + i + 2, `WB_BYTE_2, i+2);
         `SPI_WRITE8 (`WB_RAM2 + i + 3, `WB_BYTE_3, i+3);
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_WRITE8 (`WB_RAM3 + i,     `WB_BYTE_0, i);
         `SPI_WRITE8 (`WB_RAM3 + i + 1, `WB_BYTE_1, i+1);
         `SPI_WRITE8 (`WB_RAM3 + i + 2, `WB_BYTE_2, i+2);
         `SPI_WRITE8 (`WB_RAM3 + i + 3, `WB_BYTE_3, i+3);
      end
      
      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ8 (`WB_RAM0 + i,    `WB_BYTE_0, read8);
         `TEST_COMPARE("READING8 0/0", read8, i);
         `SPI_READ8 (`WB_RAM0 + i+1, `WB_BYTE_1, read8);
         `TEST_COMPARE("READING8 0/1", read8, i+1);
         `SPI_READ8 (`WB_RAM0 + i+2, `WB_BYTE_2, read8);
         `TEST_COMPARE("READING8 0/2", read8, i+2);         
         `SPI_READ8 (`WB_RAM0 + i+3, `WB_BYTE_3, read8);
         `TEST_COMPARE("READING8 0/3", read8, i+3);                  
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ8 (`WB_RAM1 + i,    `WB_BYTE_0, read8);
         `TEST_COMPARE("READING8 1/0", read8, i);
         `SPI_READ8 (`WB_RAM1 + i+1, `WB_BYTE_1, read8);
         `TEST_COMPARE("READING8 1/1", read8, i+1);
         `SPI_READ8 (`WB_RAM1 + i+2, `WB_BYTE_2, read8);
         `TEST_COMPARE("READING8 1/2", read8, i+2);         
         `SPI_READ8 (`WB_RAM1 + i+3, `WB_BYTE_3, read8);
         `TEST_COMPARE("READING8 1/3", read8, i+3);                  
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ8 (`WB_RAM2 + i,    `WB_BYTE_0, read8);
         `TEST_COMPARE("READING8 2/0", read8, i);
         `SPI_READ8 (`WB_RAM2 + i+1, `WB_BYTE_1, read8);
         `TEST_COMPARE("READING8 2/1", read8, i+1);
         `SPI_READ8 (`WB_RAM2 + i+2, `WB_BYTE_2, read8);
         `TEST_COMPARE("READING8 2/2", read8, i+2);         
         `SPI_READ8 (`WB_RAM2 + i+3, `WB_BYTE_3, read8);
         `TEST_COMPARE("READING8 2/3", read8, i+3);                  
      end

      for (i=0; i<loop_size; i=i+4) begin
         `SPI_READ8 (`WB_RAM3 + i,    `WB_BYTE_0, read8);
         `TEST_COMPARE("READING8 3/0", read8, i);
         `SPI_READ8 (`WB_RAM3 + i+1, `WB_BYTE_1, read8);
         `TEST_COMPARE("READING8 3/1", read8, i+1);
         `SPI_READ8 (`WB_RAM3 + i+2, `WB_BYTE_2, read8);
         `TEST_COMPARE("READING8 3/2", read8, i+2);         
         `SPI_READ8 (`WB_RAM3 + i+3, `WB_BYTE_3, read8);
         `TEST_COMPARE("READING8 3/3", read8, i+3);                  
      end      
      

      
      repeat (2000) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end

endmodule // test_case
