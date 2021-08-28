//                              -*- Mode: Verilog -*-
// Filename        : spi_basic_01.v
// Description     : Burst operation testing
// Author          : Philip Tracton
// Created On      : Sat Aug 14 20:16:10 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Aug 14 20:16:10 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module test_case (/*AUTOARG*/ ) ;
`include "system_includes.vh"
`include "simulation_includes.vh"

   //
   // Test Configuration
   // These parameters need to be set for each test case
   //
   parameter simulation_name = "spi_basic_00";
   parameter number_of_tests = 896;

   reg [127:0]   shift_value;
   reg [18:0]    address;
   reg [3:0]     select;
   reg [31:0]    data0;
   reg [31:0]    data1;
   reg [31:0]    data2;
   reg [15:0]    spi_start_transfer32 = ( 1 << 12 |  // Interrupt Enable
                                          1 <<  8 |  // Start Transfer
                                          00         // 128 bits per transfer
                                          );
   initial begin

      $display("SPI Burst Test Case");
      @(negedge `WB_RST);
      @(posedge `TB.SPI_VALID);
      repeat (100) @(posedge `WB_CLK);

      address = `WB_RAM0;  //19'h4_0000
      select = `WB_FULL_WORD; // 4'hf
      data0 = 32'h0101_2323;
      data1 = 32'h4545_6767;
      data2 = 32'h89FF_ABAB;
      
      shift_value = {1'b1, select, address, data0, data1, data2, 8'h00 };
      `SPI_MASTER0.wb_wr1(32'hFFFF_000C, 4'hF,  shift_value[127:96]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0008, 4'hF,  shift_value[95:64]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[63:32]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);

      `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
      `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer32);
      @(posedge `TB.spi0_int);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS

      address = `WB_RAM0 + 19'h0_0010;      
      shift_value = {1'b1, select, address, 32'hdead_beef, 32'hF00D_FEED, 32'ha5b6_c7d8, 8'h00};
//      shift_value = {32'hABCD_1112, 32'hF00D_FEED, 32'ha5b6_c7d8, 32'h0001_0002};
      `SPI_MASTER0.wb_wr1(32'hFFFF_000C, 4'hF,  shift_value[127:96]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0008, 4'hF,  shift_value[95:64]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[63:32]);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
      
      `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
      `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer32);

      @(posedge `TB.spi0_int);
      `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS

//      `SPI_WRITE32 (`WB_RAM0, `WB_FULL_WORD, 32'h0123_4567);

      // repeat (200) @(posedge `WB_CLK);
      // `SPI_WRITE16 (`WB_RAM1, `WB_UPPER_HALF_WORD, 16'DEAD);

      // repeat (200) @(posedge `WB_CLK);
      // `SPI_WRITE16 (`WB_RAM2, `WB_LOWER_HALF_WORD, 16'DEAD);

      // repeat (200) @(posedge `WB_CLK);
      // `SPI_WRITE8 (`WB_RAM3 + i,     `WB_BYTE_0, i);

      repeat (2000) @(posedge `WB_CLK);
      `TEST_COMPLETE;
   end


endmodule // test_case
