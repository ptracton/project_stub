//                              -*- Mode: Verilog -*-
// Filename        : wb_master_interface.sv
// Description     : Wishbone Master Module
// Author          : Philip Tracton
// Created On      : Mon Jun 21 15:44:14 2021
// Last Modified By: Philip Tracton
// Last Modified On: Mon Jun 21 15:44:14 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!


module wb_master_interface (
                            // WB Interface
                            wb_if.master wb,
                            
                            // Control signals for state machine
                            input               start,
                            input [31:0]        address,
                            input [3:0]         selection,
                            input               write,
                            input [31:0]      data_wr,
                            output reg [31:0] data_rd,
                            
                            output wire         active
                            );
   
   
   enum                                         logic [1:0] {STATE_IDLE, STATE_WAIT_ACK, STATE_ERROR} state;
   
   assign active = state != STATE_IDLE;
   
   always_ff @(posedge wb.wb_clk)
     if (wb.wb_rst) begin
        state <= STATE_IDLE;
        wb.wb_adr  <= 32'h0000_0000;
        wb.wb_wdat <= 0;
        wb.wb_sel  <= 0;
        wb.wb_we   <= 0;
        wb.wb_cyc  <= 0;
        wb.wb_stb  <= 0;
        //        wb.wb_cti <= 1;
        //        wb.wb_bte <= 0;
        data_rd   <= 0;
        
     end else begin // if (wb_rst)
        case (state)
          STATE_IDLE: begin
             wb.wb_adr  <= 32'h0000_0000;
             wb.wb_wdat <= 0;
             wb.wb_sel  <= 0;
             wb.wb_we   <= 0;
             wb.wb_cyc  <= 0;
             wb.wb_stb  <= 0;
             // wb.wb_cti <= 1;
             // wb.wb_bte <= 0;
             if (start) begin
                state <= STATE_WAIT_ACK;
                wb.wb_adr <= address;
                wb.wb_wdat <= data_wr;
                wb.wb_sel <= selection;
                wb.wb_we  <= write;
                wb.wb_cyc <= 1;
                wb.wb_stb <= 1;
                // wb.wb_cti <= 1;
                // wb.wb_bte <= 0;
                data_rd  <=0;
                
             end else begin
                state <= STATE_IDLE;
             end
          end // case: STATE_IDLE
          
          STATE_WAIT_ACK: begin
             wb.wb_cyc <= 1;
             wb.wb_stb <= 1;
             // wb.wb_cti <= 1;
             // wb.wb_bte <= 0;
             
             if (wb.wb_err || wb.wb_rty) begin
                state <= STATE_ERROR;
             end else if (wb.wb_ack) begin
		if (!write) begin
		   data_rd <= wb.wb_rdat;
		end
                state <= STATE_IDLE;
                wb.wb_stb <= 0;
                wb.wb_cyc <= 0;
             end else begin
                state <= STATE_WAIT_ACK;
             end
          end // case: STATE_WAIT_ACK
          
          STATE_ERROR: begin
             state <= STATE_IDLE;
          end
          default: begin
             state <= STATE_IDLE;
          end
        endcase // case (state)
        
     end // else: !if(wb.wb_rst)

endmodule // wb_master_interface
