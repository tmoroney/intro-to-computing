  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  MOV   R3, #1           @ i = 1; 
  LDR   R4, [R1]         @ value = word[address];
  MOV   R10, #0          @ maxCount = 0;
  MOV   R11, #0          @ currentMode = 0;
While:                   @
  CMP   R3, R2           @ while (i <= 8)
  BHI   EndWhile         @ {
  MOV   R6, #1           @   j = 1;
  MOV   R7, #0           @   count = 0;
OccuranceCounter:        @   
  CMP   R6, R2           @   while (j <= 8)
  BHI   EndOccurCounter  @   {
  LDR   R5, [R1]         @     currentValue = word[address];
  ADD   R6, R6, #1       @     j = j + 1;
  ADD   R1, R1, #4       @     address = address + 4
  CMP   R5, R4           @     if (currentValue == value)
  BNE   OccuranceCounter @     {
  ADD   R7, R7, #1       @       count = count + 1;
  B OccuranceCounter     @     }
                         @   }  
EndOccurCounter:         @
  CMP   R7, R10          @   if (count > maxCount)
  BLS   NotMode          @   {
  MOV   R10, R7          @     maxCount = count;
  MOV   R0, R4          @     currentMode = value;
NotMode:                 @   }    
  MOV   R6, #4           @   // so I can jump back to the start of the list
  MUL   R7, R2, R6       @   backToStart = (8)*(4);
  SUB   R1, R1, R7       @   address = address - backToStart;
  MUL   R9, R3, R6       @   // so that I can step forward in the program
  ADD   R1, R1, R9       @   address = address + (i)*(4);
  LDR   R4, [R1]         @   value = word[address];
  SUB   R1, R1, R9       @   address = address - (i)*(4);
  ADD   R3, R3, #1       @   i = i + 1;
  B While                @ }
EndWhile:


  @ End of program ... check your result

End_Main:
  BX    lr

