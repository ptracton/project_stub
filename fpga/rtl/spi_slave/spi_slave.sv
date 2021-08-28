//                              -*- Mode: Verilog -*-
// Filename        : spi_slave_rx.sv
// Description     : SPI Slave RX to Wishbone Master
// Author          : Philip Tracton
// Created On      : Sat Jul 24 14:00:24 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Jul 24 14:00:24 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!
module spi_slave (
                  spi_if.slave spi,
                  output reg wrn,
                  output reg [3:0] select,
                  output reg [18:00] address,
                  output reg [31:0] data,
                  output reg start,
                  input wire [31:0] write_data
                  ) ;

`include "system_includes.vh"

   //
   // Count the number of bits in transition
   //
   reg [15:0] bit_count;

   //
   // Shift in the data from the master
   //
   reg [7:0]  data_byte;
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
        data_byte <= 8'h00;
     end else begin
        data_byte <= {data_byte[6:0], spi.mosi};
     end


   //
   // Data size management
   //
   reg [15:0] spi_read_length;
   reg [15:0] spi_write_length;
   reg [15:0] data_size;
   reg [2:0] address_increment_size;

   always_comb
     if (spi.nss) begin
        spi_read_length = 0;
        spi_write_length = 0;
        data_size = 0;
        address_increment_size =0;
     end else begin
        case(select)
          `WB_FULL_WORD:begin
             spi_read_length = 40;
             spi_write_length = 32;
             data_size = 32;
             address_increment_size =4;
          end
          `WB_UPPER_HALF_WORD,
          `WB_LOWER_HALF_WORD: begin
             spi_read_length = 24;
             spi_write_length = 16;
             data_size = 16;
             address_increment_size =2;
          end
          `WB_BYTE_0,
          `WB_BYTE_1,
          `WB_BYTE_2,
          `WB_BYTE_3: begin
             spi_read_length = 16;
             spi_write_length = 8;
             data_size = 8;
             address_increment_size =1;
          end
        endcase // case (select)
     end // else: !if(spi.nss)

   //
   // State Machine to control the protocol of the SPI messages
   //
   enum       {SPI_CONTROL,
               SPI_ADDRESS,
               SPI_WRITE,
               SPI_READ} spi_state;

   reg        capture_control;
   reg        capture_address;
   reg        capture_read;
   reg        capture_write;
   reg        start_miso;
   reg        increment_address;
   reg        burst;

   //
   // State Machine
   //
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
        spi_state       <= SPI_CONTROL;
        bit_count       <= 0;
        capture_control <= 1'b0;
        capture_address <= 1'b0;
        capture_read    <= 1'b0;
        capture_write   <= 1'b0;
        start           <= 1'b0;
        start_miso      <= 1'b0;
        burst           <= 1'b0;
        increment_address <= 1'b0;
     end else begin
        case(spi_state)
          SPI_CONTROL: begin
             //
             // Capture WriteReadNot, the Select bits and 3 upper address bits
             //
             bit_count       <= (bit_count >= 7) ? 0 : bit_count+1;
             spi_state       <= (bit_count >= 7) ? SPI_ADDRESS : SPI_CONTROL;
             capture_control <= (bit_count >= 7) ? 1 : 0;
             capture_address <= 1'b0;
             capture_read    <= 1'b0;
             capture_write   <= 1'b0;
             start           <= 1'b0;
             start_miso      <= 1'b0;
             burst           <= 1'b0;
             increment_address <= 1'b0;
          end

          SPI_ADDRESS: begin
             //
             // Get the next 16 bits of address, for 19 bits total
             //
             bit_count       <= (bit_count >= 15) ? 0 : bit_count+1;
             spi_state       <= (bit_count >= 15) ? (wrn) ? SPI_WRITE : SPI_READ : SPI_ADDRESS;
             capture_control <= 1'b0;
             capture_address <= ((bit_count == 7) || (bit_count == 15)) ? 1'b1 : 1'b0;
             capture_read    <= 1'b0;
             capture_write   <= 1'b0;
             start           <= 1'b0;
             start_miso      <= 1'b0;
             burst           <= 1'b0;
             increment_address <= 1'b0;
          end

          SPI_READ: begin
             //
             // Get the 8 bits of dummy and then drive out 32 bits of data
             //
             bit_count       <= (bit_count >= spi_read_length) ? (burst) ? 1 : 0 : bit_count+1;
             //spi_state       <= (bit_count >= spi_read_length) ? SPI_CONTROL : SPI_READ;
             capture_control <= 1'b0;
             capture_address <= 1'b0;
             capture_read    <= (bit_count[2:0] == (3'h7-burst)) ? 1'b1 : 1'b0;
             capture_write   <= 1'b0;
             start           <= (bit_count == 7) ? 1'b1 : 1'b0;
             start_miso      <= (bit_count >= 7) ? 1'b1 : 1'b0;
             increment_address <= (bit_count >= spi_read_length) ? 1'b1 : 1'b0;
             burst           <= burst | increment_address;
          end

          SPI_WRITE: begin
             //
             // Get the 32 bits of data to write and 8 bits of dummy to write it out
             //
             bit_count       <= (bit_count >= spi_write_length) ? (burst) ? 1 : 0 : bit_count+1;
             //spi_state       <= (bit_count >= spi_write_length) ? SPI_CONTROL : SPI_WRITE;
             capture_control <= 1'b0;
             capture_address <= 1'b0;
             capture_read    <= 1'b0;
             capture_write   <= (bit_count[2:0] == (3'h7-burst)) ? 1'b1 : 1'b0;
             start           <= (bit_count >= spi_write_length) ? 1'b1 : 1'b0;
             start_miso      <= 1'b0;
             increment_address <= (bit_count >= (spi_read_length-8)) ? 1'b1 : 1'b0;
             burst           <= burst | increment_address;
          end

          default: begin
             //
             // If anything has gone wrong......
             //
             spi_state <= SPI_CONTROL;
             bit_count       <= 0;
             capture_control <= 1'b0;
             capture_address <= 1'b0;
             capture_read    <= 1'b0;
             capture_write   <= 1'b0;
             start           <= 1'b0;
             start_miso      <= 1'b0;
             increment_address <= 1'b0;
          end
        endcase // case (spi_state)
     end // else: !if(spi.nss)

   //
   // Capture the WriteReadNot and Select bits
   //
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
        wrn <= 1'b0;
        select <= 4'h0;
     end else begin
        if (capture_control) begin
           wrn <=  data_byte[7];
           select <= data_byte[6:3];
        end
     end

   //
   // Capture the Address
   //
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
        address <= 19'h0;
     end else begin
        if (capture_control) begin
           address [18:16] <= data_byte[2:0];
        end
        if (capture_address) begin
           address [15:08] <= (bit_count >= 7)  ? data_byte : address[15:08];
           address [07:00] <= (bit_count == 0)  ? data_byte : address[07:00];
        end
        if (increment_address) begin
           address <= address + address_increment_size;
        end
     end // else: !if(spi.nss)

   //
   // Capture the data to write out via WB master
   //
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
        data <= 32'h0000_0000;
     end else begin
        if (capture_write) begin
//           case (bit_count)
//             8 : begin
           if (bit_count == (8-burst)) begin
              case(select)
                `WB_BYTE_0 : begin
                   data[07:00] <= data_byte;
                end
                `WB_BYTE_1 : begin
                   data[15:08] <= data_byte;
                end
                `WB_BYTE_2 : begin
                   data[23:16] <= data_byte;
                end
                `WB_BYTE_3 : begin
                   data[31:24] <= data_byte;
                end
                `WB_LOWER_HALF_WORD: begin
                   data[15:08] <= data_byte;
                end
                default: begin
                   data[31:24] <= data_byte;
                end
              endcase // case (select)
           end // if (bit_count == (8-burst))

           //             16: begin
           if (bit_count == (16-burst)) begin
              if (select == `WB_LOWER_HALF_WORD) begin
                 data[07:00] <= data_byte;
              end else begin
                 data[23:16] <= data_byte;
              end
           end

//             24: begin
           if (bit_count == (24-burst)) begin
              data[15:08] <= data_byte;
           end

//             32: begin
           if (bit_count == (32-burst)) begin
              data[07:00] <= data_byte;
           end
//        endcase // case (bit_count)
        end // if (capture_write)
     end // else: !if(spi.nss)

   //
   // Transmit the data read from WB master to external host
   //
   reg [5:0] tx_index;
   always_ff @(posedge spi.sclk or posedge spi.nss)
     if (spi.nss) begin
           tx_index <= 31;
     end else begin
        if (start_miso) begin
           tx_index <= tx_index - 1;
        end else begin
           case (select)
             `WB_BYTE_0:begin
                tx_index <= 7;
             end
             `WB_LOWER_HALF_WORD,
             `WB_BYTE_1:begin
                tx_index <= 15;
             end
             `WB_BYTE_2:begin
                tx_index <= 23;
             end
             default:begin
                tx_index <= 31;
             end
           endcase // case (select)
        end // else: !if(start_miso)
     end // else: !if(spi.nss)

   assign spi.miso = (start_miso) ? write_data[tx_index] : 1'b0;

endmodule // spi_slave
