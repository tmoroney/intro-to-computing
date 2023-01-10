  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  LDRB  R2, [R1]       @ ch = byte[address];
  CMP   R2, #0x00      @ if (ch == 0) {
  BEQ   ZeroBranch     @   result = 0;
                       @ }
While:                 @ else {
  CMP   R2, #0x00      @ while (ch != 0) {
  BEQ   EndBranch      @
  MOV   R3, #0         @   count = 0;
ConvertToLwr:          @   while ((ch != ' ') | (ch != 0))   // space = 0x32
  CMP   R2, #' '       @   {
  BEQ   EndConvert     @
  CMP   R2, #0x00      @
  BEQ   EndConvert     @
  CMP   R2, #'A'       @     if (ch >= 'A' && ch <= 'Z')
  BLO   EndIfLwr       @     {
  CMP   R2, #'Z'       @       
  BHI   EndIfLwr       @     
  ADD   R2, R2, #0x20  @       ch = ch + 0x20;
  STRB  R2, [R1]       @       byte[address] = ch;
EndIfLwr:              @     }
  ADD   R3, R3, #1     @     count = count + 1;
  ADD   R1, R1, #1     @     address = address + 1;
  LDRB  R2, [R1]       @     ch = byte[address];
  B     ConvertToLwr   @   }

EndConvert:            @   
  SUB   R1, R1, R3     @   address = address - count;
  SUB   R1, R1, #1     @   address = address - 1;
  LDR   R6, =-1        @   i = -1    // number of steps to go back
NotLetter:             @   while (ch >= 'a' && ch <= 'z') {
  ADD   R6, R6, #1     @   i = i + 1
  ADD   R1, R1, #1     @     address = address + 1;
  LDRB  R2, [R1]       @     ch = byte[address]
  CMP   R2, #'a'       @   
  BLO   NotLetter      @     if (ch >= 'a' && ch <= 'z')
  CMP   R2, #'z'       @     {
  BHI   NotLetter      @   
  SUB   R2, R2, #0x20  @       ch = ch - 0x20;
  STRB  R2, [R1]       @       byte[address] = ch;
UprCase:               @     }
  SUB   R1, R1, R6     @   address = address - i;
  ADD   R4, R3, #1     @   getNewWordAddress = count + 1;
  ADD   R1, R1, R4     @   address = address + count;
  LDRB  R2, [R1]       @   ch = byte[address];
  B     While          @ }
ZeroBranch:
  MOV R0, #0
EndBranch:


  @
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the following watch expression: (unsigned char [64]) strA
  @
  @   OR
  @
  @   Open a Memory View specifying the address 0x20000000 and length at least 11
  @   You can open a Memory View with ctrl-shift-p type view memory (cmd-shift-p on a Mac)
  @

  @ End of program ... check your result

End_Main:
  BX    lr

