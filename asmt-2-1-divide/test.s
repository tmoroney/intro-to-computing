  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Test by dividing a=23 by b=5
  LDR   R2, =28
  LDR   R3, =0

  bx    lr

.end