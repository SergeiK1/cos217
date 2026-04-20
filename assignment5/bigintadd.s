/*--------------------------------------------------------------------*/
/* mywc.s                                                             */
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

