     +incdir+../testbench
      +incdir+../behavioral/
      +incdir+../behavioral/wb_common/
      +incdir+../rtl/bus_matrix/
      +incdir+../behavioral/wb_master/
      +incdir+../behavioral/wb_uart
      +incdir+../behavioral/wb_spi/rtl/verilog/
      +incdir+../rtl/
      +incdir+../rtl/uart
      +define+VERBOSE
      +define+SIM
      +define+RTL
      +define+SIMULATION

      ../rtl/top.sv
      ../rtl/syscon/syscon.sv

      ../rtl/uart/packet_decode.sv
      ../rtl/uart/uart.v
      ../rtl/uart/uart_to_wishbone_master.sv

      ../rtl/spi_slave/spi_if.sv
      ../rtl/spi_slave/spi_slave.sv
      ../rtl/spi_slave/spi_slave_wb_master_top.sv
      ../rtl/bus_matrix/bus_matrix.v
      ../rtl/wishbone/wb_if.sv
      ../rtl/wishbone/wb_master.sv



      ../behavioral/wb_ram/wb_ram_new.sv
      ../behavioral/wb_ram/wb_ram_generic.v

      ../behavioral/wb_master/wb_mast_model.v

      ../behavioral/wb_intercon/wb_arbiter.v
      ../behavioral/wb_intercon/arbiter.v
      ../behavioral/wb_intercon/wb_data_resize.v
      ../behavioral/wb_intercon/wb_mux.v

      ../behavioral/wb_uart/raminfr.v
      ../behavioral/wb_uart/uart_debug_if.v
      ../behavioral/wb_uart/uart_receiver.v
      ../behavioral/wb_uart/uart_regs.v
      ../behavioral/wb_uart/uart_rfifo.v
      ../behavioral/wb_uart/uart_sync_flops.v
      ../behavioral/wb_uart/uart_tfifo.v
      ../behavioral/wb_uart/uart_top.v
      ../behavioral/wb_uart/uart_transmitter.v
      ../behavioral/wb_uart/uart_wb.v

      ../behavioral/wb_spi/rtl/verilog/spi_clgen.v
      ../behavioral/wb_spi/rtl/verilog/spi_shift.v
      ../behavioral/wb_spi/rtl/verilog/spi_top.v


      ../testbench/testbench.v
      ../testbench/test_tasks.v
      ../testbench/uart_tasks.v
      ../testbench/spi_tasks.v
      ../testbench/dump.v
