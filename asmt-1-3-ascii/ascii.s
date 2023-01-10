  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @    a sequence of four ASCII characters, each representing a
  @    decimal digit, into the value represented by the
  @    sequence.
  
  @ e.g. '2', '0', '3', '4' (or 0x32, 0x30, 0x33, 0x34) to 2034 (0x7F2)

  LDR R6, =0x30
  SUB R1, R1, R6
  LDR R7, =10
  SUB R2, R2, R6
  MUL R2, R2, R7
  LDR R7, =100
  SUB R3, R3, R6
  MUL R3, R3, R7
  LDR R7, =1000
  SUB R4, R4, R6
  MUL R4, R4, R7
  ADD R0, R1, R2
  ADD R0, R0, R3
  ADD R0, R0, R4

  @ End of program ... check your result

End_Main:
  BX    lr

.end
