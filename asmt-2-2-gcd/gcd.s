  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will compute
  @   the GCD (greatest common divisor) of two numbers in R2 and R3.
  @ a = R2   b = R3
  
WhileBranch:
  CMP R2, R3
  BEQ EndBranch
  BLO ElseBranch
  SUB R2, R2, R3
  B WhileBranch
ElseBranch:
  SUB R3, R3, R2
  B WhileBranch
EndBranch:
  MOV R0, R2

  @ End of program ... check your result

End_Main:
  BX    lr

.end
