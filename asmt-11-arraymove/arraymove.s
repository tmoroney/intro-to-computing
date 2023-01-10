  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @ ---- Sudo Code Answer ----
  @ numToMove = index[old];
  @ for (i=index[old]; newIndex < oldIndex && i>newIndex; i--) {
  @   index[i] = index[i-1]
  @ }
  @ for (i=index[old]; newIndex > oldIndex && i<newIndex; i++) {
  @   index[i] = index[i+1]
  @ }
  @ index[new] = numToMove
  

  LDR R3, [R0, R1, LSL #2]  @ numToMove = index[old];
  MOV R5, R1                @ i=index[old];
  CMP R2, R1                @ if (newIndex < oldIndex)
  BHI OldIndexFirst         @ {
NewIndexFirst:              @
  CMP R5, R2                @   while (i>newIndex)
  BLS EndWhile              @   {
  SUB R6, R5, #1            @     stepBack = i-1;
  LDR R4, [R0, R6, LSL #2]  @     tmpNum = index[stepBack];
  STR R4, [R0, R5, LSL #2]  @     index[i] = tmpNum;
  SUB R5, R5, #1            @     i--
  B   NewIndexFirst         @   }
                            @ }
                            @ else {
OldIndexFirst:              @
  CMP R5, R2                @   while (i<newIndex)
  BHS EndWhile              @   {
  ADD R6, R5, #1            @     stepForward = i+1;
  LDR R4, [R0, R6, LSL #2]  @     tmpNum = index[stepForward];
  STR R4, [R0, R5, LSL #2]  @     index[i] = tmpNum;
  ADD R5, R5, #1            @     i++
  B   OldIndexFirst         @   }
                            @ }
EndWhile:                   @
  STR R3, [R0, R2, LSL #2]  @ index[new] = numToMove

  @ End of program ... check your result

End_Main:
  BX    lr

