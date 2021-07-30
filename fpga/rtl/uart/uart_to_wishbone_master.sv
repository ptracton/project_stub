//                              -*- Mode: Verilog -*-
// Filename        : uart_to_wishbone_master_top.v
// Description     : PC Interface
// Author          : Philip Tracton
// Created On      : Thu May 16 16:51:00 2019
// Last Modified By: Philip Tracton
// Last Modified On: Thu May 16 16:51:00 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

module uart_to_wishbone_master(
                               wb_if.master wb,
                               input wire  rx,
                               output wire tx
                               );
   
   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   wire [aw-1:0] cpu_address;
   wire          cpu_start;
   wire [3:0]    cpu_selection;
   wire          cpu_write;
   wire [dw-1:0] cpu_data_wr;


   wire [dw-1:0] cpu_data_rd;
   wire          cpu_active;

   //
   // UART Instance
   //

   wire       transmit;
   wire [7:0] tx_byte;
   wire       received;
   wire [7:0] rx_byte;
   wire       is_receiving;
   wire       is_transmitting;
   wire       recv_error;

   localparam UART_CLOCK_DIVIDE = 217;
   

   uart #(.CLOCK_DIVIDE(UART_CLOCK_DIVIDE))
   uart0(
	 .clk(wb.wb_clk), // The master clock for this module
	 .rst(wb.wb_rst), // Synchronous reset.
	 .rx(rx), // Incoming serial line
	 .tx(tx), // Outgoing serial line
	 .transmit(transmit), // Signal to transmit
	 .tx_byte(tx_byte), // Byte to transmit
	 .received(received), // Indicated that a byte has been received.
	 .rx_byte(rx_byte), // Byte received
	 .is_receiving(is_receiving), // Low when receive line is idle.
	 .is_transmitting(is_transmitting), // Low when transmit line is idle.
	 .recv_error(recv_error) // Indicates error in receiving packet.
         );


   packet_decode decode(
                        // Inputs
                        .clk(wb.wb_clk),
                        .rst(wb.wb_rst),

                        // UART
                        .rx_byte(rx_byte),
                        .received(received),
                        .recv_error(recv_error),
                        .is_transmitting(is_transmitting),
                        .tx_byte(tx_byte), // Byte to transmit
                        .transmit(transmit), // Signal to transmit

                        // CPU Bus Interface
                        .cpu_data_rd(cpu_data_rd),
                        .cpu_active(cpu_active),
                        .cpu_start(cpu_start),
                        .cpu_address(cpu_address),
                        .cpu_selection(cpu_selection),
                        .cpu_write(cpu_write),
                        .cpu_data_wr(cpu_data_wr)
                        ) ;

   //
   // WB Bus Master
   //
   wb_master_interface master(
                              // WB Interface
                              .wb(wb),

                              // Control signals for state machine
                              .start(cpu_start),
                              .address(cpu_address),
                              .selection(cpu_selection),
                              .write(cpu_write),
                              .data_wr(cpu_data_wr),
                              .data_rd(cpu_data_rd),

                              .active(cpu_active)
                              );


endmodule // uart_to_wishbone_master_top.v
