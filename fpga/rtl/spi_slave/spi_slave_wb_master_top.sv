//                              -*- Mode: Verilog -*-
// Filename        : spi_slave_wb_master_top.sv
// Description     : SPI Slave to Wishbone Master Top Level
// Author          : Philip Tracton
// Created On      : Sat Jul 24 13:58:30 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Jul 24 13:58:30 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module spi_slave_wb_master_top (
                                wb_if.master wb,
                                spi_if.slave spi_if
                                );


   /*AUTOREG*/

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [18:0]          address;                // From spi of spi_slave.v
   wire [31:0]          data;                   // From spi of spi_slave.v
   wire [3:0]           select;                 // From spi of spi_slave.v
   wire                 wrn;                    // From spi of spi_slave.v
   wire [31:0]          write_data;

   // End of automatics

   //
   // SPI interfacing.  Decodes the SPI to WB translation
   //
   spi_slave spi_slave(/*AUTOINST*/
                       // Interfaces
                       .spi                   (spi_if),
                       // Outputs
                       .wrn                   (wrn),
                       .select                (select[3:0]),
                       .address               (address[18:00]),
                       .data                  (data[31:0]),
                       .start                 (start),
                       .write_data            (write_data)
                       );

   //
   // We only want 1 edge in the wb.wb_clk domain
   //
   reg [1:0]            start_delay;
   wire                 start_edge = start_delay[0] & !start_delay[1];
   always @(posedge wb.wb_clk or posedge wb.wb_rst)
     if (wb.wb_rst) begin
        start_delay <= 1'b0;
     end else begin
        start_delay <= {start_delay[0], start};
     end

   //
   // WB Bus Master
   //
   wb_master_interface master(
                              // WB Interface
                              .wb(wb),

                              // Control signals for state machine
                              .start(start_edge),
                              .address({13'b0, address}),
                              .selection(select),
                              .write(wrn),
                              .data_wr(data),
                              .data_rd(write_data),

                              .active(active)
                              );

endmodule // spi_slave_wb_master_top
