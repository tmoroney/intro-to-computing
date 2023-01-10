  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will divide a
  @   value, a, in R2 by another value, b, in R3.
  @ R2 = a    R3 = b
  
  MOV R0, #0
WhileBranch:
  CMP R3, #0
  BEQ EndBranch
  CMP R2, R3
  BLO EndBranch
  SUB R2, R3
  ADD R0, #1
  B WhileBranch
EndBranch:
  MOV R1, R2

  @ End of program ... check your result

End_Main:
  BX    lr

.end
