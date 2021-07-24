
    vlib work


   vlog ${1}.v +incdir+../testbench +incdir+../simulation  +incdir+../testbench

   vlog -work work ../backend/basys3/implementation/top_timesim.v

   vlog -work work ../testbench/testbench.v +incdir+../simulation
   vlog -work work ../testbench/test_tasks.v +incdir+../simulation
   vlog -work work ../testbench/dsp_tasks.v +incdir+../simulation  +incdir+../testbench
   vlog -work work ../testbench/uart_tasks.v  +incdir+../simulation  +incdir+../testbench


   #https://www.xilinx.com/support/answers/56713.html
   vlog -work work -y /opt/Xilinx/Vivado/2018.1/data/verilog/src/unisims/*.v +libext+.v
   vlog -work work /opt/Xilinx/Vivado/2018.1/data/verilog/src/unimacro/*.v +libext+.v
   vlog -work work /opt/Xilinx/Vivado/2018.1/data/verilog/src/retarget/*.v +libext+.v
   vlog -work work /opt/Xilinx/Vivado/2018.1/data/verilog/src/glbl.v 


   vsim -voptargs=+acc work.testbench  work.glbl +${2} +define+SIM -l ${1}.modelsim.log -t ps
   
   do wave_gates.do
   run -all
