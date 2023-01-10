  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  LDR R12, [R1]     @ lengthA = byte[address];    // Length of set A
  ADD R1, R1, #4    @ address = address + 4;
  ADD R0, R0, #4    @ address = address + 4;      // Skip length of set slot
  MOV R3, #1        @ count = 1;
While:
  CMP R3, R12       @ while (count <= lengthA)
  BHI EndWhile      @ {
  LDR R4, [R1]      @   currentValue = byte[address];
  STR R4, [R0]      @   byte[address] = currentValue;
  ADD R0, R0, #4    @   address = address + 4;    // R0 address + 4
  ADD R1, R1, #4    @   address = address + 4;    // R1 address + 4
  ADD R3, R3, #1    @   count = count + 1;
  B   While         @ }
EndWhile:           @

  MOV R10, #4       @ step = 4;
  MUL R5, R12, R10  @ stepsBack = count*4;
  LDR R11, [R2]     @ lengthB = byte[address];
  ADD R2, R2, #4    @ address = address + 4;
  MOV R3, #1        @ countB = 1;
AddSetB:            @
  SUB R0, R0, R5    @ address = address - stepsBack;  // Back to beggining of set C
  CMP R3, R11       @ while (countB <= lengthB)
  BHI EndUnion      @ {
  LDR R4, [R2]      @   currentValue = byte[address]; // from set B
  MOV R7, #0        @   isTaken = false;
  MOV R8, #1        @   countC = 1;
CheckSetLoop:       @   
  CMP R8, R12       @   while (countC <= lengthC)
  BHI EndCheckSet   @   {
  LDR R6, [R0]      @     compareValue = byte[address]; // To compare with set B
  ADD R0, R0, #4    @     address = address + 4  // Step to next value in R0 (set C)
  ADD R8, R8, #1    @     countC = countC + 1;
  CMP R6, R4        @     if (compareValue == currentValue)
  BNE CheckSetLoop  @     {
  MOV R7, #1        @       isTaken = true;
  B   CheckSetLoop  @     }
EndCheckSet:        @   }
  ADD R3, R3, #1    @   countB = countB + 1;
  ADD R2, R2, #4    @   address = address + 4;
  CMP R7, #0        @   if (isTaken == false)
  BNE AddSetB       @   {
  ADD R12, R12, #1  @     lengthC = lengthC + 1;
  MUL R5, R12, R10  @     stepsBack = lengthC*4;
  STR R4, [R0]      @     byte[address] = currentValue; // Store in R0
  ADD R0, R0, #4    @     address = address + 4
  B   AddSetB       @   }
EndUnion:           @ }
  SUB R0, R0, #4    @ address = address - 4;   // Move to slot for length
  STR R12, [R0]     @ byte[address] = lengthC;
  
  @ problem going to next value in B *******
  

  

  

  

  @ End of program ... check your result

End_Main:
  BX    lr

