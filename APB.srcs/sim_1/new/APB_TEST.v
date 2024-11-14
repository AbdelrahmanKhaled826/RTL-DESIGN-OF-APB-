`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Abdelrahman khaled 
// 
// Create Date: 10/28/2024 06:22:04 AM
// Module Name: APB_tester
//////////////////////////////////////////////////////////////////////////////////


module APB_TEST();

parameter   DATA_WIDTH=8,ADDR_WIDTH=9;


reg                      APBclk;
reg                      APBrst_n;
reg                      APBtransfer;
reg                      APBread_write;

reg     [ADDR_WIDTH-1:0]  APBraddr;
reg     [ADDR_WIDTH-1:0]  APBwaddr;
reg     [DATA_WIDTH-1:0]  APBwdata;

wire                      pslverr;
wire     [DATA_WIDTH-1:0] data_out;




APB DUT(

.APBclk(APBclk),
.APBrst_n(APBrst_n),
.APBtransfer(APBtransfer),
.APBread_write(APBread_write),
.APBraddr(APBraddr),
.APBwaddr(APBwaddr),
.APBwdata(APBwdata),
.pslverr(pslverr),
.data_out(data_out)
);
//generate clock
initial 
clk_generate();
//generate reset pattern
initial 
reset();

initial 
begin
    APBtransfer     =1'b0;
    APBread_write   =1'b0;
    APBwaddr        =9'b0;
    APBwdata        =8'b0;
    APBraddr        =9'b0;
end


initial 
begin
    #40;
    @(negedge APBclk)
    APBtransfer     =1'b1;
    write_data();
end


initial 
begin
    #100;
    APBread_write   =1'b1;
    @(negedge APBclk)
    APBtransfer     =1'b1;
    read_data();
end





//------------------tasks------------------------

task clk_generate();
   begin
        APBclk = 1'b0;
        forever #1 APBclk = ~APBclk;
    end
endtask


task reset();
   begin
        APBrst_n = 1'b0;
        @(negedge APBclk ) APBrst_n=1'b1;
    end
endtask


task write_data();
    begin
         APBwaddr={1'b1,8'd10};
         APBwdata=8'd10;
        #4
        APBwaddr={1'b1,8'd50};
        APBwdata=8'd20;
        #4        
        APBwaddr={1'b1,8'd150};
        APBwdata=8'd30;
        #8
        APBwaddr={1'b1,8'd130};
        APBwdata=8'd40;
        #4        
        APBwaddr={1'b0,8'd11};
        APBwdata=8'd50;
        #4        

        APBwaddr={1'b0,8'd15};
        APBwdata=8'd60;
        #4        

        APBwaddr={1'b0,8'd90};
        APBwdata=8'd70;
        #6        

        APBwaddr={1'b0,8'd130};
        APBwdata=8'd80;
        #8        
        APBtransfer=1'b0; //data not write
        APBwaddr={1'b0,8'd140};
        APBwdata=8'd90;
    end
endtask




task read_data();
    begin
        #4
        APBraddr={1'b1,8'd10};

        #4
        APBraddr={1'b1,8'd50};

        #4
        APBraddr={1'b1,8'd150};

        #4
        APBraddr={1'b1,8'd130};
        
        #4
        APBraddr={1'b0,8'd11};

        #8        
        APBtransfer     =1'b0; //data not read 60
        APBraddr={1'b0,8'd15};

        #6        
        APBtransfer     =1'b1; 
        APBraddr={1'b0,8'd90};

        #4
        APBraddr={1'b0,8'd130};

        #6        
        APBraddr={1'b0,8'd140}; //read x because data not write
        #10
       $stop;
    end
endtask







endmodule
