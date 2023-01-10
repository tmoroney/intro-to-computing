  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  
  @ int number = -365;
	@ if (number < 0) {
	@	  System.out.println("-");
	@ }
	@ int count = 0;
	@ int currentNum = number;
	@ while (currentNum != 0) {
	@ 	currentNum = currentNum/10;
	@	  count = count + 1;
	@ }
  @ int currentNum = Math.abs(number);
	@ int singleNum = 0;
	@ for (count = count - 1; (count >= 0); --count) {
	@	  singleNum = currentNum % 10;
	@	  currentNum = currentNum/10;
	@	  int conversion = singleNum + 48;
	@	  System.out.println(conversion);
	@ }

  CMP  R1, #0        @ if (number == 0)
  BNE  NotZero       @ {
  LDR  R3, =0x30     @   word[address] = '0'
  STR  R3, [R0]      @ }
  B EndBranch        
  
NotZero:
  LDR  R3, =0x2B     @ sign = '+';
  STR  R3, [R0]      @ word[address] = sign;
  CMP  R1, #0        @ if (number < 0)
  BGT  PositiveNum       @ {
  LDR  R3, =0x2D     @   sign = '-';
  STRB R3, [R0]      @   byte[address] = sign;
  RSB  R1, R1, #0    @   number = Math.abs(number);
PositiveNum:
  MOV  R2, R1        @ int currentNum = number;
  MOV  R4, #0        @ int count = 0;
  MOV  R5, #10       @ int divisor = 10; 
Counter:             @ }
  CMP  R2, #0        @ while (currentNum != 0)
  BEQ  EndCounter    @ {
  UDIV R2, R2, R5    @   currentNum = currentNum/10;
  ADD  R4, R4, #1    @	 count = count + 1;
  B Counter          @ }

EndCounter:
  ADD  R6, R4, #1    @ int lastAddress = count + 1;
  ADD  R0, R0, R6    @ address = address + lastAddress;
  MOV  R7, #0x00     @ // To NULL-terminate the string
  STR  R7, [R0]      @ byte[address] = 0;
  LDR  R8, =0x01
  LDR  R9, =0x30
  MOV  R6, #0        @ int singleNum = 0;
While:
  SUB  R0, R0, #1
  CMP  R4, #0        @ while (count > 0)
  BLE  EndBranch     @ {
  UDIV R3, R1, R5    @   // Starting number - (WholeQuotient * Divisor) to find remainder
  MUL  R6, R3, R5    @   // e.g  36/10 = 36 - (10*3)
  SUB  R6, R1, R6    @   singleNum = number % 10;
  UDIV R1, R1, R5    @   number = number/10;
  MUL  R6, R6, R8    @   singleNum = (singleNum)*(0x01)
  ADD  R10, R6, R9   @   convertedNum = singleNum + 0x30
  STRB R10, [R0]     @   byte[address] = singleNum
  SUB  R4, R4, #1    @   count = count - 1
  B While            @ }
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

