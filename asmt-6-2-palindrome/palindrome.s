  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
  LDR   R8, =0x20000000 @ create space to store lowercase converted string A
  LDR   R9, =0x20000080 @ create space to store lowercase converted string B
  MOV   R0, #0          @ isPalindrome = false;
  MOV   R4, #0          @ count = 0;

ConvertToLower:        @
  LDRB  R2, [R1]       @ ch = byte[address]
  CMP   R2, #0         @ while (ch != 0)
  BEQ   EndConvert     @ {
  CMP   R2, #'A'       @   if (ch >= 'A' && ch <= 'Z')
  BLO   EndIfLwr       @   {
  CMP   R2, #'Z'       @       
  BHI   EndIfLwr       @     
  ADD   R2, R2, #0x20  @     ch = ch + 0x20;
EndIfLwr:              @   }
  STRB  R2, [R8]       @   byte[address] = ch;
  STRB  R2, [R9]       @   byte[address] = ch;
  ADD   R4, R4, #1     @   count = count + 1;
  ADD   R8, R8, #1     @   addressB = addressB + 1
  ADD   R9, R9, #1     @   addressB = addressB + 1
  ADD   R1, R1, #1     @   address = address + 1;
  B     ConvertToLower @ }
EndConvert:
  
  SUB   R8, R8, R4     @ addressA = addressA - count;
  SUB   R8, R8, #1     @ addressA = addressA - 1;
  ADD   R9, R9, #1     @ addressB = addressB + 1;
TestCharA:             @
  ADD   R8, R8, #1     @ addressA = addressA + 1;
  LDRB  R2, [R8]       @ charA = byte[addressA];
  CMP   R2, #0         @ while (charA != 0)
  BEQ   EndWhile       @ {
  CMP   R2, #'a'       @   if (charA >= 'a' && charA <= 'z')
  BLO   TestCharA      @   {
  CMP   R2, #'z'       @  
  BHI   TestCharA      @    

TestCharB:             @
  SUB   R9, R9, #1     @     addressB = addressB - 1;
  LDRB  R3, [R9]       @     charB = byte[addressB];
  CMP   R3, #'a'       @     
  BLO   TestCharB      @     if (charA >= 'a' && charA <= 'z')
  CMP   R3, #'z'       @     {
  BHI   TestCharB      @
  CMP   R3, R2         @       if (charB != charA)
  BEQ   IsPalindrome   @       {
  MOV   R0, #0         @         isPalindrome = false;
  B     EndWhile       @       }
IsPalindrome:          @       else {
  MOV   R0, #1         @         isPalindrome = true;
  ADD   R1, R1, R5     @         address = address + countB;
  B     TestCharA      @       }
                       @     }
EndWhile:              @   }
                       @ }

  @ End of program ... check your result

End_Main:
  BX    lr

