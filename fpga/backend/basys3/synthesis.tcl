
create_project -force basys3  -part xc7a35tcpg236-3

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property verilog_dir {
    ../../testbench
    ../../simulation
    ../../behavioral/wb_common
    ../../behavioral/wb_intercon
    ../../behavioral/verilog_utils
    ../../behavioral/
    ../../rtl/gpio
    ../../rtl/bus_matrix/
    ../../rtl/
} [current_fileset]
read_verilog -library xil_defaultlib {
    basys.v
     ../../rtl/syscon/syscon.sv 

     ../../rtl/spi_slave/spi_if.sv
     ../../rtl/spi_slave/spi_slave.sv
     ../../rtl/spi_slave/spi_slave_wb_master_top.sv
     
     ../../rtl/wishbone/wb_if.sv
     ../../rtl/wishbone/wb_master.sv

     ../../rtl/uart/uart.v
     ../../rtl/uart/uart_to_wishbone_master.sv
     ../../rtl/uart/packet_decode.sv 

     ../../rtl/bus_matrix/bus_matrix.v
    
    ../../rtl/top.sv 

    ../../behavioral/wb_master/wb_mast_model.v
    ../../behavioral/wb_intercon/wb_arbiter.v 
    ../../behavioral/wb_intercon/arbiter.v 
    ../../behavioral/wb_intercon/wb_data_resize.v
    ../../behavioral/wb_intercon/wb_mux.v
    
    ../../behavioral/wb_ram/wb_ram_new.sv
    ../../behavioral/wb_ram/wb_ram_generic.v
    
}

read_ip ./ip/clk_wiz_0/clk_wiz_0.xci
upgrade_ip [get_ips *]
generate_target -force {All} [get_ips *]
synth_ip [get_ips *]

read_xdc basys3.xdc
set_property used_in_implementation false [get_files basys3.xdc]

synth_design -top top -part xc7a35tcpg236-3
write_checkpoint -noxdef -force synthesis/basys3.dcp
catch { report_utilization -file synthesis/basys3_utilization_synth.rpt -pb synthesis/basys3_utilization_synth.pb }

open_checkpoint synthesis/basys3.dcp
write_verilog -mode funcsim -sdf_anno true synthesis/top_funcsim.v
write_sdf synthesis/top_funcsim.sdf
