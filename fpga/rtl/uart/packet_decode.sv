//                              -*- Mode: Verilog -*-
// Filename        : packet_decode.v
// Description     : UART Packet Decoder
// Author          : Philip Tracton
// Created On      : Thu May 16 19:46:03 2019
// Last Modified By: Philip Tracton
// Last Modified On: Thu May 16 19:46:03 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "packet_decode.vh"

module packet_decode (/*AUTOARG*/
   // Outputs
   cpu_address, cpu_start, cpu_selection, cpu_write, cpu_data_wr,
   transmit, tx_byte,
   // Inputs
   clk, rst, rx_byte, received, recv_error, is_transmitting,
   cpu_data_rd, cpu_active
   ) ;


   parameter dw = 32;
   parameter aw = 32;
   parameter DEBUG = 0;

   input clk;
   input rst;
   input [7:0] rx_byte;
   input       received;
   input       recv_error;
   input       is_transmitting;

   output reg [aw-1:0] cpu_address;
   output reg          cpu_start;
   output reg [3:0]    cpu_selection;
   output reg          cpu_write;
   output reg [dw-1:0] cpu_data_wr;

   output reg          transmit;
   output reg [7:0]    tx_byte;

   input [dw-1:0]      cpu_data_rd;
   input               cpu_active;

   reg [7:0]           file_num;
   reg                 file_write;
   reg                 file_read;
   reg [31:0]          file_write_data;
   wire [31:0]         file_read_data = 32'h0;;
   wire                file_active = 1'b0;

   reg [7:0]           state;

   // localparam STATE_IDLE                    = 8'h00;
   // localparam STATE_COMMAND                 = 8'h01;
   // localparam STATE_LENGTH                  = 8'h02;
   // localparam STATE_READ_START_ADDRESS      = 8'h03;
   // localparam STATE_CPU_DOWNLOAD_MEMORY     = 8'h04;
   // localparam STATE_CPU_WRITE_MEMORY        = 8'h05;
   // localparam STATE_CPU_READ_MEMORY         = 8'h06;
   // localparam STATE_CPU_READ_MEMORY_DONE    = 8'h07;
   // localparam STATE_CPU_UPLOAD_MEMORY       = 8'h08;
   // localparam STATE_CPU_UPLOAD_MEMORY_DONE  = 8'h09;

   // TODO: Grey Code this state machine!
   enum {
         STATE_IDLE                    = 8'h00,
         STATE_COMMAND                 = 8'h01,
         STATE_LENGTH                  = 8'h02,
         STATE_READ_START_ADDRESS      = 8'h03,
         STATE_CPU_DOWNLOAD_MEMORY     = 8'h04,
         STATE_CPU_WRITE_MEMORY        = 8'h05,
         STATE_CPU_READ_MEMORY         = 8'h06,
         STATE_CPU_READ_MEMORY_DONE    = 8'h07,
         STATE_CPU_UPLOAD_MEMORY       = 8'h08,
         STATE_CPU_UPLOAD_MEMORY_DONE  = 8'h09
         
         } packet_state;
   
   

   //`define STATE_READ_START_ADDRESS_2 8'h05
   //`define STATE_READ_START_ADDRESS_3 8'h06

   reg [3:0]           size;
   reg [3:0]           command;
   reg [7:0]           length;
   reg [31:0]          start_address;

   reg [7:0]           byte_count;
   reg [7:0]           samples_transferred;


   wire                decode_cpu_command   = (command == `PKT_COMMAND_CPU_WRITE) | (command == `PKT_COMMAND_CPU_READ);
   wire                decode_read_command  = (command == `PKT_COMMAND_CPU_READ);
   wire                decode_write_command = (command == `PKT_COMMAND_CPU_WRITE);

   always @(posedge clk)
     begin
        if (rst) begin
           command <= 0;
           length <= 0;
           size <= 0;
           start_address <= 0;
           byte_count <= 0;
           samples_transferred <= 0;
           cpu_address <= 0;
           cpu_start <= 0;
           cpu_selection <= 0;
           cpu_write <= 0;
           cpu_data_wr <= 0;
           transmit <=0;
           tx_byte <= 0;

           file_num <= 0;
           file_write_data <= 32'h0;
           file_write <= 0;
           file_read <= 0;
        end else begin
           case (packet_state)
             STATE_IDLE: begin
                if (received && (rx_byte == `PKT_PREAMBLE)) begin
                   command <= 0;
                   length <= 0;
                   size <= 0;
                   start_address <= 0;
                   byte_count <= 0;
                   samples_transferred <= 0;
                   cpu_address <= 0;
                   cpu_start <= 0;
                   cpu_selection <= 0;
                   cpu_write <= 0;
                   cpu_data_wr <= 0;
                   transmit <=0;
                   tx_byte <= 0;

                   file_num <= 0;
                   file_write_data <= 32'h0;
                   file_write <= 0;
                   file_read <= 0;
                   packet_state <= STATE_COMMAND;

                end else begin
                   packet_state <= STATE_IDLE;
                end
             end

             STATE_COMMAND: begin

                if (recv_error) begin
                   packet_state <= STATE_IDLE;
                end else if (received) begin
                   command <= rx_byte[3:0];
                   size <= rx_byte[7:4];
                   packet_state <= STATE_LENGTH;
                end else begin
                   packet_state <= STATE_COMMAND;
                end
             end

             STATE_LENGTH: begin
                if (recv_error) begin
                   packet_state <= STATE_IDLE;
                end else if (received) begin
                   length <= rx_byte;
                   if (decode_cpu_command) begin
                      byte_count <= 0;
                      packet_state <= STATE_READ_START_ADDRESS;
                   end
                end else begin
                   packet_state <= STATE_LENGTH;
                end
             end

             STATE_READ_START_ADDRESS: begin
                if (recv_error) begin
                   packet_state <= STATE_IDLE;
                end else if (received) begin
                   start_address[(byte_count*8)+:8] <= rx_byte;
                   byte_count <= byte_count + 1;
                   if (byte_count >= 3) begin
                      byte_count <= 0;
                      samples_transferred <= 0;
                      cpu_data_wr <=0;
                      if (decode_write_command) begin
                         packet_state <= STATE_CPU_DOWNLOAD_MEMORY;
                      end else begin
                         byte_count <= 0;
                         packet_state <= STATE_CPU_READ_MEMORY;
                      end
                   end
                end else begin
                   packet_state <= STATE_READ_START_ADDRESS;
                end
             end

             STATE_CPU_DOWNLOAD_MEMORY: begin
                if (recv_error) begin
                   packet_state <= STATE_IDLE;
                end else if (samples_transferred >= length) begin
                   packet_state <= STATE_IDLE;
                end else if (received) begin
                   cpu_data_wr[(byte_count*8)+:8] <= rx_byte;
                   byte_count <= byte_count + 1;
                   if (byte_count >= 3) begin
                      byte_count <= 0;
                      samples_transferred <= samples_transferred + 1;
                      packet_state <= STATE_CPU_WRITE_MEMORY;
                   end
                end else begin
                   packet_state <= STATE_CPU_DOWNLOAD_MEMORY;
                end
             end

             STATE_CPU_WRITE_MEMORY: begin
                cpu_address <= start_address;
                cpu_selection <= size;
                cpu_write <= 1;
                cpu_start <= 1;
                if (!cpu_active) begin
                   packet_state <= STATE_CPU_WRITE_MEMORY;
                end else begin
                   cpu_start <= 0;
                   cpu_write <= 0;
                   start_address <= start_address + 4; //Doing words for now
                   packet_state <= STATE_CPU_DOWNLOAD_MEMORY;
                end
             end


             STATE_CPU_READ_MEMORY: begin
                cpu_address <= start_address;
                cpu_selection <= size;
                cpu_write <= 0;
                cpu_start <= 1;
                if ((byte_count >= 4) && (samples_transferred >= length))begin
                   packet_state <= STATE_IDLE;
                   cpu_start <= 0;
                end else if (!cpu_active) begin
                   packet_state <= STATE_CPU_READ_MEMORY;
                end else begin
                   packet_state <= STATE_CPU_READ_MEMORY_DONE;
                end
             end // case: STATE_CPU_READ_MEMORY

             STATE_CPU_READ_MEMORY_DONE:begin
                cpu_start <= 0;
                cpu_write <= 0;
                if ((byte_count >= 4) && (samples_transferred >= length))begin
                   packet_state <= STATE_IDLE;
                end else if (cpu_active) begin
                   packet_state <= STATE_CPU_READ_MEMORY_DONE;
                end else begin
                   tx_byte <= 0;
                   transmit <= 0;
                   byte_count <= 0;
                   packet_state <= STATE_CPU_UPLOAD_MEMORY;
                end
             end

             STATE_CPU_UPLOAD_MEMORY:begin
                tx_byte <= cpu_data_rd[(byte_count*8)+:8];
                transmit <= 1;
                if (is_transmitting == 1'b0) begin
                   packet_state <= STATE_CPU_UPLOAD_MEMORY;
                end else begin
                   packet_state <= STATE_CPU_UPLOAD_MEMORY_DONE;
                   transmit <= 0;
                   byte_count <= byte_count + 1;
                end
             end // case: STATE_CPU_UPLOAD_MEMORY

             STATE_CPU_UPLOAD_MEMORY_DONE:begin
                if (is_transmitting == 1'b1) begin
                   packet_state <= STATE_CPU_UPLOAD_MEMORY_DONE;
                end else begin
                   if (byte_count >= 4) begin
                      samples_transferred <= samples_transferred + 1;
                      if (samples_transferred >= length) begin
                         packet_state <= STATE_IDLE;
                      end else begin
                         packet_state <= STATE_CPU_READ_MEMORY;
                         start_address <= start_address + 4;
                      end
                   end else begin
                      packet_state <= STATE_CPU_UPLOAD_MEMORY;
                   end
                end
             end // case: STATE_CPU_UPLOAD_MEMORY_DONE


             default: begin
                packet_state <= STATE_IDLE;
             end

           endcase // case (packet_state)
        end
     end // always @ (*)


endmodule // packet_decode
