//                              -*- Mode: Verilog -*-
// Filename        : syscon.sv
// Description     : Generic Clock and Reset System Controller
// Author          : Philip Tracton
// Created On      : Sat Jul 24 15:15:48 2021
// Last Modified By: Philip Tracton
// Last Modified On: Sat Jul 24 15:15:48 2021
// Update Count    : 0
// Status          : Unknown, Use with caution!


module syscon (/*AUTOARG*/
   // Outputs
   wb_clk, wb_rst,
   // Inputs
   clk, rst
   ) ;

   //
   // IO Pads Interface
   //
   input clk;
   input rst;

   //
   // System Interface
   //
   output wb_clk;
   output wb_rst;

   // used to indicate that the clock has locked in and is ready to use   
   wire   locked;
   
   //
   // Reset generation for wishbone
   //
   // This will keep reset asserted until we get 16 clocks
   // of the PLL/Clock Tile being locked
   //
   reg [31:0] wb_rst_shr;

   always @(posedge clk or posedge rst)
	 if (rst)
	   wb_rst_shr <= 32'hffff_ffff;
	 else
	   wb_rst_shr <= {wb_rst_shr[30:0], ~(locked)};

   assign wb_rst = wb_rst_shr[31] | ~locked | rst;

`ifdef SIM

   //
   // For a simple system in simulation
   //
   assign wb_clk = clk;   
   assign locked = 1'b1;

`else

   // Put technology specific clocking here, things like Xilinx DCM/Clock Wizard, etc...
   assign wb_clk = clk;   
   assign locked = 1'b1;

`endif

   
   
   
endmodule // syscon
