  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language program to evaluate
  @   ax^2 + bx + c for given values of a, b, c and x
  @   a = R2   b = R3   c = R4  x = R1

  MUL R7, R1, R1
  MUL R7, R7, R2
  MUL R8, R3, R1
  ADD R0, R7, R8
  ADD R0, R0, R4


  @ End of program ... check your result

End_Main:
  BX    lr

.end
