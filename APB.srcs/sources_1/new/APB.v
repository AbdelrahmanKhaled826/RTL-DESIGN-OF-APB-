`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Abdelrahman khaled 
// 
// Create Date: 10/28/2024 06:22:04 AM
// Module Name: APB
//////////////////////////////////////////////////////////////////////////////////


module APB#(

parameter   DATA_WIDTH=8,
            ADDR_WIDTH=9

)(

input                       APBclk,
input                       APBrst_n,
input                       APBtransfer,
input                       APBread_write,

input     [ADDR_WIDTH-1:0]  APBraddr,
input     [ADDR_WIDTH-1:0]  APBwaddr,
input     [DATA_WIDTH-1:0]  APBwdata,

output                      pslverr,//is an optional signal that can be asserted HIGH to indicate an error condition
output     [DATA_WIDTH-1:0] data_out


    );
    
    wire                    APBwrite;
    wire                    APBenable;
    wire                    APBsel1;
    wire                    APBsel2;
    wire  [ADDR_WIDTH-1:0]  APBaddr;
    wire  [DATA_WIDTH-1:0]  APBwrite_data;
    wire                    APBready;
    wire                    pready1;
    wire                    pready2;
    wire  [DATA_WIDTH-1:0]  prdata_slave1;
    wire  [DATA_WIDTH-1:0]  prdata_slave2;
    wire  [DATA_WIDTH-1:0]  APBread_data;


   master MASTER(
   .pclk(APBclk),
   .prst_n(APBrst_n),
   .pread_write(APBread_write),
   .ptransfer_en(APBtransfer),
   .pready(APBready),
   .pwaddr(APBwaddr),
   .praddr(APBraddr),
   .pwdata(APBwdata), 
   .prdata(APBread_data),
   .sel1(APBsel1),
   .sel2(APBsel2),
   .pwrite(APBwrite),
   .penable(APBenable),
   .pslverr(pslverr),
   .pwrite_data(APBwrite_data),
   .paddr(APBaddr),
   .data_out(data_out)
   );
    
    (* DONT_TOUCH = "TRUE" *)
 slave1 RAM1(
   //.pclk(APBclk),
   .prst_n(APBrst_n),
   .pread_write(APBwrite),
   .penable(APBenable),
   .sel(APBsel1),
   .paddr(APBaddr[ADDR_WIDTH-2:0]),
   .pwdata(APBwrite_data),
   .pready(pready1),
   .prdata_slave1(prdata_slave1)
       );
      
(* DONT_TOUCH = "TRUE" *)
slave2 RAM2(
   //.pclk(APBclk),
   .prst_n(APBrst_n),
   .pread_write(APBwrite),
   .penable(APBenable),
   .sel(APBsel2),
   .paddr(APBaddr[ADDR_WIDTH-2:0]),
   .pwdata(APBwrite_data),
   .pready(pready2),
   .prdata_slave2(prdata_slave2)
  );       
    
    
    assign APBready = (APBaddr[8]==1'b1)? pready1 : pready2;
    
    assign APBread_data = (APBread_write)?  (APBaddr[8]==1'b1)? prdata_slave1 : prdata_slave2     :8'b0;

endmodule
