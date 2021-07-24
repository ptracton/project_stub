//                              -*- Mode: Verilog -*-
// Filename        : top.v
// Description     : Simpler DSP/ML Testing Modules
// Author          : Phil Tracton
// Created On      : Mon Apr 15 15:39:03 2019
// Last Modified By: Phil Tracton
// Last Modified On: Mon Apr 15 15:39:03 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

//`include "timescale.v"
`timescale 1ns/1ns
`include "system_includes.vh"
module top (/*AUTOARG*/
   // Outputs
   tx, miso,
   // Inputs
   clk, rst, rx, sclk, nss, mosi
   ) ;

   parameter DEBUG = 0;

   //
   // System Interface
   //
   input clk;
   input rst;

   //
   // UART Interface
   //
   input         rx;
   output        tx;

   //
   // SPI Slave Interface
   //
   input         sclk;
   input         nss;
   input         mosi;
   output        miso;

   /****************************************************************************
    
    ***************************************************************************/
   syscon syscon_inst(
                      // Outputs
                      .wb_clk(wb_clk), 
                      .wb_rst(wb_rst),
                      // Inputs
                      .clk(clk), 
                      .rst(rst)
                      ) ;

   
endmodule // top
