  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  SUB R4, R1, R3             @ aLim = NA - NB;
  MOV R5, #0                 @ isSub = false;
  MOV R6, #0                 @ ra = 0;
While:                       @
  CMP R6, R4                 @ while (ra <= aLim
  BHI EndWhile               @   &&
  CMP R5, #0                 @   isSub == false)
  BNE EndWhile               @ {
  MOV R7, #0                 @   ca = 0;
FindIsSub:                   @
  CMP R7, R4                 @   while (ca <= aLim
  BHI EndIfSub               @     &&
  CMP R5, #0                 @     isSub == false)
  BNE EndIfSub               @   {
  MOV R5, #1                 @     isSub = true;
  MOV R8, #0                 @     rb = 0;
CompareToArrayB:             @
  CMP R8, R3                 @     while (rb < NB
  BHS EndCompare             @       &&
  CMP R5, #1                 @       isSub == true)
  BNE EndCompare             @     {
  MOV R9, #0                 @       cb = 0;
CheckElements:               @
  CMP R9, R3                 @       while (cb < NB
  BHS EndCheck               @         &&
  CMP R5, #1                 @         isSub == true)
  BNE EndCheck               @       {
  ADD R10, R6, R8            @         row = ra+rb;
  MUL R10, R10, R1           @         index = row * row_sizeA;
  ADD R11, R7, R9            @         col = ca+cb;
  ADD R10, R10, R11          @         index = index + col;
  LDR R11, [R0, R10, LSL #2] @         elemA = A[ra+rb][ca+cb];
  MUL R10, R8, R3            @         index = row * row_sizeB;
  ADD R10, R10, R9           @         index = index + col;
  LDR R12, [R2, R10, LSL #2] @         elemB = B[rb][cb];
  ADD R9, R9, #1             @         cb = cb + 1;
  CMP R11, R12               @         if (elemA != elemB)
  BEQ CheckElements          @         {
  MOV R5, #0                 @           isSub = false;
  B   CheckElements          @         }
EndCheck:                    @       }
  ADD R8, R8, #1             @       rb = rb + 1;
  B CompareToArrayB          @     }
EndCompare:                  @
  ADD R7, R7, #1             @     ca = ca + 1;
  B   FindIsSub              @   }
EndIfSub:                    @
  ADD R6, R6, #1             @   ra = ra + 1;
  B   While                  @ }
EndWhile:                    @
  MOV R0, #0                 @ result = 0;
  CMP R5, #1                 @ if (isSub == true)
  BNE EndBranch              @ {
  MOV R0, #1                 @   result = 1;
EndBranch:                   @ }

  @ End of program ... check your result

End_Main:
  BX    lr

