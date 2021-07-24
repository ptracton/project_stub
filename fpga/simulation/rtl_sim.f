     +incdir+../testbench
      +incdir+../behavioral/
      +incdir+../behavioral/wb_common/
      +incdir+../rtl/bus_matrix/
      +incdir+../behavioral/wb_master/
      +incdir+../behavioral/wb_uart
      +incdir+../rtl/
      +define+VERBOSE
      +define+SIM
      +define+RTL
      +define+SIMULATION

      ../rtl/top.sv
      ../rtl/syscon/syscon.sv

      ../behavioral/wb_ram/wb_ram.v
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
      
      ../testbench/testbench.v
      ../testbench/test_tasks.v
      ../testbench/uart_tasks.v
      ../testbench/dump.v
