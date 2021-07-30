//                              -*- Mode: Verilog -*-
// Filename        : comm_tasks.v
// Description     : COMM Support Tasks
// Author          : Phil Tracton
// Created On      : Tue Apr 16 17:11:17 2019
// Last Modified By: Phil Tracton
// Last Modified On: Tue Apr 16 17:11:17 2019
// Update Count    : 0
// Status          : Unknown, Use with caution!

`include "timescale.v"
`include "simulation_includes.vh"

module comm_tasks (/*AUTOARG*/ ) ;   
   
   task CPU_READ;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] expected;

      output [31:0] data;
      begin
         data = 32'hFFFFFFFF;

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_READ);     // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_WORD(address);                           // Start Address
         `UART_READ_WORD(expected, data);                     // Data[0]

         $display("CPU READ addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);
         `TEST_COMPARE("CPU READ", expected, data);
         repeat (1) @(posedge `WB_CLK);

      end
   endtask // CPU_READ

   task CPU_WRITE;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] data;
      begin
         @(posedge `WB_CLK);
         $display("CPU WRITE addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);

         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_CPU_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_WORD(address);                           // Start Address
         `UART_WRITE_WORD(data);                              // Data[0]
         repeat (1) @(posedge `WB_CLK);

      end
   endtask // CPU_WRITE


   task DAQ_READ;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] expected;

      output [31:0] data;
      begin
         data = 32'hFFFFFFFF;
         // @(posedge `WB_CLK);
         // `DAQ_ADDR = address;
         // `DAQ_SEL = selection;
         // `DAQ_WRITE = 0;
         // `DAQ_START = 1;

         // if (`DAQ_ACTIVE === 0)  begin
         //    @(posedge `DAQ_ACTIVE);
         //    @(negedge `DAQ_ACTIVE);
         // end else begin
         //    @(negedge `DAQ_ACTIVE);
         // end

         // @(posedge `WB_CLK);
         // `DAQ_WRITE = 0;
         // `DAQ_ADDR = $random;
         // `DAQ_SEL = $random;
         // `DAQ_START = 0;
         // data = `DAQ_DATA_RD;
         //$display("DAQ READ addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);
         `TEST_COMPARE("DAQ READ", expected, data);
         repeat (1) @(posedge `WB_CLK);
      end
   endtask // DAQ_READ

   task DAQ_WRITE;
      input [31:0] address;
      input [3:0]  selection;
      input [31:0] data;
      begin
         @(posedge `WB_CLK);
         //$display("DAQ WRITE addr = 0x%x data = 0x%x sel = 0x%x @ %d", address, data, selection, $time);

         // `DAQ_ADDR = address;
         // `DAQ_DATA_WR = data;
         // `DAQ_SEL = selection;
         // `DAQ_WRITE = 1;
         // `DAQ_START = 1;

         // if (`DAQ_ACTIVE === 0) begin
         //    @(posedge `DAQ_ACTIVE);
         //    @(negedge `DAQ_ACTIVE);
         // end else begin
         //    @(negedge `DAQ_ACTIVE);
         // end

         // @(posedge `WB_CLK);
         // `DAQ_WRITE = 0;
         // `DAQ_ADDR = $random;
         // `DAQ_DATA_WR = $random;
         // `DAQ_SEL = $random;
         // `DAQ_START = 0;
         repeat (1) @(posedge `WB_CLK);
      end
   endtask // DAQ_WRITE

   reg daq_writes_busy;
   
   task DAQ_WRITES_FILE;
      input [7:0] file_num;
      input [31:0] data;
      begin
         $display("DAQ WRITES FILE File = %d Data = 0x%x @ %d", file_num, data, $time);
         daq_writes_busy <= 1'b1;         
         `UART_WRITE_BYTE(`PKT_PREAMBLE);                     // Preamble
         `UART_WRITE_BYTE(8'hF0 | `PKT_COMMAND_DAQ_WRITE);    // Size and Command
         `UART_WRITE_BYTE(8'h1);                              // Length
         `UART_WRITE_BYTE(file_num);                          // File Number
         `UART_WRITE_WORD(data);                              // Write Data
         
         while(`UART_BUSY == 1'b1) begin
            #100;            
         end
         daq_writes_busy <= 1'b0;         
      end
   endtask // DAQ_WRITE_FILE


   
endmodule // comm_tasks
