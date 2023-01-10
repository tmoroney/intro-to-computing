  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_add

@ fp_add subroutine
@ Add two IEEE-754 floating point numbers
@
@ Paramaters:
@   R0: a - first number
@   R1: b - second number
@
@ Return:
@   R0: result - a+b
@
fp_add:
  PUSH    {R4-R8,LR}              @ add any registers R4...R12 that you use

  PUSH    {R0, R1}                @
  BL      fp_frac                 @ fracA = return;
  MOV     R4, R0                  @
  POP     {R0, R1}                @
  PUSH    {R0, R1}                @
  BL      fp_exp                  @
  MOV     R6, R0                  @ expA = return;
  POP     {R0, R1}                @
  PUSH    {R0, R1}                @
  MOV     R0, R1                  @
  BL      fp_frac                 @
  MOV     R5, R0                  @ fracB = return;
  POP     {R0, R1}                @
  PUSH    {R0, R1}                @
  MOV     R0, R1                  @
  BL      fp_exp                  @
  MOV     R7, R0                  @ expB = return;
  POP     {R0, R1}                @
                                  
  CMP     R6, R7                  @ if (expA < expB)
  BGE     ExpNotSmaller           @ {
  SUB     R8, R7, R6              @   shiftAmount = expB - expA;
  MOV     R4, R4, ASR R8          @   fracA = fracA shifted right by shiftAmount;
  MOV     R1, R7                  @   exponent = expB;
  B       NumAdjusted             @ }
ExpNotSmaller:                    @
  CMP     R7, R6                  @ if (expB < expA)
  BGE     ExpIsSame               @ {
  SUB     R8, R6, R7              @   shiftAmount = expA - expB;
  MOV     R5, R5, ASR R8          @   fracB = fracB shifted right by shiftAmount;
  MOV     R1, R6                  @   exponent = expA;
  B       NumAdjusted             @ }
ExpIsSame:                        @ if (expA == expB) {
  MOV     R1, R6                  @   exponent = expA
NumAdjusted:                      @ }
  ADD     R0, R4, R5              @ newFrac = fracA + fracB;
  BL      fp_enc                  @ answer = return
  
  POP     {R4-R8,PC}              @ add any registers R4...R12 that you use


@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: fraction (signed fraction, including the 'hidden' bit, in 2's
@         complement form)
fp_frac:
  PUSH    {R4, LR}                  @ add any registers R4...R12 that you use
  
  MOV     R4, R0                    @ IEEE-754 number
  LDR     R2, =0xFF800000           @ 
  BIC     R0, R0, R2                @ Mask the exponent and sign bits.
  ORR     R0, R0, 0x800000          @ Sets hidden bit to 1
  LDR     R2, =0x7FFFFFFF           @ 
  BIC     R3, R4, R2                @ Finds the sign bit the IEEE-754 number
  CMP     R3, 0x80000000            @ if (signBit == 1)
  BNE     EndNegation               @ {
  NEG     R0, R0                    @   -(fraction);
EndNegation:                        @ }

  POP     {R4, PC}                  @ add any registers R4...R12 that you use


@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: exponent (signed integer using 2's complement)
fp_exp:
  PUSH    {LR}                      @ add any registers R4...R12 that you use
  
  LDR     R3, =0x807FFFFF
  BIC     R0, R0, R3                @ Mask the sign bit and fraction bits.
  MOV     R0, R0, ASR #23           @ Shift right by 23 bits.
  SUB     R0, R0, 0x7F              @ Subtract the fixed constant bias (127).

  POP     {PC}                      @ add any registers R4...R12 that you use


@ Parameters:
@   R0: fraction (in 2's complement form)
@   R1: exponent (in 2's complement form)
@
@ Return:
@   R0: IEEE-754 single precision floating point number
fp_enc:
  PUSH    {R4, LR}                      @ add any registers R4...R12 that you use
  
  MOV     R4, #0                    @ isNegative = false;
  CMP     R0, #0                    @ if (fraction < 0)
  BGE     NotNegative               @ {
  NEG     R0, R0                    @   -(fraction);
  MOV     R4, #1                    @   isNegative = true;
NotNegative:                        @ }
  CLZ     R2, R0                    @ Count number of leading zeros
  CMP     R2, #8                    @ if (leadingZeros < 8)
  BHS     IsHigher                  @ {
  RSB     R3, R2, #8                @   moveRight = 8 - leadingZeros;
  MOV     R0, R0, ASR R3            @   Shift right by value of moveRight;
  ADD     R1, R1, R3                @   exponent = exponent + moveRight;
  B       Normalised                @ }
IsHigher:                           @
  CMP     R2, #8                    @ if (leadingZeros > 8)
  BEQ     Normalised                @ {
  SUB     R3, R2, #8                @   moveLeft = leadingZeros - 8;
  MOV     R0, R0, LSL R3            @   Shift left by value of moveLeft;
  SUB     R1, R1, R3                @   Subtract moveLeft from the exponent;
Normalised:                         @ }
  CMP     R4, #1                    @ if (isNegative == true)
  BNE     AddedSignBit              @ {
  ADD     R0, R0, 0x80000000        @   signBit = 1;
AddedSignBit:                       @ }
  LDR     R3, =0x800000             @
  BIC     R0, R0, R3                @ Clear hidden bit
  ADD     R1, R1, 0x7F              @ Add fixed constant bias (127) to exponent
  MOV     R1, R1, LSL #23           @ Shift exponent left by 23 bits
  ADD     R0, R0, R1                @ Combine the fraction, exponent and sign bits

  POP     {R4, PC}                      @ add any registers R4...R12 that you use
.end