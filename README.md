#RTL DESIGN OF ABP

➢ The APB (Advanced Peripheral Bus) protocol is a low-cost interface, optimized for minimal power consumption and reduced interface complexity. 

➢ The APB interface is not pipelined and is a simple synchronous protocol (clock required for transaction).

 ➢ Every transfer takes at least two cycles to complete.
 
 ➢ The APB operates under a bridge, which links it to the higher performance AHB or ASB buses. In this setup, the bridge acts as the master, while the connected peripherals are the slaves.

