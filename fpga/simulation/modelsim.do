
vlib work


     vlog ${1}.v +incdir+../testbench +incdir+../simulation  +incdir+../testbench  +define+RTL

     vlog ../rtl/top.sv +incdir+../simulation +incdir+../rtl/bus_matrix/ +incdir+../testbench
     vlog ../rtl/syscon/syscon.sv +define+SIM
      
      
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

      vlog ../behavioral/wb_intercon/wb_arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/arbiter.v  +incdir+../behavioral/
      vlog ../behavioral/wb_intercon/wb_data_resize.v
      vlog ../behavioral/wb_intercon/wb_mux.v  +incdir+../behavioral/     

      vlog ../testbench/testbench.v +incdir+../simulation
      
      vlog ../testbench/test_tasks.v +incdir+../simulation +define+MODELSIM
      vlog ../testbench/uart_tasks.v  +incdir+../simulation  +incdir+../testbench  +define+MODELSIM
      
vsim -voptargs=+acc work.testbench  +define+RTL +define+SIM -l ${1}.modelsim.log

do wave.do
run -all
