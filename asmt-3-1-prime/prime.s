  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @
  @ Write an ARM Assembly Language Program that will determine
  @   whether the unsigned number in R1 is a prime number
  @
  @ Output:
  @   R0: 1 if the number in R1 is prime
  @       0 if the number in R1 is not prime
  @

  MOV R0, #1
  MOV R2, #2
  UDIV  R3, R1, R2
  CMP R1, #1
  BHI ForLoop
  MOV R0, #0
  B EndBranch
ForLoop:
  CMP R2, R3        @ i <= num / 2
  BHI EndBranch
  UDIV R4, R1, R2   @ Starting number - (WholeQuotient * Divisor) so 8 / 2 => 8 - (4*2) to find remainder
  MUL R5, R4, R2
  SUB R6, R1, R5
  ADD R2, R2, #1
  CMP R6, #0
  BNE ForLoop
  MOV R0, #0
EndBranch:

  @ End of program ... check your result

End_Main:
  BX    lr

.end
