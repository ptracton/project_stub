//                              -*- Mode: Verilog -*-
// Filename        : testbench.v
// Description     : Wishbone DSP Testbench
// Author          : Philip Tracton
// Created On      : Wed Dec  2 13:12:45 2015
// Last Modified By: Philip Tracton
// Last Modified On: Wed Dec  2 13:12:45 2015
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "simulation_includes.vh"

module testbench (/*AUTOARG*/ ) ;

   //
   // Creates a clock, reset, a timeout in case the sim never stops,
   // and pass/fail managers
   //
`include "test_management.v"

   //
   // Free running system clock originally 2.8MHz but FPGA requires at least 4.67 MHZ, so
   // this was doubled to 5.6MHz
   //
   reg wb_clk;
   initial begin
      wb_clk <= 0;
      forever begin
         #(5) wb_clk <= ~wb_clk;
      end
   end

   //
   // System reset
   //
   reg wb_rst;
   initial begin
      wb_rst <= 0;
      #200 wb_rst <= 1;
      #600 wb_rst <= 0;
   end


   wire        tx;
   wire        rx;
   wire        sclk;
   wire [7:0]  nss;
   wire        mosi;
   wire        miso;
   
   top dut(
           //
           // System Interface
           //
           .clk(wb_clk),
           .rst(wb_rst),

           //
           // UART Interface
           //
           .tx(tx),
           .rx(rx),

           //
           // SPI Slave Interface
           //
           .sclk(sclk),
           .nss(nss[0]),
           .miso(miso),
           .mosi(mosi)           
           
           ) ;


   /****************************************************************************
    UART 0 -- This is used for CLI Interfacing

    The WB UART16550 from opencores is used here to simulate a UART on the other end
    of the cable.  It will allow us to send/receive characters to the NGMCU firmware
    ***************************************************************************/

   //
   // Free Running 50 MHz Clock
   //
   reg clk_tb;

   parameter   _clk_50mhz_high = 10,
     _clk_50mhz_low  = 10,
     _clk_50mhz_period = _clk_50mhz_high + _clk_50mhz_low;

   initial
     begin
        clk_tb <= 'b0;
        forever
          begin
             #(_clk_50mhz_low)  clk_tb = 1;
             #(_clk_50mhz_high) clk_tb = 0;
          end
     end

   //
   // Asynch. Reset to device
   //
   reg reset_tb;
   initial
     begin
        reset_tb = 0;
        #1    reset_tb = 1;
        #200  reset_tb = 0;
     end


   wire [31:0] uart0_adr;
   wire [31:0] uart0_dat_o;
   wire [31:0] uart0_dat_i;
   wire [3:0]  uart0_sel;
   wire        uart0_cyc;
   wire        uart0_stb;
   wire        uart0_we;
   wire        uart0_ack;
   wire        uart0_int;

   wire [31:0] spi0_adr;
   wire [31:0] spi0_dat_o;
   wire [31:0] spi0_dat_i;
   wire [3:0]  spi0_sel;
   wire        spi0_cyc;
   wire        spi0_stb;
   wire        spi0_we;
   wire        spi0_ack;
   wire        spi0_int;

   reg         test_failed;
   reg [31:0]  read_word;
   

   initial begin
      test_failed <= 0;
      read_word <= 0;
   end


   assign      uart0_dat_o[31:8] = 'b0;



   uart_top uart0(
                  .wb_clk_i(clk_tb),
                  .wb_rst_i(reset_tb),

                  .wb_adr_i(uart0_adr[4:0]),
                  .wb_dat_o(uart0_dat_o),
                  .wb_dat_i(uart0_dat_i),
                  .wb_sel_i(uart0_sel),
                  .wb_cyc_i(uart0_cyc),
                  .wb_stb_i(uart0_stb),
                  .wb_we_i(uart0_we),
                  .wb_ack_o(uart0_ack),
                  .int_o(uart0_int),
                  .stx_pad_o(rx),
                  .srx_pad_i(tx),

                  .rts_pad_o(),
                  .cts_pad_i(1'b0),
                  .dtr_pad_o(),
                  .dsr_pad_i(1'b0),
                  .ri_pad_i(1'b0),
                  .dcd_pad_i(1'b0),

                  .baud_o()
                  );


   wb_mast uart_master0(
                        .clk (clk_tb),
                        .rst (reset_tb),
                        .adr (uart0_adr),
                        .din (uart0_dat_o),
                        .dout(uart0_dat_i),
                        .cyc (uart0_cyc),
                        .stb (uart0_stb),
                        .sel (uart0_sel),
                        .we  (uart0_we ),
                        .ack (uart0_ack),
                        .err (1'b0),
                        .rty (1'b0)
                        );


   spi_top spi0
     (
      // Wishbone signals
      .wb_clk_i(clk_tb), 
      .wb_rst_i(reset_tb), 
      .wb_adr_i(spi0_adr[4:0]), 
      .wb_dat_i(spi0_dat_i), 
      .wb_dat_o(spi0_dat_o), 
      .wb_sel_i(spi0_sel),
      .wb_we_i(spi0_we), 
      .wb_stb_i(spi0_stb), 
      .wb_cyc_i(spi0_cyc), 
      .wb_ack_o(spi0_ack), 
      .wb_err_o(spi0_err), 
      .wb_int_o(spi0_int),
      
      // SPI signals
      .ss_pad_o(nss), 
      .sclk_pad_o(sclk), 
      .mosi_pad_o(mosi), 
      .miso_pad_i(miso)
      );
   

   wb_mast spi_master0(
                       .clk (clk_tb),
                       .rst (reset_tb),
                       .adr (spi0_adr),
                       .din (spi0_dat_o),
                       .dout(spi0_dat_i),
                       .cyc (spi0_cyc),
                       .stb (spi0_stb),
                       .sel (spi0_sel),
                       .we  (spi0_we ),
                       .ack (spi0_ack),
                       .err (1'b0),
                       .rty (1'b0)     
                       );

      
   //
   // UART Support Tasks
   //
   reg UART_VALID;
   uart_tasks uart_tasks();
   initial begin
      UART_VALID = 0;
      @(negedge reset_tb);
      repeat(100) @(posedge clk_tb);
      `UART_CONFIG;
      repeat(10) @(posedge clk_tb);
      UART_VALID = 1;
      $display("UART VALID @ %d", $time);
   end

   //
   // UART Support Tasks
   //
   reg SPI_VALID;
   spi_tasks spi_tasks();
   initial begin
      SPI_VALID = 0;
      @(negedge reset_tb);
      repeat(100) @(posedge clk_tb);
      `SPI_CONFIG;
      repeat(10) @(posedge clk_tb);
      SPI_VALID = 1;
      $display("SPI VALID @ %d", $time);
   end

   
   //
   // Tasks used to help test cases
   //
   test_tasks test_tasks();

   //
   // UART Communications Tasks
   //
   comm_tasks comm_tasks();
   
   
   //
   // The actual test cases that are being tested
   //
   test_case test_case();
   
   initial begin
      if ($test$plusargs("slow")) begin
         $sdf_annotate("../backend/basys3/implementation/top_timesim.sdf", testbench.dut, "", "sdf_slow.log", "MAXIMUM");
         $display (" SLOW DELAY SIMULATION: MAXIMUM SDF DATA BEING USED");
      end else if ($test$plusargs("fast")) begin
         $sdf_annotate("../backend/basys3/implementation/top_timesim.sdf", testbench.dut, "", "sdf_fast.log", "MINIMUM");
         $display (" FAST DELAY SIMULATION: MAXIMUM SDF DATA BEING USED");         
      end else begin
         $display (" NO SDF DATA USED");         
      end
   end
endmodule // testbench
