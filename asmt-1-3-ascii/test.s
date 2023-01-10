  .syntax unified
  .cpu cortex-m4
  .thumb

  .global  Init_Test

  .section  .text

  .type     Init_Test, %function
Init_Test:
  @ Evaluate for 2034 (0x7F2)
  LDR   R1, =0x33   @ '4'   - 0x30 = 4 x 1 = 4
  LDR   R2, =0x35   @ '3'   - 0x30 = 3 x 10 = 30
  LDR   R3, =0x32   @ '0'   - 0x30 = 0 x 100 = 000
  LDR   R4, =0x31   @ '2'   - 0x30 = 2 x 1000 = 2000

                                            @ = 2034 (0x7F2)

  @ Alternatively, you can initialise this way ...
  @ LDR   R1, ='4'
  @ LDR   R2, ='3'
  @ LDR   R3, ='0'
  @ LDR   R4, ='2'

  bx    lr

.end