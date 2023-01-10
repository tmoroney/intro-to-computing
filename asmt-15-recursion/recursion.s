  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   quicksort
  .global   partition
  .global   swap

@ quicksort subroutine
@ Sort an array of words using Hoare's quicksort algorithm
@ https://en.wikipedia.org/wiki/Quicksort 
@
@ Parameters:
@   R0: Array start address
@   R1: lo index of portion of array to sort
@   R2: hi index of portion of array to sort
@
@ Return:
@   none
quicksort:
  PUSH    {LR}                  @ add any registers R4...R12 that you use

  CMP     R1, R2                    @   if (lo < hi)
  BGE     GreaterThan               @   {
  PUSH    {R0-R2}                   @
  BL      partition                 @     
  MOV     R3, R0                    @     p = partition(array, lo, hi);
  POP     {R0-R2}                   @
  PUSH    {R0-R2}                   @
  SUB     R2, R3, #1                @     p - 1;
  BL      quicksort                 @     quicksort(array, lo, p - 1);
  POP     {R0-R2}                   @
  PUSH    {R0-R2}                   @
  ADD     R1, R3, #1                @     p + 1;
  BL      quicksort                 @     quicksort(array, p + 1, hi);
  POP     {R0-R2}                   @   
GreaterThan:                        @   }

  POP     {PC}                  @ add any registers R4...R12 that you use


@ partition subroutine
@ Partition an array of words into two parts such that all elements before some
@   element in the array that is chosen as a 'pivot' are less than the pivot
@   and all elements after the pivot are greater than the pivot.
@
@ Based on Lomuto's partition scheme (https://en.wikipedia.org/wiki/Quicksort)
@
@ Parameters:
@   R0: array start address
@   R1: lo index of partition to sort
@   R2: hi index of partition to sort
@
@ Return:
@   R0: pivot - the index of the chosen pivot value
partition:
  PUSH    {R7-R10, LR}              @ add any registers R4...R12 that you use

  LDR     R7, [R0, R2, LSL #2]      @  pivot = array[hi];
  MOV     R8, R1                    @  i = lo;
  MOV     R9, R1                    @  j = lo;
While:                              @
  CMP     R9, R2                    @  while (j <= hi)
  BHI     EndWhile                  @  {
  LDR     R10, [R0, R9, LSL #2]     @    valueJ = array[j];
  CMP     R10, R7                   @    if (valueJ < pivot)
  BHS     MoreThanPivot             @    {
  PUSH    {R0-R2}                   @
  MOV     R1, R8                    @      param1 = i;
  MOV     R2, R9                    @      param2 = j;
  BL      swap                      @      swap(array, i, j);
  POP     {R0-R2}                   @
  ADD     R8, R8, #1                @      i = i + 1;
MoreThanPivot:                      @    }
  ADD     R9, R9, #1                @
  B       While                     @  }
EndWhile:                           @
  MOV     R1, R8                    @  param1 = i;
  BL      swap                      @  swap(array, i, hi);
  MOV     R0, R8                    @  return i;

  POP     {R7-R10, PC}              @ add any registers R4...R12 that you use



@ swap subroutine
@ Swap the elements at two specified indices in an array of words.
@
@ Parameters:
@   R0: array - start address of an array of words
@   R1: a - index of first element to be swapped
@   R2: b - index of second element to be swapped
@
@ Return:
@   none
swap:
  PUSH    {R4, R5, LR}

  LDR     R4, [R0, R1, LSL #2]      @  elemA = array[indexA];
  LDR     R5, [R0, R2, LSL #2]      @  elemB = array[indexB];
  STR     R4, [R0, R2, LSL #2]      @  array[indexA] = elemB;
  STR     R5, [R0, R1, LSL #2]      @  array[indexB] = elemA;

  POP     {R4, R5, PC}


.end