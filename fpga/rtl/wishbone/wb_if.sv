//                              -*- Mode: Verilog -*-
// Filename        : wb_if.sv
// Description     : Wishbone Interface
// Author          : Philip Tracton
// Created On      : Mon Jun 21 15:45:26 2021
// Last Modified By: Philip Tracton
// Last Modified On: Mon Jun 21 15:45:26 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

//
// Based on Wishbone Spec b.4
// See: http://cdn.opencores.org/downloads/wbspec_b4.pdf
//

interface wb_if(
                // Free running clock
                input wb_clk,

                // Active high, synchronous,  reset signal
                input wb_rst
                );

   parameter ADDR_WIDTH = 32;
   parameter DATA_WIDTH = 32;

   // Address to access
   logic [ADDR_WIDTH - 1 : 0] wb_adr;

   // Read data bus
   logic [DATA_WIDTH - 1 : 0] wb_rdat;

   // Write data bus
   logic [DATA_WIDTH - 1 : 0] wb_wdat;

   // indicates where valid data is expected on the [wb_rdata] signal 
   // array during READ cycles, and where it is placed on the [wb_wdata] 
   // signal array during WRITE cycles.
   logic [3:0]                wb_sel;

   // indicates whether the current local bus cycle is a READ or 
   // WRITE cycle. The signal is negated during READ cycles, and 
   // is asserted during WRITE cycles
   logic                      wb_we;

   // when asserted, indicates that a valid bus cycle is in progress.
   // The signal is asserted for the duration of all bus cycles
   logic                      wb_cyc;

   // indicates a valid data transfer cycle. It is used to qualify 
   // various other signals on the interface
   logic                      wb_stb;
   
   logic                      wb_cti;
   logic                      wb_bte;

   // Asserted on normal termination of bus cycle
   logic                      wb_ack;

   // indicates an abnormal cycle termination
   logic                      wb_err;

   // indicates that the interface is not ready to accept or send data, 
   // and that the cycle should be retried
   logic                      wb_rty;


   modport master(
                  // Outputs
                  output wb_adr,
                  output wb_wdat,
                  output wb_sel,
                  output wb_we,
                  output wb_cyc,
                  output wb_stb,
                  output wb_cti,
                  output wb_bte,

                  // Inputs
                  input  wb_clk,
                  input  wb_rst,
                  input  wb_rdat,
                  input  wb_ack,
                  input  wb_err,
                  input  wb_rty
                  );

   modport slave(
                 //Outputs
                 output wb_rdat,
                 output wb_ack,
                 output wb_err,
                 output wb_rty,

                 //Inputs
                 input  wb_clk,
                 input  wb_rst,
                 input  wb_adr,
                 input  wb_wdat,
                 input  wb_sel,
                 input  wb_we,
                 input  wb_cyc,
                 input  wb_stb,
                 input  wb_cti,
                 input  wb_bte
                 );


endinterface : wb_if
