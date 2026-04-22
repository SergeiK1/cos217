/*--------------------------------------------------------------------*/
/* bigintadd.s                                                             */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                   */
/*--------------------------------------------------------------------*/


/* Constants */
.equ FALSE, 0
.equ TRUE, 1
.equ MAX_DIGITS, 32768

/* Struct Field Offsets */
.equ LLENGTH, 0
.equ AULDIGITS, 8

/* BigInt_larger stack frame */
.equ LARGER_STACK_BYTECOUNT, 32
.equ LLENGTH1, 8
.equ LLENGTH2, 16 
.equ LLARGER, 24

/* BigInt_add stack frame */
.equ ADD_STACK_BYTECOUNT, 64
.equ OADDEND1, 8 
.equ OADDEND2, 16 
.equ OSUM, 24 
.equ ULCARRY, 32 
.equ ULSUM, 40 
.equ LINDEX, 48 
.equ LSUMLENGTH, 56 


/* -------------------------- */


    .section .text
    .global BigInt_add


// ----------------------------------------

BigInt_larger:
    // Prolog
    sub     sp, sp, LARGER_STACK_BYTECOUNT
    str     x30, [sp]

    // store parameters to stack
    str     x0, [sp, LLENGTH1]
    str     x1, [sp, LLENGTH2]

    // Compare the two parameters
    cmp     x0, x1
    ble     else1

    // if lLength1 is greater than lLength 2
    str     x0, [sp, LLARGER]
    b       endif1

else1:
    // if lLength1 is less than or equal to lLength 2
    str     x1, [sp, LLARGER]

endif1:
    // epilog
    ldr     x0, [sp, LLARGER]
    ldr     x30, [sp]
    add     sp, sp, LARGER_STACK_BYTECOUNT
    ret


// ----------------------------------------

BigInt_add: 
    // Prolog
    sub     sp, sp, ADD_STACK_BYTECOUNT
    str     x30, [sp]
    str     x0, [sp, OADDEND1]
    str     x1, [sp, OADDEND2]
    str     x2, [sp, OSUM]



    // Run the BigInt_larger function
    ldr     x0, [sp, OADDEND1] // load pointer
    ldr     x0, [x0, LLENGTH] // load the value 

    ldr     x1, [sp, OADDEND2] 
    ldr     x1, [x1, LLENGTH]

    bl      BigInt_larger


    // Store returning value 
    str     x0, [sp, LSUMLENGTH]


    // oSum Length if-statement
    ldr     x1, [sp, OSUM]
    ldr     x1, [x1, LLENGTH]

    cmp     x1, x0
    ble     endifClear


    // x0 = oSum->aulDigits 
    ldr     x0, [sp, OSUM]
    add     x0, x0, AULDIGITS

    // x1 = 0
    mov     x1, 0

    // x2 = MAX_DIGITS * sizeof(unsigned long) = 32768 * 8
    mov     x2, MAX_DIGITS
    lsl     x2, x2, 3 // *8 
    
    bl memset // already exists

endifClear:

    // ulCarry = 0
    mov     x0, 0
    str     x0, [sp, ULCARRY]

    // ulIndex = 0
    mov     x0, 0
    str     x0, [sp, LINDEX]

forloop1:

    // if (lIndex >= lSumLenght) goto endforloop1
    ldr     x0, [sp, LINDEX]
    ldr     x1, [sp, LSUMLENGTH]
    cmp     x0, x1
    bge     endforloop1

    // ulSum = ulCarry
    ldr     x0, [sp, ULCARRY]
    str     x0, [sp, ULSUM]

    mov     x0, 0
    str     x0, [sp, ULCARRY]

    // ulSum += oAdden1->aulDigits[lIndex];
    ldr     x0, [sp, OADDEND1]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LINDEX]
    ldr     x2, [x0, x1, lsl 3]
    
    ldr     x0, [sp, ULSUM]
    add     x0, x0, x2
    str     x0, [sp, ULSUM]

    // if (ulSum >= oAdden1->aulDiggits[lIndex]) 
    // goto endifCarry1;
    ldr     x0, [sp, OADDEND1]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LINDEX]
    ldr     x2, [x0, x1, lsl 3]

    ldr     x0, [sp, ULSUM]
    cmp     x0, x2
    bhs     endifCarry1

    // ulCarry = 1;
    mov     x0, 1
    str     x0, [sp, ULCARRY]

endifCarry1:
    // ulSum += oAddend2->aulDigits[lIndex]
    ldr     x0, [sp, OADDEND2]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LINDEX]
    ldr     x2, [x0, x1, lsl 3]

    ldr     x0, [sp, ULSUM]
    add     x0, x0, x2
    str     x0, [sp, ULSUM]

     // if (ulSum >= oAddend2->aulDigits[lIndex]) goto endifCarry2
    ldr     x0, [sp, OADDEND2]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LINDEX]
    ldr     x2, [x0, x1, lsl 3]

    ldr     x0, [sp, ULSUM]
    cmp     x0, x2
    bhs     endifCarry2

    // ulCarry = 1
    mov     x0, 1
    str     x0, [sp, ULCARRY]

endifCarry2:

    // oSum->aulDigits[lIndex] = ulSum
    ldr     x0, [sp, OSUM]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LINDEX]
    ldr     x2, [sp, ULSUM]
    str     x2, [x0, x1, lsl 3]

    // lIndex++
    ldr     x0, [sp, LINDEX]
    add     x0, x0, 1
    str     x0, [sp, LINDEX]

    b       forloop1

endforloop1:

    // if (ulCarry != 1) goto endifCarry3
    ldr     x0, [sp, ULCARRY]
    cmp     x0, 1
    bne     endifCarry3

    // if (lSumLength != MAX_DIGITS) goto endifFalse
    ldr     x0, [sp, LSUMLENGTH]
    mov     x1, MAX_DIGITS
    cmp     x0, x1
    bne     endifFalse

    // return FALSE
    mov     w0, FALSE
    ldr     x30, [sp]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret

endifFalse:

    // oSum->aulDigits[lSumLength] = 1
    ldr     x0, [sp, OSUM]
    add     x0, x0, AULDIGITS
    ldr     x1, [sp, LSUMLENGTH]
    mov     x2, 1
    str     x2, [x0, x1, lsl 3]

    // lSumLength++
    ldr     x0, [sp, LSUMLENGTH]
    add     x0, x0, 1
    str     x0, [sp, LSUMLENGTH]

endifCarry3:

    // oSum->lLength = lSumLength
    ldr     x0, [sp, OSUM]
    ldr     x1, [sp, LSUMLENGTH]
    str     x1, [x0, LLENGTH]

    // return TRUE
    mov     w0, TRUE
    ldr     x30, [sp]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret

    

    
    
    

