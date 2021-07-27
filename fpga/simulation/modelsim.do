
vlib work


     vlog ${1}.v +incdir+../testbench +incdir+../simulation  +incdir+../testbench  +define+RTL +incdir+../rtl

     vlog ../rtl/syscon/syscon.sv +define+SIM

     vlog ../rtl/spi_slave/spi_if.sv
     vlog ../rtl/spi_slave/spi_slave.sv +incdir+../rtl
     vlog ../rtl/spi_slave/spi_slave_wb_master_top.sv
     
     vlog ../rtl/wishbone/wb_if.sv
     vlog ../rtl/wishbone/wb_master.sv

     vlog ../rtl/uart/uart.v
     vlog ../rtl/uart/uart_to_wishbone_master.v
     vlog ../rtl/uart/packet_decode.v +incdir+../rtl/uart

     vlog ../rtl/bus_matrix/bus_matrix.v +indir+../rtl/bus_matrix/

     vlog ../rtl/top.sv +incdir+../simulation +incdir+../rtl/bus_matrix/ +incdir+../testbench

     vlog ../behavioral/wb_master/wb_mast_model.v

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


      vlog ../behavioral/wb_intercon/wb_arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/wb_data_resize.v
      vlog ../behavioral/wb_intercon/wb_mux.v  +incdir+../behavioral/     

#      vlog ../behavioral/wb_ram/wb_ram.v +incdir+../behavioral/wb_common/
      vlog ../behavioral/wb_ram/wb_ram_new.sv +incdir+../behavioral/wb_common/      
      vlog ../behavioral/wb_ram/wb_ram_generic.v

      vlog ../testbench/testbench.v +incdir+../simulation
      
      vlog ../testbench/test_tasks.v +incdir+../simulation +define+MODELSIM
      vlog ../testbench/uart_tasks.v  +incdir+../simulation  +incdir+../testbench  +define+MODELSIM
      vlog ../testbench/spi_tasks.v  +incdir+../simulation  +incdir+../testbench  +define+MODELSIM
      
vsim -voptargs=+acc work.testbench  +define+RTL +define+SIM -l ${1}.modelsim.log

do wave.do
run -all
