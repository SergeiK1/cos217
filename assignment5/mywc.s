/*--------------------------------------------------------------------*/
/* mywc.s                                                             */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                   */
/*--------------------------------------------------------------------*/

        .section .rodata
printStr:
        .string "%7ld %7ld %7ld\n"

/*--------------------------------------------------------------------*/

        .section .data
lLineCount:
        .quad 0

lWordCount:
        .quad 0

lCharCount:
        .quad 0

iChar:
        .word 0

iInWord:
        .word 0

/*--------------------------------------------------------------------*/

        .section .text
        .equ MAIN_STACK_BYTECOUNT, 16
        .global main

main:
        // Prolog
        sub     sp, sp, MAIN_STACK_BYTECOUNT
        str     x30, [sp]

whileloop:
        bl      getchar
        // store into x1 as iChar
        adr     x1, iChar
        str     w0, [x1]

        // if EOF, exit while loop
        cmp     w0, -1
        beq     endwhileloop

        // increment lCharCount
        adr     x1, lCharCount
        ldr     x2, [x1]
        add     x2, x2, 1
        str     x2, [x1]

ifspace:
        // check if current char is space
        adr     x1, iChar
        ldr     w0, [x1]
        bl      isspace

        // if not a space go to elsespace
        cmp     w0, 0
        beq     elsespace

ifInword:
        // check if current char is in word
        adr     x1, iInWord
        ldr     w2, [x1]

        // if not in word go to endifInword
        cmp     w2, 0
        beq endifInword

        // increment lWordCount
        adr     x2, lWordCount
        ldr     x3, [x2]
        add     x3, x3, 1
        str     x3, [x2]

        // set iInWord to FALSE
        mov     w2, 0
        str     w2, [x1]

endifInword:
        b       endifSpace

elsespace:
        // check if current char is not in word
        adr     x1, iInWord
        ldr     w2, [x1]

        // if in word go to endifSpace
        cmp     w2, 0
        bne     endifSpace

        // set iInWord to TRUE
        mov     w2, 1
        str     w2, [x1]

endifSpace:

ifnewline:
        // check if current char is a newline
        adr     x1, iChar
        ldr     w2, [x1]

        // if not newline go to endifnewline
        cmp     w2, 10
        bne endifnewline

        // increment lLineCount
        adr     x2, lLineCount
        ldr     x3, [x2]
        add     x3, x3, 1
        str     x3, [x2]

endifnewline:
        b       whileloop

endwhileloop:

ifInword2:
        // check if EOF reached while in word
        adr     x1, iInWord
        ldr     w2, [x1]

        // if not in word go to endifInword2
        cmp     w2, 0
        beq     endifInword2

        // increment lWordCount
        adr     x2, lWordCount
        ldr     x3, [x2]
        add     x3, x3, 1
        str     x3, [x2]

endifInword2:
        // print
        adr     x0, printStr

        adr     x1, lLineCount
        ldr     x1, [x1]

        adr     x2, lWordCount
        ldr     x2, [x2]

        adr     x3, lCharCount
        ldr     x3, [x3]

        bl printf

        // Epilog and return 0
        mov     w0, 0
        ldr     x30, [sp]
        add     sp, sp, MAIN_STACK_BYTECOUNT
        ret
