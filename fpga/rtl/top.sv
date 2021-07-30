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
   input wire    sclk;
   input wire    nss;
   input wire    mosi;
   output wire   miso;

   /****************************************************************************
    BUS MATRIX

    This is the auto-generated BUS MATRIX
    ***************************************************************************/
`include "bus_matrix.vh"


   /****************************************************************************
    SYSTEM CONTROLLER

    This module handles the system clock and reset signals
    ***************************************************************************/
   syscon syscon_inst(
                      // Outputs
                      .wb_clk(wb_clk),
                      .wb_rst(wb_rst),
                      // Inputs
                      .clk(clk),
                      .rst(rst)
                      ) ;
   
   
   /****************************************************************************
    
    SPI Slave to Wishbone Bus Master
    
    ***************************************************************************/
   wb_if wb_spi_master(wb_clk, wb_rst);
   assign wb_m2s_spi_master_adr = wb_spi_master.master.wb_adr;
   assign wb_m2s_spi_master_dat = wb_spi_master.master.wb_wdat;
   assign wb_m2s_spi_master_sel = wb_spi_master.master.wb_sel;
   assign wb_m2s_spi_master_we  = wb_spi_master.master.wb_we;
   assign wb_m2s_spi_master_cyc = wb_spi_master.master.wb_cyc;
   assign wb_m2s_spi_master_stb = wb_spi_master.master.wb_stb;
   assign wb_m2s_spi_master_cti = 3'h00;
   assign wb_m2s_spi_master_bte = 2'h00;
                                 
   assign wb_spi_master.master.wb_rdat = wb_s2m_spi_master_dat;   
   assign wb_spi_master.master.wb_ack  = wb_s2m_spi_master_ack;
   assign wb_spi_master.master.wb_err  = wb_s2m_spi_master_err;
   assign wb_spi_master.master.wb_rty  = wb_s2m_spi_master_rty;
   
   spi_if spi(.*);
   assign spi.slave.nss = nss;
   assign spi.slave.sclk = sclk;
   assign spi.slave.mosi = mosi;
   assign miso = spi.slave.miso;
   
   spi_slave_wb_master_top spi_slave_wb_master0(
                                                .wb(wb_spi_master.master),
                                                .spi_if(spi.slave)
                                                );


   /****************************************************************************
    
    UART to Wishbone Bus Master
    
    ***************************************************************************/
   wb_if wb_uart_master(wb_clk, wb_rst);
   assign wb_m2s_uart_master_adr = wb_uart_master.master.wb_adr;
   assign wb_m2s_uart_master_dat = wb_uart_master.master.wb_wdat;
   assign wb_m2s_uart_master_sel = wb_uart_master.master.wb_sel;
   assign wb_m2s_uart_master_we  = wb_uart_master.master.wb_we;
   assign wb_m2s_uart_master_cyc = wb_uart_master.master.wb_cyc;
   assign wb_m2s_uart_master_stb = wb_uart_master.master.wb_stb;
   assign wb_m2s_uart_master_cti = 3'h00;
   assign wb_m2s_uart_master_bte = 2'h00;

   assign wb_uart_master.master.wb_rdat = wb_s2m_uart_master_dat;   
   assign wb_uart_master.master.wb_ack  = wb_s2m_uart_master_ack;
   assign wb_uart_master.master.wb_err  = wb_s2m_uart_master_err;
   assign wb_uart_master.master.wb_rty  = wb_s2m_uart_master_rty;
   
   uart_to_wishbone_master uart_wb_master0(
                                           .wb(wb_uart_master.master),
                                           .rx(rx),
                                           .tx(tx)
                                           ) ;
   

   //
   // Undriven by SRAMs, ground them so they don't float and inject X's into simulation
   //
   assign wb_s2m_ram0_rty = 0;
   assign wb_s2m_ram1_rty = 0;
   assign wb_s2m_ram2_rty = 0;
   assign wb_s2m_ram3_rty = 0;
   
   assign wb_s2m_ram0_err = 0;
   assign wb_s2m_ram1_err = 0;
   assign wb_s2m_ram2_err = 0;
   assign wb_s2m_ram3_err = 0;

   /****************************************************************************
    
    RAM 0
    
    ***************************************************************************/
   wb_if wb_ram0(wb_clk, wb_rst);
   assign wb_ram0.slave.wb_adr  = wb_m2s_ram0_adr;
   assign wb_ram0.slave.wb_wdat = wb_m2s_ram0_dat;
   assign wb_ram0.slave.wb_sel  = wb_m2s_ram0_sel;
   assign wb_ram0.slave.wb_we   = wb_m2s_ram0_we;
   assign wb_ram0.slave.wb_cyc  = wb_m2s_ram0_cyc;
   assign wb_ram0.slave.wb_stb  = wb_m2s_ram0_stb;
   assign wb_ram0.slave.wb_cti = 3'h00;
   assign wb_ram0.slave.wb_bte = 2'h00;
   
   assign wb_s2m_ram0_dat = wb_ram0.slave.wb_rdat;
   assign wb_s2m_ram0_ack = wb_ram0.slave.wb_ack;
//   assign wb_s2m_ram0_err = wb_ram0.slave.wb_err;
//   assign wb_s2m_ram0_rty = wb_ram0.slave.wb_rty;   

   wb_ram
     #(.depth(8192))
   ram0(.wb(wb_ram0.slave));

   /****************************************************************************
    
    RAM 1
    
    ***************************************************************************/
   wb_if wb_ram1(wb_clk, wb_rst);
   assign wb_ram1.slave.wb_adr  = wb_m2s_ram1_adr;
   assign wb_ram1.slave.wb_wdat = wb_m2s_ram1_dat;
   assign wb_ram1.slave.wb_sel  = wb_m2s_ram1_sel;
   assign wb_ram1.slave.wb_we   = wb_m2s_ram1_we;
   assign wb_ram1.slave.wb_cyc  = wb_m2s_ram1_cyc;
   assign wb_ram1.slave.wb_stb  = wb_m2s_ram1_stb;
   assign wb_ram1.slave.wb_cti  = 3'h00;
   assign wb_ram1.slave.wb_bte  = 2'h00;
   
   assign wb_s2m_ram1_dat = wb_ram1.slave.wb_rdat;
   assign wb_s2m_ram1_ack = wb_ram1.slave.wb_ack;
//   assign wb_s2m_ram1_err = wb_ram1.slave.wb_err;
//   assign wb_s2m_ram1_rty = wb_ram1.slave.wb_rty;
   
   wb_ram
     #(.depth(8192))
   ram1(.wb(wb_ram1.slave));

   /****************************************************************************
    
    RAM 2
    
    ***************************************************************************/
   wb_if wb_ram2(wb_clk, wb_rst);
   assign wb_ram2.slave.wb_adr  = wb_m2s_ram2_adr;
   assign wb_ram2.slave.wb_wdat = wb_m2s_ram2_dat;
   assign wb_ram2.slave.wb_sel  = wb_m2s_ram2_sel;
   assign wb_ram2.slave.wb_we   = wb_m2s_ram2_we;
   assign wb_ram2.slave.wb_cyc  = wb_m2s_ram2_cyc;
   assign wb_ram2.slave.wb_stb  = wb_m2s_ram2_stb;
   assign wb_ram2.slave.wb_cti  = 3'h00;
   assign wb_ram2.slave.wb_bte  = 2'h00;

   assign wb_s2m_ram2_dat = wb_ram2.slave.wb_rdat;
   assign wb_s2m_ram2_ack = wb_ram2.slave.wb_ack;
//   assign wb_s2m_ram2_err = wb_ram2.slave.wb_err;
//   assign wb_s2m_ram2_rty = wb_ram2.slave.wb_rty;
   
   wb_ram
     #(.depth(8192))
   ram2(.wb(wb_ram2.slave));

   /****************************************************************************
    
    RAM 3
    
    ***************************************************************************/
   
   wb_if wb_ram3(wb_clk, wb_rst);
   assign wb_ram3.slave.wb_adr  = wb_m2s_ram3_adr;
   assign wb_ram3.slave.wb_wdat = wb_m2s_ram3_dat;
   assign wb_ram3.slave.wb_sel  = wb_m2s_ram3_sel;
   assign wb_ram3.slave.wb_we   = wb_m2s_ram3_we;
   assign wb_ram3.slave.wb_cyc  = wb_m2s_ram3_cyc;
   assign wb_ram3.slave.wb_stb  = wb_m2s_ram3_stb;
   assign wb_ram3.slave.wb_cti  = 3'h00;
   assign wb_ram3.slave.wb_bte  = 2'h00;
   
   assign wb_s2m_ram3_dat = wb_ram3.slave.wb_rdat;
   assign wb_s2m_ram3_ack = wb_ram3.slave.wb_ack;
//   assign wb_s2m_ram3_err = wb_ram3.slave.wb_err;
//   assign wb_s2m_ram3_rty = wb_ram3.slave.wb_rty;
   
   wb_ram
     #(.depth(8192))
   ram3(.wb(wb_ram3.slave));

   



endmodule // top
