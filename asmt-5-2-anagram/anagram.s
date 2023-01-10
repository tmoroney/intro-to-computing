  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

@ ********* testing ********

  LDRB  R8, [R1]       @ totalA = byte[address]
  ADD   R1, R1, #1     @ address = address + 1;
AddBytesA:
  CMP   R3, #0         @ while (ch != 0)
  BEQ   EndAddBytesA   @ {
  LDRB  R3, [R1]       @   char = byte[address];
  ADD   R8, R8, R3     @   totalA = totalA + char;
  ADD   R1, R1, #1     @   address = address + 1;
  B     AddBytesA      @ }
EndAddBytesA:

  LDRB  R9, [R2]       @ totalB = byte[address]
  ADD   R2, R2, #1     @ address = address + 1;
AddBytesB:             @
  CMP   R3, #0         @ while (ch != 0)
  BEQ   EndAddBytesB   @ {
  LDRB  R3, [R2]       @   char = byte[address];
  ADD   R9, R9, R3     @   totalB = totalB + char;
  ADD   R2, R2, #1     @   address = address + 1;
  B     AddBytesB      @ }
EndAddBytesB:          @
  MOV   R0, #0         @ isAnagram = false;
  CMP   R8, R9         @ if (totalA == totalB)
  BNE   NotAnagram     @ {
  MOV   R0, #1         @   isAnagram = true;
NotAnagram:

@ ********* testing ********

  MOV   R5, #0         @ countA = 0
  LDRB  R3, [R1]       @ ch = byte[address];
LowerStringA:          @
  CMP   R3, #0         @ while (ch != 0)
  BEQ   EndConvertA    @ {
  ADD   R5, R5, #1     @   countA = countA + 1;
  CMP   R3, #'A'       @   if (ch >= 'A' && ch <= 'Z')
  BLO   EndIfLwrA      @   {
  CMP   R3, #'Z'       @
  BHI   EndIfLwrA      @
  ADD   R3, R3, #0x20  @     ch = ch + 0x20;
  STRB  R3, [R1]       @     byte[address] = ch;
EndIfLwrA:             @   }
  ADD   R1, R1, #1     @   address = address + 1;
  LDRB  R3, [R1]       @   ch = byte[address];
  B     LowerStringA   @ }
EndConvertA:           @
  SUB   R1, R1, R5     @ address = address - countA;
  
  MOV   R6, #0         @ countB = 0;
  LDRB  R3, [R2]       @ ch = byte[address];
LowerStringB:          @
  CMP   R3, #0         @ while (ch != 0)
  BEQ   EndConvertB    @ {
  ADD   R6, R6, #1     @   countB = countB + 1
  CMP   R3, #'A'       @   if (ch >= 'A' && ch <= 'Z')
  BLO   EndIfLwrB      @   {
  CMP   R3, #'Z'       @
  BHI   EndIfLwrB      @
  ADD   R3, R3, #0x20  @     ch = ch + 0x20;
  STRB  R3, [R2]       @     byte[address] = ch;
EndIfLwrB:             @   }
  ADD   R2, R2, #1     @   address = address + 1;
  LDRB  R3, [R2]       @   ch = byte[address];
  B     LowerStringB   @ }
EndConvertB:
  SUB   R2, R2, R6     @ address = address - countB

While:
  LDRB  R3, [R1]       @ char = byte[address];
  CMP   R3, #0         @ while (char != 0)
  BEQ   EndWhile       @ {
  ADD   R1, R1, #1     @   address = address + 1;
  LDRB  R4, [R2]       @   compareChar = byte[address];
  MOV   R10, #0        @   inWord = false;
  LDR   R7, =-1        @   index = -1;
CompareToB:            @
  CMP   R4, #0         @   while (compareChar != 0)
  BEQ   EndCompare     @   {
  ADD   R7, R7, #1     @     index = index + 1;
  CMP   R4, R3         @     if (compareChar == char)
  BNE   NotEqual       @     {
  MOV   R10, #1        @       inWord = true;
  MOV   R8, #'$'       @
  STRB  R8, [R2]       @       byte[address] == $;  // destroy value
  B     EndCompare     @       // break out of while loop
NotEqual:              @     }
  ADD   R2, R2, #1     @     address = address + 1;
  LDRB  R4, [R2]       @     compareChar = byte[address];
  B     CompareToB     @   }
EndCompare:            @  
  SUB   R2, R2, R7     @ address = address - index;
  MOV   R0, R10        @ isAnagram = inWord;
  B     While          @
EndWhile:              @ }
  CMP   R5, R6         @ if (countA != countB)
  BEQ   EndBranch      @ {
  MOV   R0, #0         @   isAnagram = false;
EndBranch:             @ }


  @ End of program ... check your result

End_Main:
  BX    lr

