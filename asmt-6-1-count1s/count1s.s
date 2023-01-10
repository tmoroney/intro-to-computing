  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ R6 (count)
  @ R7 (oneCount)
  @ R8 (maxOnes)
  
  MOV  R6, #0          @ count = 0;
  MOV  R7, #0          @ oneCount = 0;
  MOV  R8, #0          @ maxOnes = 0;
While:                 @
  ADD  R6, R6, #1      @ count = count + 1;
  CMP  R6, #32         @ while (count <= 32)
  BHI  EndWhile        @ {
  MOVS R1, R1, LSL #1  @   binary = binary(shifted left)
  BCC  NotOne          @   if (carry == true) {
  ADD  R7, R7, #1      @     oneCount = oneCount + 1;
  B    While           @   }
NotOne:                @   else {
  CMP  R7, R8          @     if (oneCount > maxOnes)
  BLO  NotMaxOnes      @     {
  MOV  R8, R7          @       maxOnes = oneCount;
NotMaxOnes:            @     }
  MOV  R7, #0          @     oneCount = 0;
  B    While           @   }
EndWhile:              @ }
  CMP  R8, #0          @ if (maxOnes == 0)
  BNE  NotAllOnes      @ {
  MOV  R8, R7          @   maxOnes = oneCount;
NotAllOnes:            @ }
  MOV  R0, R8          @ result = maxOnes;


  @ End of program ... check your result

End_Main:
  BX    lr

.end
