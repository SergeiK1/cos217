/*--------------------------------------------------------------------*/
/* bigintaddoptopt.s                                                  */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

/* Constants */
.equ FALSE, 0
.equ TRUE, 1
.equ MAX_DIGITS, 32768

/* Struct Field Offsets */
.equ LLENGTH, 0
.equ AULDIGITS, 8

/* BigInt_add stack frame: saves x30, x19-x21, x25 */
.equ ADD_STACK_BYTECOUNT, 48
.equ ADD_X30,  0
.equ ADD_X19,  8
.equ ADD_X20, 16
.equ ADD_X21, 24
.equ ADD_X25, 32


/* Registers for BigInt_add */
OADDEND1   .req x19
OADDEND2   .req x20
OSUM       .req x21
LSUMLENGTH .req x25


/* -------------------------- */


    .section .text
    .global BigInt_add


// ----------------------------------------

BigInt_add:
    // Prolog
    sub     sp, sp, ADD_STACK_BYTECOUNT
    str     x30, [sp, ADD_X30]
    str     x19, [sp, ADD_X19]
    str     x20, [sp, ADD_X20]
    str     x21, [sp, ADD_X21]
    str     x25, [sp, ADD_X25]

    // Move parameters into callee-saved registers
    mov     OADDEND1, x0
    mov     OADDEND2, x1
    mov     OSUM,     x2


    // Inlined BigInt_larger:
    // if (lLength <= lLength2) goto else1
    // which sets lSumLength = lLength2 
    // otherwise set lSumLength = lLength1
    ldr     x0, [OADDEND1, LLENGTH]
    ldr     x1, [OADDEND2, LLENGTH]
    cmp     x0, x1
    ble     else1
    mov     LSUMLENGTH, x0
    b       endif1

else1:
    mov     LSUMLENGTH, x1

endif1:
    // if (oSum->lLength <= lSumLength) goto endifClear
    ldr     x1, [OSUM, LLENGTH]
    cmp     x1, LSUMLENGTH
    ble     endifClear

    // memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long))
    add     x0, OSUM, AULDIGITS
    mov     x1, 0

    // x2 = MAX_DIGITS * sizeof(unsigned long) = 32768 * 8
    mov     x2, MAX_DIGITS
    lsl     x2, x2, 3 // *8
    bl      memset

endifClear:

    // Set up pointers into the three digit arrays
    add     x9,  OADDEND1, AULDIGITS
    add     x10, OADDEND2, AULDIGITS
    add     x11, OSUM,     AULDIGITS

    // Loop count via lSumLength
    mov     x12, LSUMLENGTH

    // Initialize C condition flag to 0 (no carry)
    adds    xzr, xzr, xzr

    // Guard: if (lSumLength == 0) goto endforloop1
    cbz     x12, endforloop1

forloop1:
    // ulSum = oAddend1->aulDigits[lIndex]
    //       + oAddend2->aulDigits[lIndex] + C; update C
    ldr     x0, [x9],  8
    ldr     x1, [x10], 8
    adcs    x0, x0, x1

    // oSum->aulDigits[lIndex] = ulSum
    str     x0, [x11], 8

    // Decrement counter
    sub     x12, x12, 1

    // if (count != 0) goto forloop1
    cbnz    x12, forloop1

endforloop1:

    // if (C == 0) goto endifCarry3
    bcc     endifCarry3

    // if (lSumLength != MAX_DIGITS) goto endifFalse
    mov     x0, MAX_DIGITS
    cmp     LSUMLENGTH, x0
    bne     endifFalse

    // return FALSE
    mov     w0, FALSE
    ldr     x30, [sp, ADD_X30]
    ldr     x19, [sp, ADD_X19]
    ldr     x20, [sp, ADD_X20]
    ldr     x21, [sp, ADD_X21]
    ldr     x25, [sp, ADD_X25]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret

endifFalse:

    // oSum->aulDigits[lSumLength] = 1
    // After loop, x11 points to &oSum->aulDigits[lSumLength]
    mov     x1, 1
    str     x1, [x11]

    // lSumLength++
    add     LSUMLENGTH, LSUMLENGTH, 1

endifCarry3:

    // oSum->lLength = lSumLength
    str     LSUMLENGTH, [OSUM, LLENGTH]

    // return TRUE
    mov     w0, TRUE
    ldr     x30, [sp, ADD_X30]
    ldr     x19, [sp, ADD_X19]
    ldr     x20, [sp, ADD_X20]
    ldr     x21, [sp, ADD_X21]
    ldr     x25, [sp, ADD_X25]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret
