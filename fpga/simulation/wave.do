onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TB /testbench/clk
add wave -noupdate -group TB /testbench/reset
add wave -noupdate -group TB /testbench/wb_clk
add wave -noupdate -group TB /testbench/wb_rst
add wave -noupdate -group TB /testbench/tx
add wave -noupdate -group TB /testbench/rx
add wave -noupdate -group TB /testbench/sclk
add wave -noupdate -group TB /testbench/nss
add wave -noupdate -group TB /testbench/mosi
add wave -noupdate -group TB /testbench/miso
add wave -noupdate -group TB /testbench/clk_tb
add wave -noupdate -group TB /testbench/reset_tb
add wave -noupdate -group TB /testbench/uart0_adr
add wave -noupdate -group TB /testbench/uart0_dat_o
add wave -noupdate -group TB /testbench/uart0_dat_i
add wave -noupdate -group TB /testbench/uart0_sel
add wave -noupdate -group TB /testbench/uart0_cyc
add wave -noupdate -group TB /testbench/uart0_stb
add wave -noupdate -group TB /testbench/uart0_we
add wave -noupdate -group TB /testbench/uart0_ack
add wave -noupdate -group TB /testbench/uart0_int
add wave -noupdate -group TB /testbench/read_word
add wave -noupdate -group TB /testbench/test_failed
add wave -noupdate -group TB /testbench/UART_VALID
add wave -noupdate -group DUT /testbench/dut/clk
add wave -noupdate -group DUT /testbench/dut/rst
add wave -noupdate -group DUT /testbench/dut/rx
add wave -noupdate -group DUT /testbench/dut/tx
add wave -noupdate -group DUT /testbench/dut/sclk
add wave -noupdate -group DUT /testbench/dut/nss
add wave -noupdate -group DUT /testbench/dut/mosi
add wave -noupdate -group DUT /testbench/dut/miso
add wave -noupdate -group DUT /testbench/dut/wb_clk
add wave -noupdate -group DUT /testbench/dut/wb_rst
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/clk
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/rst
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/wb_clk
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/wb_rst
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/locked
add wave -noupdate -expand -group SYSCON -radix hexadecimal /testbench/dut/syscon_inst/wb_rst_shr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10938421180 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 440
configure wave -valuecolwidth 203
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ps} {4688250 ps}
bookmark add wave bookmark0 {{1971452678 ps} {1976123674 ps}} 17
