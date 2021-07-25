//                              -*- Mode: Verilog -*-
// Filename        : wb_ram_new.sv
// Description     : WB RAM with module interface
// Author          : Philip Tracton
// Created On      : Sat Jul 24 21:08:48 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Jul 24 21:08:48 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!

module wb_ram
  #(//Wishbone parameters
    parameter dw = 32,
    //Memory parameters
    parameter depth = 256,
    parameter aw    = $clog2(depth),
    parameter memfile = "")
   (wb_if.slave wb);
   
`include "wb_common.v"
   reg [aw-1:0]     adr_r;
   
   wire [aw-1:0]    next_adr;
   
   wire             valid = wb.wb_cyc & wb.wb_stb;
   
   reg              valid_r;
   
   reg              is_last_r;
   always @(posedge wb.wb_clk)
     is_last_r <= wb_is_last(wb.wb_cti);
   wire             new_cycle = (valid & !valid_r) | is_last_r;
   
   assign next_adr = wb_next_adr(adr_r, wb.wb_cti, wb.wb_bte, dw);
   
   wire [aw-1:0]    adr = new_cycle ? wb.wb_adr : next_adr;
   
   always@(posedge wb.wb_clk) begin
      adr_r   <= adr;
      valid_r <= valid;
      //Ack generation
      wb.wb_ack <= valid & (!((wb.wb_cti == 3'b000) | (wb.wb_cti == 3'b111)) | !wb.wb_ack);
      if(wb.wb_rst) begin
         adr_r <= {aw{1'b0}};
      valid_r <= 1'b0;
      //      wb_ack_o <= 1'b0;
   end      
   end // always@ (posedge wb.wb_clk)   
   
   wire ram_we = wb.wb_we & valid & wb.wb_ack;
   
   //TODO:ck for burst address errors
   assign wb_err_o =  1'b0;
   
   wb_ram_generic
     #(.depth(depth/4),
       .memfile (memfile))
   ram0
     (.clk (wb.wb_clk),
      .we  ({4{ram_we}} & wb.wb_sel),
      .din (wb.wb_wdat),
      .waddr(adr_r[aw-1:2]),
      .raddr (adr[aw-1:2]),
      .dout (wb.wb_rdat));



endmodule // wb_ram
