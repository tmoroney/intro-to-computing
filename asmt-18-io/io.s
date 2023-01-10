  .syntax unified
  .cpu cortex-m4
  .thumb
  .global Main
  .global SysTick_Handler
  .global EXTI0_IRQHandler

@ Uncomment if you are providing a EXTI0_IRQHandler subroutine
@  .global EXTI0_IRQHandler

  @ Definitions are in definitions.s to keep this file "clean"
  .include "definitions.s"

  .equ    BLINK_PERIOD, 500

@
@ To debug this program, you need to change your "Run and Debug"
@   configuration from "Emulate current ARM .s file" to "Graphic Emulate
@   current ARM .s file".
@
@ You can do this is either of the followig two ways:
@
@   1. Switch to the Run and Debug panel ("ladybug/play" icon on the left).
@      Change the dropdown at the top of the Run and Debug panel to "Graphic
@      Emulate current ARM .s file".
@
@   2. ctrl-shift-P (cmd-shift-P on a Mac) and type "Select and Start Debugging".
@      When prompted, select "Graphic Emulate ...".
@



Main:
  PUSH    {R4-R5,LR}


  @ Enable GPIO port D by enabling its clock
  LDR     R4, =RCC_AHB1ENR
  LDR     R5, [R4]
  ORR     R5, R5, RCC_AHB1ENR_GPIODEN
  STR     R5, [R4]

  @ Enable (unmask) interrupts on external interrupt Line0
  LDR     R4, =EXTI_IMR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Set falling edge detection on Line0
  LDR     R4, =EXTI_FTSR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Enable NVIC interrupt #6 (external interrupt Line0)
  LDR     R4, =NVIC_ISER
  MOV     R5, #(1<<6)
  STR     R5, [R4]

  @ Configure LD3,LD4,LD5,LD6 for output
  @ by setting bits 27:26 of GPIOD_MODER to 01 (GPIO Port D Mode Register)
  @ (by BIClearing then ORRing)
  LDR     R4, =GPIOD_MODER
  LDR     R5, [R4]                  @ Read ...
  BIC     R5, #(0b11<<(LD3_PIN*2))  @ Modify ...
  ORR     R5, #(0b01<<(LD3_PIN*2))  @ write 01 to bits 
  BIC     R5, #(0b11<<(LD4_PIN*2))  @ Modify ...
  ORR     R5, #(0b01<<(LD4_PIN*2))  @ write 01 to bits
  BIC     R5, #(0b11<<(LD5_PIN*2))  @ Modify ...
  ORR     R5, #(0b01<<(LD5_PIN*2))  @ write 01 to bits
  BIC     R5, #(0b11<<(LD6_PIN*2))  @ Modify ...
  ORR     R5, #(0b01<<(LD6_PIN*2))  @ write 01 to bits
  STR     R5, [R4]                  @ Write 


  @ We'll invert the LEDs (one after another) every 1s
  @ Initialise the first countdown to 1000 (1000ms)
  
  LDR     R4, =count
  MOV     R5, #1
  STR     R5, [R4]
  LDR     R4, =countdown
  LDR     R5, =BLINK_PERIOD
  STR     R5, [R4]  


  @ Configure SysTick Timer to generate an interrupt every 1ms

  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F                 @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @   16x10^6 / 10^3 - 1 = 15999 = 0x3E7F

  LDR   R4, =SYSTICK_VAL            @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @     by writing any value
  STR   R5, [R4]

  LDR   R4, =SYSTICK_CSR            @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                    @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @     set TICKINT (bit 1) to 1 to enable interrupts
                                    @     set ENABLE (bit 0) to 1

  @ Nothing else to do in Main
  @ Idle loop forever (welcome to interrupts!)
Idle_Loop:
  B     Idle_Loop
  
End_Main:
  POP   {R4-R5,PC}



@
@ External interrupt line 0 interrupt handler
@
  .type  EXTI0_IRQHandler, %function
EXTI0_IRQHandler:

  PUSH  {R4-R6,LR}
  
  LDR   R4, =gameOver
  LDR   R5, [R4]
  CMP   R5, #1                    @ if (gameOver == true)
  BNE   .LgameNotOver             @ {
  MOV   R5, #0                    @   gameOver = false;
  STR   R5, [R4]                  @
  LDR   R4, =SYSTICK_CSR          @   Stop SysTick timer
  LDR   R5, =0                    @     by writing 0 to CSR
  STR   R5, [R4]                  @     CSR is the Control and Status Register
  LDR   R4, =SYSTICK_LOAD         @   Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F               @   Assuming a 16MHz clock,
  STR   R5, [R4]                  @     16x10^6 / 10^3 - 1 = 15999 = 0x3E7F
  LDR   R4, =SYSTICK_VAL          @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                  @     by writing any value
  STR   R5, [R4]                  @
  LDR   R4, =SYSTICK_CSR          @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                  @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                  @     set TICKINT (bit 1) to 1 to enable interrupts

  LDR   R4, =count                @   Get count address
  MOV   R5, #1                    @
  STR   R5, [R4]                  @   Set count back to 1
  B     .LendInterrupt            @

.LgameNotOver:
  LDR   R4, =GPIOD_ODR            @   Check if LD5 (red light) is on when clicked
  LDR   R5, [R4]                  @
  LDR   R6, =0xFFFFFFFF           @
  BIC   R6, #(0b1<<(LD5_PIN))     @
  BIC   R5, R6                    @   Clear all bits, except for bit designated to LD5 (bit 14)
  LDR   R6, =0x00000000           @
  ORR   R6, #(0b1<<(LD5_PIN))     @   Move 1 to bit 14 (LD5) to compare and see if LD5 is on
  CMP   R5, R6                    @   if (redLightOn == true)
  BNE   .LnotOnRed                @   {
  LDR   R5, [R4]                  @
  EOR   R5, #(0b1<<(LD3_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  EOR   R5, #(0b1<<(LD4_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  EOR   R5, #(0b1<<(LD6_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR   R5, [R4]                  @
  B       .LstopTheClock          @   }
.LnotOnRed:                       @   else
  LDR   R5, [R4]                  @   {
  BIC   R5, #(0b1<<(LD3_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  BIC   R5, #(0b1<<(LD4_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  BIC   R5, #(0b1<<(LD5_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  BIC   R5, #(0b1<<(LD6_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR   R5, [R4]                  @   }

.LstopTheClock:
  LDR   R4, =SYSTICK_CSR          @   Stop SysTick timer
  LDR   R5, =0                    @     by writing 0 to CSR
  STR   R5, [R4]                  @     CSR is the Control and Status Register

  LDR   R4, =gameOver             @
  MOV   R5, #1                    @   gameOver = true;  
  STR   R5, [R4]

.LendInterrupt:
  LDR   R4, =EXTI_PR      @ Clear (acknowledge) the interrupt
  MOV   R5, #(1<<0)       @
  STR   R5, [R4]          @

  @ Return from interrupt handler
  POP  {R4-R6,PC}


@
@ SysTick interrupt handler
@
  .type  SysTick_Handler, %function
SysTick_Handler:

  PUSH  {R4-R7, LR}

  LDR   R4, =countdown              @ if (countdown != 0) {
  LDR   R5, [R4]                    @
  CMP   R5, #0                      @
  BEQ   .LelseFire                  @

  SUB   R5, R5, #1                  @   countdown = countdown - 1;
  STR   R5, [R4]                    @

  B     .LendIfDelay                @ }

.LelseFire:                         @ else {

  LDR     R4, =GPIOD_ODR            @   Invert the specified LED
  LDR     R5, [R4]                  @
  LDR     R6, =count                @   Get count of times round loop
  LDR     R7, [R6]                  @
  
  BIC     R5, #(0b1<<(LD3_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  BIC     R5, #(0b1<<(LD4_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  BIC     R5, #(0b1<<(LD5_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  BIC     R5, #(0b1<<(LD6_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR     R5, [R4]                  @

  CMP     R7, #1                    @   if (count == 1) 
  BNE     .LnotOne                  @   {
  EOR     R5, #(0b1<<(LD3_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  STR     R5, [R4]                  @
  B       .LisInverted              @   }
.LnotOne:
  CMP     R7, #2                    @   if (count == 2) 
  BNE     .LnotTwo                  @   {
  EOR     R5, #(0b1<<(LD4_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  STR     R5, [R4]                  @
  B       .LisInverted              @   }
.LnotTwo:
  CMP     R7, #3                    @   if (count == 3) 
  BNE     .LnotThree                @   {
  EOR     R5, #(0b1<<(LD6_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  STR     R5, [R4]                  @
  B       .LisInverted              @   }
.LnotThree:
  CMP     R7, #4                    @   if (count == 4) 
  BNE     .LisInverted              @   {
  EOR     R5, #(0b1<<(LD5_PIN))     @     GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR     R5, [R4]                  @   }
.LisInverted:
  CMP     R7, #5                    @   if (count == 5)
  BNE     .LcountNotDone            @   {
  MOV     R7, #1                    @     count = 1;
  B       .LendIfDelay              @   }
.LcountNotDone:                     @   else {
  ADD     R7, R7, #1                @     count = count + 1;
  LDR     R4, =countdown            @   countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD         @
  STR     R5, [R4]                  @      

.LendIfDelay:                    
  STR     R7, [R6]                  @
  LDR     R4, =SCB_ICSR             @ Clear (acknowledge) the interrupt
  LDR     R5, =SCB_ICSR_PENDSTCLR   @
  STR     R5, [R4]                  @

  @ Return from interrupt handler
  POP  {R4-R7, PC}


  .section .data

countdown:
  .space  4

count:
  .space  4

gameOver:
  .space  4

  .end
