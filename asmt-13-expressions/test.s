  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb

  .global Init_Test
  .global rpn_expr

  .equ  USR_STACK_SIZE,0x400

  .section  .text


  .type     Init_Test, %function
Init_Test:

  LDR     R1, =rpn_expr           @ start address of a string containing
                                  @   the RPN expression
  
  LDR     R12, =user_stack_top    @ stack pointer for a user stack that
                                  @ you can use instead of the system stack
  
  BX      LR


  .section  .rodata

rpn_expr:
  .asciz   "5 "           @ test RPN expression


  .section  .data
user_stack:
  .space    USR_STACK_SIZE        @ Space for the user stack
user_stack_top:

.end
