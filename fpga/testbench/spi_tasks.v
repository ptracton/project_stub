//                              -*- Mode: Verilog -*-
// Filename        : spi_tasks.v
// Description     : SPI Tasks
// Author          : Philip Tracton
// Created On      : Sat Jul 24 17:23:33 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Jul 24 17:23:33 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ns
`include "simulation_includes.vh"

module spi_tasks;

   reg spi_busy;
   initial spi_busy = 0;

   reg [15:0] spi_config_word = ( 1 << 12 |  // Interrupt Enable
                                  64         // 40 bits per transfer
                                  );

   reg [15:0] spi_start_transfer32 = ( 1 << 12 |  // Interrupt Enable
                                       1 <<  8 |  // Start Transfer
                                       64         // 40 bits per transfer
                                       );

   reg [15:0] spi_start_transfer16 = ( 1 << 12 |  // Interrupt Enable
                                       1 <<  8 |  // Start Transfer
                                       48         // 40 bits per transfer
                                       );

   reg [15:0] spi_start_transfer8 = ( 1 << 12 |  // Interrupt Enable
                                       1 <<  8 |  // Start Transfer
                                       40         // 40 bits per transfer
                                       );


   task spi_config;
      begin
`ifdef MODELSIM
         $display("TASK: SPI Configure");
`else
         $display("\033[93mTASK: SPI Configure\033[0m");
`endif
         @(posedge `SPI_CLK);


         // CTRL Register
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_config_word);

         repeat(5) @(posedge `SPI_CLK);

         // Divider
         // f_sclk = f_wb/((DIVIDER + 1) *2)
         // 50/((24+1) *2) should be a 1Mhz SPI CLK
         `SPI_MASTER0.wb_wr1(32'hFFFF_0014, 4'h1,  24);

         repeat(5) @(posedge `SPI_CLK);
      end
   endtask // spi_config

   task spi_write_wishbone32;
      input [18:0] address;
      input [3:0]  select;
      input [31:0] data;
      reg [63:0]   shift_value;
      begin

         // make sure no other SPI transaction are in progress
         while(spi_busy == 1) begin
         end

         $display("SPI_WRITE32: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);

         spi_busy = 1;
         shift_value = {1'b1, select, address, data, 8'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[63:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer32);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         spi_busy = 0;
      end
   endtask // spi_write_wishbone32

   task spi_write_wishbone16;
      input [18:0] address;
      input [3:0]  select;
      input [15:0] data;
      reg [47:0]   shift_value;
      begin

         // make sure no other SPI transaction are in progress
         while(spi_busy == 1) begin
         end

         $display("SPI_WRITE16: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);

         spi_busy = 1;
         shift_value = {1'b1, select, address, data, 8'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[47:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer16);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         spi_busy = 0;
      end
   endtask // spi_write_wishbone16


   task spi_write_wishbone8;
      input [18:0] address;
      input [3:0]  select;
      input [7:0] data;
      reg [39:0]   shift_value;
      begin

         // make sure no other SPI transaction are in progress
         while(spi_busy == 1) begin
         end

         $display("SPI_WRITE8: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);

         spi_busy = 1;
         shift_value = {1'b1, select, address, data, 8'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[39:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer8);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         spi_busy = 0;
      end
   endtask // spi_write_wishbone16

   task spi_read_wishbone32;
      input  [18:0] address;
      input  [3:0]  select;
      output [31:0] data;
      reg [63:0]    shift_value;
      begin
         while(spi_busy == 1) begin
         end
         spi_busy = 1;
         shift_value = {1'b0, select, address, 8'h00, 32'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[63:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer32);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         `SPI_MASTER0.wb_rd1(32'hFFFF_0000, 4'hF,  data);
         spi_busy = 0;
         $display("SPI_READ32: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);
      end
   endtask // spi_read_wishbone32

   task spi_read_wishbone16;
      input  [18:0] address;
      input  [3:0]  select;
      output [31:0] data;
      reg [63:0]    shift_value;
      begin
         while(spi_busy == 1) begin
         end
         spi_busy = 1;
         shift_value = {1'b0, select, address, 8'h00, 16'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[63:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer16);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         `SPI_MASTER0.wb_rd1(32'hFFFF_0000, 4'hF,  data);
         spi_busy = 0;
         $display("SPI_READ16: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);
      end
   endtask // spi_read_wishbone32

   task spi_read_wishbone8;
      input  [18:0] address;
      input  [3:0]  select;
      output [7:0] data;
      reg [39:0]    shift_value;
      begin
         while(spi_busy == 1) begin
         end
         spi_busy = 1;
         shift_value = {1'b0, select, address, 8'h00, 8'h00};
         `SPI_MASTER0.wb_wr1(32'hFFFF_0004, 4'hF,  shift_value[39:32]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0000, 4'hF,  shift_value[31:00]);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  1);  //LOWER SS
         `SPI_MASTER0.wb_wr1(32'hFFFF_0010, 4'h3,  spi_start_transfer8);
         @(posedge `TB.spi0_int);
         `SPI_MASTER0.wb_wr1(32'hFFFF_0018, 4'h1,  0);  //RAISE SS
         `SPI_MASTER0.wb_rd1(32'hFFFF_0000, 4'hF,  data);
         spi_busy = 0;
         $display("SPI_READ8: Address = 0x%x Select = 0x%x Data = 0x%x @ %d", address, select, data, $time);
      end
   endtask // spi_read_wishbone32



endmodule // spi_tasks
