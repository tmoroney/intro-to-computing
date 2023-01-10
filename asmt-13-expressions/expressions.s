  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
  MOV  R0, #0
While:
  LDRB R2, [R1]        @ char = byte[address];
  CMP  R2, #0x20       @ if (char == ' ')
  BNE  NotSpace        @ {
  ADD  R1, R1, #1      @   address = address + 1;
  B    While           @
NotSpace:              @ }
  CMP  R2, #'+'        @ while (char!='+'
  BEQ  AddNumbers      @   &&
  CMP  R2, #'-'        @   char != '-'
  BEQ  SubNumbers      @   &&
  CMP  R2, #'*'        @   char != '*'
  BEQ  MultiplyNumbers @   &&
  CMP  R2, #0          @   char != 0 )
  BEQ  EndBranch       @ {
  SUB  R2, R2, #0x30   @   num = char - 0x30;
  ADD  R1, R1, #1      @   address = address + 1;

CheckMultiDigit:       @   while (nextChar != ' ' && nextChar != 0) {
  LDRB R3, [R1]        @     nextChar = byte[address];
  ADD  R1, R1, #1      @     address = address + 1;      
  CMP  R3, #0x20       @     is nextChar == ' '?
  BEQ  EndOfNum        @ 
  CMP  R3, #0          @     is nextChar == 0?
  BEQ  EndOfNum        @     
  MOV  R4, #10         @     temp = 10;
  MUL  R2, R2, R4      @     num = num * temp;
  SUB  R3, R3, #0x30   @     nextDigit = nextChar - 0x30;
  ADD  R2, R2, R3      @     num = num + nextDigt;
  B    CheckMultiDigit @
EndOfNum:              @   }
  PUSH {R2}            @   Push num to stack;
  B    While           @ }  

AddNumbers:
  POP  {R5, R6}        @ Pop num1 and num2 off the stack;
  ADD  R2, R5, R6      @ result = num1 + num2;
  PUSH {R2}            @ Push result to stack;
  ADD  R1, R1, #1      @ address = address + 1;
  B    While

SubNumbers:
  POP  {R5, R6}        @ Pop num1 and num2 off the stack;
  SUB  R2, R6, R5      @ result = num1 - num2;
  PUSH {R2}            @ Push result to stack;
  ADD  R1, R1, #1      @ address = address + 1;
  B    While

MultiplyNumbers:
  POP  {R5, R6}        @ Pop number1 and number2 off the stack;
  MUL  R2, R5, R6      @ finalResult = number1 * number2;
  PUSH {R2}            @ Push result to stack;
  ADD  R1, R1, #1      @ address = address + 1;
  B    While

EndBranch:
  POP  {R0}            @ Pop the final result off the stack;

  @
  @ You can use either
  @
  @   The System stack (R13/SP) with PUSH and POP operations
  @
  @   or
  @
  @   A user stack (R12 has been initialised for this purpose)
  @


  @ End of program ... check your result

End_Main:
  BX    lr

