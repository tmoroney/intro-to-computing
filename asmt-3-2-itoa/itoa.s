  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @   a signed value (integer) in R3 into three ASCII characters that
  @   represent the integer as a decimal value in ASCII form, prefixed
  @   by the sign (+/-).
  @ The first character in R0 should represent the sign
  @ The second character in R1 should represent the most significaint digit
  @ The third character in R2 should represent the least significant digit
  @ Store 'N', '/', 'A' if the integer is outside the range -99 ... 0 ... +99
  
  LDR R0, =0x20
  LDR R1, =0x30
  LDR R2, =0x30
  LDR R7, =0x30  @ ASCII zero
  LDR R8, =0x01  @ ASCII one
  MOV R4, #10
  CMP R3, #0
  BEQ EndBranch
  LDR R0, =0x2B
  BGT PositiveNum @ Negative or Positive Number
  RSB R3, R3, #0
  LDR R0, =0x2D
PositiveNum:
  UDIV R5, R3, R4 @ How many 10s are there?
  UDIV R9, R5, R4
  CMP R9, #0      @ Test for out of range
  BNE NotInRange
  MUL R6, R5, R4
  MUL R1, R5, R8
  ADD R1, R1, R7
  SUB R2, R3, R6  @ Take away that amount of 10s from the number to get the least significant digit.
  MUL R2, R2, R8
  ADD R2, R2, R7  @ Converting number to ASCII
  B EndBranch
NotInRange:
  LDR R0, ='N'
  LDR R1, ='/'
  LDR R2, ='A'
EndBranch:

  @ End of program ... check your result

End_Main:
  BX    lr

.end
