      vlib work

     vlog ../rtl/spi_slave/spi_if.sv
     vlog ../rtl/spi_slave/spi_slave.sv
     vlog ../rtl/spi_slave/spi_slave_wb_master_top.sv
     
     vlog ../rtl/wishbone/wb_if.sv

      vlog ../rtl/top.sv +incdir+../simulation +incdir+../rtl/bus_matrix/ +incdir+../testbench

      vlog ../rtl/syscon/syscon.sv +define+SIM


      vlog ../behavioral/wb_uart/raminfr.v
      vlog ../behavioral/wb_uart/uart_debug_if.v
      vlog ../behavioral/wb_uart/uart_receiver.v
      vlog ../behavioral/wb_uart/uart_regs.v
      vlog ../behavioral/wb_uart/uart_rfifo.v
      vlog ../behavioral/wb_uart/uart_sync_flops.v
      vlog ../behavioral/wb_uart/uart_tfifo.v
      vlog ../behavioral/wb_uart/uart_top.v
      vlog ../behavioral/wb_uart/uart_transmitter.v
      vlog ../behavioral/wb_uart/uart_wb.v

      vlog ../behavioral/wb_spi/rtl/verilog/spi_clgen.v +incdir+../behavioral/wb_spi
      vlog ../behavioral/wb_spi/rtl/verilog/spi_shift.v +incdir+../behavioral/wb_spi
      vlog ../behavioral/wb_spi/rtl/verilog/spi_top.v +incdir+../behavioral/wb_spi

      vlog ../behavioral/wb_master/wb_mast_model.v
      vlog ../behavioral/wb_intercon/wb_arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/wb_data_resize.v
      vlog ../behavioral/wb_intercon/wb_mux.v  +incdir+../behavioral/

      vlog ../testbench/testbench.v +incdir+../simulation
      vlog ../testbench/test_tasks.v +incdir+../simulation
      vlog ../testbench/uart_tasks.v  +incdir+../simulation  +incdir+../testbench
      vlog ../testbench/spi_tasks.v  +incdir+../simulation  +incdir+../testbench  +define+MODELSIM

      vsim -voptargs=+acc work.testbench +define+RTL +define+SIM
#     do wave.do
      run -all
