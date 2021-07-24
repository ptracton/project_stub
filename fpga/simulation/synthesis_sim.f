+define+SYNTHESIS
+incdir+../testbench
+incdir+../behavioral/
+incdir+../behavioral/wb_common/
+incdir+../behavioral/wb_master/
+incdir+../behavioral/wb_uart
      
../testbench/testbench.v
../testbench/test_tasks.v
../testbench/dsp_tasks.v
../testbench/uart_tasks.v
../testbench/dump.v

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

../behavioral/wb_master/wb_mast_model.v
//../behavioral/wb_intercon/wb_arbiter.v
//../behavioral/wb_intercon/wb_data_resize.v
//../behavioral/wb_intercon/wb_mux.v

// https://www.xilinx.com/support/answers/56713.html
-y $XILINX_VIVADO/data/verilog/src/unisims +libext+.v
-y $XILINX_VIVADO/data/verilog/src/unimacro +libext+.v
-y $XILINX_VIVADO/data/verilog/src/retarget +libext+.v

../backend/basys3/synthesis/top_funcsim.v
