`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Abdelrahman khaled
// Create Date: 10/28/2024 06:30:31 AM
// Module Name: master
// Project Name:APB
//////////////////////////////////////////////////////////////////////////////////


module master #(

parameter   DATA_WIDTH=8,
            ADDR_WIDTH=9

)(

input                       pclk,
input                       prst_n,

input                       pread_write,
input                       ptransfer_en,
input                       pready,

input     [ADDR_WIDTH-1:0]  pwaddr,
input     [ADDR_WIDTH-1:0]  praddr,
input     [DATA_WIDTH-1:0]  pwdata, 
input     [DATA_WIDTH-1:0]  prdata,


output                      sel1,
output                      sel2,
output                      pwrite,
output reg                  penable,
output                      pslverr,//is an optional signal that can be asserted HIGH to indicate an error condition

output reg [DATA_WIDTH-1:0] pwrite_data,
output reg [ADDR_WIDTH-1:0] paddr,
output reg [DATA_WIDTH-1:0] data_out

    );
   localparam    IDLE   =3'b001,
                 SETUP  =3'b010,
                 ACCESS =3'b100;
                 
   (*fsm_encoding = "one_hot"*) reg [2:0] curr_state,next_state;
   
   reg     error_case1;
   reg     error_case2;
   reg     error_case3;
   reg     error_case4;
   
   // State Register
   always @(posedge pclk or negedge prst_n)
   begin
        if(~prst_n)
        begin 
           curr_state   <=  IDLE;
           //pwrite_data  <=8'b0;
           //paddr        <=9'b0;
           //data_out     <=8'b0;
        end
        else           curr_state   <=  next_state;
   end
   
   // Next State Logic: Determine the next state based on inputs
   always @(*)
   begin
    case(curr_state)
        IDLE:begin
                penable =  1'b0;
                if(ptransfer_en)  next_state    =  SETUP   ;
                else              next_state    =  IDLE    ;    
             end
        SETUP:begin
                penable=1'b0;
                if(ptransfer_en && ~pslverr )       next_state    =  ACCESS   ;
                else if(~ptransfer_en && ~pslverr)   next_state    =  SETUP    ;
                else     next_state    =  IDLE   ;
              end
        ACCESS:begin
                penable=1'b1;
                if(ptransfer_en && pready && ~pslverr )       next_state    =  SETUP   ;
                else if(ptransfer_en && ~pready && ~pslverr)  next_state    =  ACCESS    ;
                else     next_state    =  IDLE   ;
               end
        default:begin
                penable=1'b0;
                next_state    =  IDLE   ;
                end
    endcase  
   end
  
   // Output Logic
   
   always @(*)
   begin
    case(curr_state)
        SETUP:begin
            if(~pwrite) begin
                paddr       =praddr;
                pwrite_data = 8'b0;                
            end
            else begin
                paddr       = pwaddr;
                pwrite_data = pwdata;
            end
              end
        ACCESS:begin
               if(ptransfer_en && pready && ~pslverr && ~pwrite )  data_out=  prdata;
               else data_out    =  8'b0;
                end
        default:begin
                 data_out   = 8'b0;
                end
    endcase  
   end
     
    
  
  //slave select depend on the last bit of PADDR 
   assign sel1=((curr_state==SETUP||curr_state==ACCESS) &&  paddr[8]==1)?1:0;
   assign sel2=((curr_state==SETUP||curr_state==ACCESS) &&  paddr[8]==0)?1:0;
   assign pwrite = ~ pread_write;
   
   
   //transfer failure and error 
   always @(*) begin
    if ((curr_state==IDLE) && (next_state==ACCESS)) error_case1=1'b1;
    else    error_case1=1'b0;
    
    if ((curr_state==ACCESS || curr_state==SETUP ) &&(~pwrite) && (praddr=='bx)) error_case2=1'b1; 
    else error_case2=1'b0;
    
    if ((curr_state==ACCESS || curr_state==SETUP ) && (pwrite)  && (pwaddr==9'dx)) error_case3=1'b1;
    else error_case3=1'b0;

    if ((curr_state==ACCESS || curr_state==SETUP ) && (pwrite)  && (pwdata==8'dx)) error_case4=1'b1;
    else   error_case4=1'b0 ;
    
   end
 
  assign pslverr = error_case1 || error_case2 || error_case3 || error_case4;
    
endmodule
