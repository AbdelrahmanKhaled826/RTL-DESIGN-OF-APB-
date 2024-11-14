`timescale 1ns / 1ps

task clk_generate();
   output APBclk;
   begin
        APBclk = 1'b0;
        forever #5 APBclk=~APBclk;
    end
endtask

