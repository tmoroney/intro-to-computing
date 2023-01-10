  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   x^3 - 4x^2 + 3x + 8

  MUL R0, R1, R1
  MUL R0, R0, R1
  MUL R2, R1, R1
  MOV R7, #4
  MUL R2, R2, R7
  MOV R8, #3
  MUL R3, R1, R8
  SUB R0, R0, R2
  ADD R2, R3, #8
  ADD R0, R0, R2
  

  @ End of program ... check your result

End_Main:
  BX    lr

.end
