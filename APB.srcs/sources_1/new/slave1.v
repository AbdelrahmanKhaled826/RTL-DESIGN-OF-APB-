`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Abdelrahman khaled
// Create Date: 10/28/2024 06:30:31 AM
// Module Name: slave1
// Project Name:APB
//////////////////////////////////////////////////////////////////////////////////


module slave1#(
parameter   DATA_WIDTH=8,
            ADDR_WIDTH=8

)(
 
input                       prst_n,

input                       pread_write,
input                       penable,
input                       sel,

input   [ADDR_WIDTH-1:0]    paddr,
input   [DATA_WIDTH-1:0]    pwdata,

output  reg                      pready,
output  reg [DATA_WIDTH-1:0]     prdata_slave1

    );
    
    reg [DATA_WIDTH-1:0] mem1[0:255];
    always @(*)begin
        if(~prst_n) begin
            pready        =  1'b0;
        end
        else if(penable && pread_write && sel  ) begin
            pready      =1'b1;
            mem1[paddr] = pwdata;
        end
        else if(penable && ~pread_write && sel  ) begin
            pready          =  1'b1;
            prdata_slave1   =  mem1[paddr];
        end
        else begin
             pready          =  1'b0;
             prdata_slave1   =  8'b0;
        end
    end
    
    
endmodule
