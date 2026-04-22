/*--------------------------------------------------------------------*/
/* bigintaddopt.s                                                     */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

/* Constants */
.equ FALSE, 0
.equ TRUE, 1
.equ MAX_DIGITS, 32768

/* Struct Field Offsets */
.equ LLENGTH, 0
.equ AULDIGITS, 8

/* BigInt_larger stack frame: saves x30, x19-21 */
.equ LARGER_STACK_BYTECOUNT, 32
.equ LARGER_X30,  0
.equ LARGER_X19,  8
.equ LARGER_X20, 16
.equ LARGER_X21, 24

/* BigInt_add stack frame: save x30, x19-25 */
.equ ADD_STACK_BYTECOUNT, 64
.equ ADD_X30,  0
.equ ADD_X19,  8
.equ ADD_X20, 16
.equ ADD_X21, 24
.equ ADD_X22, 32
.equ ADD_X23, 40
.equ ADD_X24, 48
.equ ADD_X25, 56


/* Registers for BigInt_larger */
LLENGTH1 .req x19
LLENGTH2 .req x20
LLARGER  .req x21

/* Registers for BigInt_add */
OADDEND1   .req x19
OADDEND2   .req x20
OSUM       .req x21
ULCARRY    .req x22
ULSUM      .req x23
LINDEX     .req x24
LSUMLENGTH .req x25


/* -------------------------- */


    .section .text
    .global BigInt_add


// ----------------------------------------

BigInt_larger:
    // Prolog
    sub     sp, sp, LARGER_STACK_BYTECOUNT
    str     x30, [sp, LARGER_X30]
    str     x19, [sp, LARGER_X19]
    str     x20, [sp, LARGER_X20]
    str     x21, [sp, LARGER_X21]

    // Move parameters into callee-saved registers
    mov     LLENGTH1, x0
    mov     LLENGTH2, x1

    // Compare the two parameters
    cmp     LLENGTH1, LLENGTH2
    ble     else1

    // if lLength1 is greater than lLength2
    mov     LLARGER, LLENGTH1
    b       endif1

else1:
    // if lLength1 is less than or equal to lLength2
    mov     LLARGER, LLENGTH2

endif1:
    // Epilog
    mov     x0, LLARGER
    ldr     x30, [sp, LARGER_X30]
    ldr     x19, [sp, LARGER_X19]
    ldr     x20, [sp, LARGER_X20]
    ldr     x21, [sp, LARGER_X21]
    add     sp, sp, LARGER_STACK_BYTECOUNT
    ret


// ----------------------------------------

BigInt_add: 
    // Prolog
    sub     sp, sp, ADD_STACK_BYTECOUNT
    str     x30, [sp, ADD_X30]
    str     x19, [sp, ADD_X19]
    str     x20, [sp, ADD_X20]
    str     x21, [sp, ADD_X21]
    str     x22, [sp, ADD_X22]
    str     x23, [sp, ADD_X23]
    str     x24, [sp, ADD_X24]
    str     x25, [sp, ADD_X25]

    // Move parameters into callee-saved registers
    mov     OADDEND1, x0
    mov     OADDEND2, x1
    mov     OSUM,     x2


    // Run the BigInt_larger function
    ldr     x0, [OADDEND1, LLENGTH]
    ldr     x1, [OADDEND2, LLENGTH]
    bl      BigInt_larger

    // lSumLength = BigInt_larger()
    mov     LSUMLENGTH, x0


    // oSum Length if-statement
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

    // ulCarry = 0
    mov     ULCARRY, 0

    // lIndex = 0
    mov     LINDEX, 0

forloop1:

    // if (lIndex >= lSumLength) goto endforloop1
    cmp     LINDEX, LSUMLENGTH
    bge     endforloop1

    // ulSum = ulCarry; ulCarry = 0
    mov     ULSUM, ULCARRY
    mov     ULCARRY, 0

    // ulSum += oAddend1->aulDigits[lIndex]
    add     x0, OADDEND1, AULDIGITS
    ldr     x1, [x0, LINDEX, lsl 3]
    add     ULSUM, ULSUM, x1

    // if (ulSum >= oAddend1->aulDigits[lIndex]) goto endifCarry1
    cmp     ULSUM, x1
    bhs     endifCarry1

    // ulCarry = 1
    mov     ULCARRY, 1

endifCarry1:
    // ulSum += oAddend2->aulDigits[lIndex]
    add     x0, OADDEND2, AULDIGITS
    ldr     x1, [x0, LINDEX, lsl 3]
    add     ULSUM, ULSUM, x1

    // if (ulSum >= oAddend2->aulDigits[lIndex]) goto endifCarry2
    cmp     ULSUM, x1
    bhs     endifCarry2

    // ulCarry = 1
    mov     ULCARRY, 1

endifCarry2:

    // oSum->aulDigits[lIndex] = ulSum
    add     x0, OSUM, AULDIGITS
    str     ULSUM, [x0, LINDEX, lsl 3]

    // lIndex++
    add     LINDEX, LINDEX, 1

    b       forloop1

endforloop1:

    // if (ulCarry != 1) goto endifCarry3
    cmp     ULCARRY, 1
    bne     endifCarry3

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
    ldr     x22, [sp, ADD_X22]
    ldr     x23, [sp, ADD_X23]
    ldr     x24, [sp, ADD_X24]
    ldr     x25, [sp, ADD_X25]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret

endifFalse:

    // oSum->aulDigits[lSumLength] = 1
    add     x0, OSUM, AULDIGITS
    mov     x1, 1
    str     x1, [x0, LSUMLENGTH, lsl 3]

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
    ldr     x22, [sp, ADD_X22]
    ldr     x23, [sp, ADD_X23]
    ldr     x24, [sp, ADD_X24]
    ldr     x25, [sp, ADD_X25]
    add     sp, sp, ADD_STACK_BYTECOUNT
    ret
