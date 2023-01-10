  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global  get9x9
  .global  set9x9
  .global  average9x9
  .global  blur9x9


@ get9x9 subroutine
@ Retrieve the element at row r, column c of a 9x9 2D array
@   of word-size values stored using row-major ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@
@ Return:
@   R0: element at row r, column c
get9x9:
  PUSH    {R9, LR}                 @ add any registers R4...R12 that you use
  
  MOV R9, #9
  MUL R3, R1, R9                   @ index = row * row_size;
  ADD R3, R3, R2                   @ index = index + col;
  LDR R0, [R0, R3, LSL #2]         @ elem = array[r][c];

  POP     {R9, PC}                 @ add any registers R4...R12 that you use



@ set9x9 subroutine
@ Set the value of the element at row r, column c of a 9x9
@   2D array of word-size values stored using row-major
@   ordering.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: value - new word-size value for array[r][c]
@
@ Return:
@   none
set9x9:
  PUSH    {R4, R9, LR}             @ add any registers R4...R12 that you use
  
  MOV R9, #9
  MUL R4, R1, R9                   @ index = row * row_size;
  ADD R4, R4, R2                   @ index = index + col;
  STR R3, [R0, R4, LSL #2]         @ array[r][c] = value; 

  POP     {R4, R9, PC}             @ add any registers R4...R12 that you use



@ average9x9 subroutine
@ Calculate the average value of the elements up to a distance of
@   n rows and n columns from the element at row r, column c in
@   a 9x9 2D array of word-size values. The average should include
@   the element at row r, column c.
@
@ Parameters:
@   R0: address - array start address
@   R1: r - row number
@   R2: c - column number
@   R3: n - element radius
@
@ Return:
@   R0: average value of elements
average9x9:
  PUSH    {R4, R5, R6, R7, R8, R9, R10, LR}      @ add any registers R4...R12 that you use
  
  MOV     R4, #0                   @ count = 0;
  MOV     R7, #0                   @ total = 0;
  MOV     R9, #9                   @ row_size = 9;
  ADD     R5, R2, R3               @ lastCol = c + n;
  ADD     R6, R1, R3               @ lastRow = r + n;
  SUB     R1, R1, R3               @ r = r - n;
  SUB     R2, R2, R3               @ c = c - n;
ColOutsideArray:
  MOV     R10, R2                  @ firstCol = c;
  CMP     R2, #0                   @ while (c < 0)
  BGE     RowOutsideArray          @ {
  ADD     R2, R2, #1               @   c = c + 1;
  B       ColOutsideArray          @ }

RowOutsideArray:
  CMP     R1, #0                   @ while (r < 0)
  BGE     While                    @ {
  ADD     R1, R1, #1               @   c = c + 1;
  B       RowOutsideArray          @ }

While:
  CMP     R1, R6                   @ while (row <= lastRow && row < 9)
  BHI     EndWhile                 @ {
  CMP     R1, R9                   @
  BHS     EndWhile                 @
  MOV     R2, R10                  @   c = firstCol;
NextCol:                           @
  CMP     R2, R5                   @   while (col <= lastCol && col < 9)
  BHI     EndOfRow                 @   {
  CMP     R2, R9                   @
  BHS     EndOfRow                 @
  MUL     R3, R1, R9               @     index = r * row_size;
  ADD     R3, R3, R2               @     index = index + c;
  LDR     R8, [R0, R3, LSL #2]     @     elem = array[r][c];
  ADD     R4, R4, #1               @     count++;
  ADD     R7, R7, R8               @     total = total + elem;
  ADD     R2, R2, #1               @     c = c + 1;
  B       NextCol                  @   }
EndOfRow:
  ADD     R1, R1, #1               @   r = r + 1;
  B       While                    @ }
EndWhile:
  UDIV    R0, R7, R4               @ average = total / numOfElems;

  POP     {R4, R5, R6, R7, R8, R9, R10, PC}      @ add any registers R4...R12 that you use



@ blur9x9 subroutine
@ Create a new 9x9 2D array in memory where each element of the new
@ array is the average value the elements, up to a distance of n
@ rows and n columns, surrounding the corresponding element in an
@ original array, also stored in memory.
@
@ Parameters:
@   R0: addressA - start address of original array
@   R1: addressB - start address of new array
@   R2: n - radius
@
@ Return:
@   none
blur9x9:
  PUSH    {R4, R5, R6, R7, R8, LR}         @ add any registers R4...R12 that you use

  MOV     R4, R0                   @ addressA
  MOV     R5, R1                   @ addressB
  MOV     R6, R2                   @ n (radius)
  MOV     R7, #0                   @ r = 0;
SetToAverage:
  MOV     R8, #0                   @ c = 0;
  CMP     R7, #9                   @ while (r < 9)
  BHS     EndSetAverage            @ {
ChangeCol:                         @
  CMP     R8, #9                   @   while (c < 9)
  BHS     LastCol                  @   {
  MOV     R0, R4                   @     startAddress = addressA;
  MOV     R1, R7                   @     row = r;
  MOV     R2, R8                   @     col = c;
  MOV     R3, R6                   @     radius = n;
  BL      average9x9               @     
  MOV     R3, R0                   @     newValue = return;
  MOV     R0, R5                   @     startAddress = addressB;
  MOV     R1, R7                   @     row = r;
  MOV     R2, R8                   @     col = c;
  BL      set9x9                   @
  ADD     R8, R8, #1               @     c = c + 1; 
  B       ChangeCol                @   }
LastCol:                           @
  ADD     R7, R7, #1               @   r = r + 1;
  B       SetToAverage             @
EndSetAverage:                     @ }

  POP     {R4, R5, R6, R7, R8, PC}         @ add any registers R4...R12 that you use

.end