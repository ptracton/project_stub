//                              -*- Mode: Verilog -*-
// Filename        : setup.v
// Description     : Setup details for running a test case
// Author          : Philip Tracton
// Created On      : Wed Jul 27 21:08:53 2016
// Last Modified By: Philip Tracton
// Last Modified On: Wed Jul 27 21:08:53 2016
// Update Count    : 0
// Status          : Unknown, Use with caution!

`ifdef XILINX
integer mem_index;
reg [31:0] local_word;

integer bank0_ram0;
integer bank0_ram1;
integer bank0_ram2;
integer bank0_ram3;

integer bank1_ram0;
integer bank1_ram1;
integer bank1_ram2;
integer bank1_ram3;
reg [48:0] cpu_name;

`endif //  `ifdef XILINX

initial begin
`ifdef RTL
   $display("RTL SIM: %s", {simulation_name, ".vh.mem"});
   $readmemh( {simulation_name, ".vh.mem"}, `PROGRAM_ROM.ram0.mem);
`endif

`ifdef ALTERA
   $display("ALTERA SIM: %s", {simulation_name, ".vh.mem"});
   $readmemh( {simulation_name, ".vh.mem"}, `PROGRAM_ROM.ram0.altsyncram_component.m_default.altsyncram_inst.mem_data);
`endif
      
`ifdef XILINX
 `ifdef WISHBONE_CPU_MOR1KX
   cpu_name = "MOR1KX";
 `endif

 `ifdef WISHBONE_CPU_LM32
   cpu_name = "LM32";
 `endif

 `ifdef WISHBONE_CPU_ZIP
   cpu_name = "ZIP";
 `endif   
   
   $display("XILINX SIM: %s", {simulation_name, ".vh.mem"});
   $readmemh( {simulation_name, ".vh.mem"},`TB.local_mem);
   mem_index = 0;

   bank0_ram0 = $fopen({cpu_name,"_",simulation_name,"_bank0_ram0.txt"},"w");
   bank0_ram1 = $fopen({cpu_name,"_",simulation_name,"_bank0_ram1.txt"},"w");
   bank0_ram2 = $fopen({cpu_name,"_",simulation_name,"_bank0_ram2.txt"},"w");
   bank0_ram3 = $fopen({cpu_name,"_",simulation_name,"_bank0_ram3.txt"},"w");
   
   bank1_ram0 = $fopen({cpu_name,"_",simulation_name,"_bank1_ram0.txt"},"w");
   bank1_ram1 = $fopen({cpu_name,"_",simulation_name,"_bank1_ram1.txt"},"w");
   bank1_ram2 = $fopen({cpu_name,"_",simulation_name,"_bank1_ram2.txt"},"w");
   bank1_ram3 = $fopen({cpu_name,"_",simulation_name,"_bank1_ram3.txt"},"w");
   
   for (mem_index = 0; mem_index <= 16384; mem_index = mem_index + 1)begin
      local_word = `TB.local_mem[mem_index];

      if (|local_word !== 1'bx) begin      
         if (mem_index > 2047) begin
            $fwrite(bank1_ram0,"%02X\n",local_word[07:00]);
            $fwrite(bank1_ram1,"%02X\n",local_word[15:08]);
            $fwrite(bank1_ram2,"%02X\n",local_word[23:16]);
            $fwrite(bank1_ram3,"%02X\n",local_word[31:24]);
            
            testbench.dut.rom0.ram0.bank1.ram0.mem[mem_index] = local_word[07:00];      
            testbench.dut.rom0.ram0.bank1.ram1.mem[mem_index] = local_word[15:08];      
            testbench.dut.rom0.ram0.bank1.ram2.mem[mem_index] = local_word[23:16];      
            testbench.dut.rom0.ram0.bank1.ram3.mem[mem_index] = local_word[31:24];         
         end else begin
            $fwrite(bank0_ram0,"%02X\n",local_word[07:00]);
            $fwrite(bank0_ram1,"%02X\n",local_word[15:08]);
            $fwrite(bank0_ram2,"%02X\n",local_word[23:16]);
            $fwrite(bank0_ram3,"%02X\n",local_word[31:24]);
            
            testbench.dut.rom0.ram0.bank0.ram0.mem[mem_index] = local_word[07:00];      
            testbench.dut.rom0.ram0.bank0.ram1.mem[mem_index] = local_word[15:08];      
            testbench.dut.rom0.ram0.bank0.ram2.mem[mem_index] = local_word[23:16];      
            testbench.dut.rom0.ram0.bank0.ram3.mem[mem_index] = local_word[31:24];         
         end // else: !if(mem_index > 2047)
      end // if (|local_word !== 1'bx)      
   end // for (mem_index = 0; mem_index <= 16384; mem_index = mem_index + 1)

   $fclose(bank0_ram0);
   $fclose(bank0_ram1);
   $fclose(bank0_ram2);
   $fclose(bank0_ram3);  

   $fclose(bank1_ram0);
   $fclose(bank1_ram1);
   $fclose(bank1_ram2);
   $fclose(bank1_ram3);  
   
`endif
  
end
