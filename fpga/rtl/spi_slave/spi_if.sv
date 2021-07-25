
interface spi_if();

   //
   // Master driven SPI Clock
   //
   logic sclk;

   //
   // Master Driven SPI not Slave Select.  Active LOW signal
   // for enabling the Slave device to communicate
   //
   logic nss;

   //
   // Slave Driven Master In Slave Out (miso) signal
   //
   wire  miso;

   //
   // Master Driven Master Out Slave In (mosi) signal
   //
   logic mosi;
   
   modport master(
                  output sclk,
                  output nss,
                  output mosi,
                  input  miso
                  );
   
   modport slave(
                 input  sclk,
                 input  nss,
                 input  mosi,
                 output miso
                 );

   
endinterface:  spi_if
