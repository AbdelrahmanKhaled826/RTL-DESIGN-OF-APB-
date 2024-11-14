#RTL DESIGN OF ABP

➢ The APB (Advanced Peripheral Bus) protocol is a low-cost interface, optimized for minimal power consumption and reduced interface complexity. 

➢ The APB interface is not pipelined and is a simple synchronous protocol (clock required for transaction).

 ➢ Every transfer takes at least two cycles to complete.
 
 ➢ The APB operates under a bridge, which links it to the higher performance AHB or ASB buses. In this setup, the bridge acts as the master, while the connected peripherals are the slaves.

> ## APB SIGNAL DESCRIPTION:

![image](https://github.com/user-attachments/assets/9488d6d1-2799-4b33-a2e8-99b99125acd7)

> ## APB INTERFACE BLOCK DIAGRAM WITH SLAVES:

![image](https://github.com/user-attachments/assets/240f278c-41c9-4af7-a954-cddeaf07baf4)

> ## OPERATION OF APB:
 The state machine operates through the following states:

 ![image](https://github.com/user-attachments/assets/3a1bbc9e-acf3-41ca-8e5c-b4e1f5a3354d)

 ➢ IDLE This is the default state of the APB interface.

 ➢ SETUP When a transfer is required, the interface moves into the SETUP state, where the appropriate select signal, PSEL is 
asserted. The interface only remains in the SETUP state for one clock cycle and always moves to the ACCESS state on the next 
rising edge of the clock.

 ➢ ACCESS The enable signal, PENABLE is asserted in the ACCESS state. The signal must not change in the transition between 
SETUP and ACCESS and between cycles in the ACCESS state

> ## SIMULATIONS:
> #### MASTER WRITE OPERATION

![image](https://github.com/user-attachments/assets/1ca0f5fe-b66b-4267-9a4d-f47be6238ea4)

> #### MASTER READ OPERATION

![image](https://github.com/user-attachments/assets/0b586623-e3cd-4a30-8115-9b33804dc0d6)

> ## RTL SCHEMATIC :

![image](https://github.com/user-attachments/assets/f243dcdb-44b1-44e0-90ba-f81d9ca14cbb)

> ## RTL IMPLEMENTATION:

![image](https://github.com/user-attachments/assets/f030e7a3-a182-44ba-b86c-1322372b827b)

> ##  TIMING REPORT:

![image](https://github.com/user-attachments/assets/244e8071-99cd-474d-ac92-47606db3f04e)

> ##  UTILLIZATION REPORT:

![image](https://github.com/user-attachments/assets/dfa916a0-1e53-49c2-be2d-38f1ecf5a53c)


> ##  POWER REPORT:
![image](https://github.com/user-attachments/assets/a2110a14-6795-49d0-ad73-7bf797756d12)

![image](https://github.com/user-attachments/assets/22f6fb8f-8fa5-4719-bded-ff803ff2f19d)






