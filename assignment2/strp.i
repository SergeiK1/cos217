# 0 "strp.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "strp.c"

# 1 "str.h" 1




# 1 "/usr/lib/gcc/aarch64-redhat-linux/11/include/stddef.h" 1 3 4
# 143 "/usr/lib/gcc/aarch64-redhat-linux/11/include/stddef.h" 3 4

# 143 "/usr/lib/gcc/aarch64-redhat-linux/11/include/stddef.h" 3 4
typedef long int ptrdiff_t;
# 209 "/usr/lib/gcc/aarch64-redhat-linux/11/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 321 "/usr/lib/gcc/aarch64-redhat-linux/11/include/stddef.h" 3 4
typedef unsigned int wchar_t;
# 6 "str.h" 2



# 8 "str.h"
size_t Str_getLength(const char *pcSrc);


char *Str_copy(char *pcDest, const char *pcSrc);


char *Str_concat(char *pcDest, const char *pcSrc);


int Str_compare(const char *pcS1, const char *pcS2);


char *Str_search(const char *pcHaystack, const char *pcNeedle);
# 3 "strp.c" 2
# 1 "/usr/include/assert.h" 1 3 4
# 35 "/usr/include/assert.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 392 "/usr/include/features.h" 3 4
# 1 "/usr/include/features-time64.h" 1 3 4
# 20 "/usr/include/features-time64.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 21 "/usr/include/features-time64.h" 2 3 4
# 1 "/usr/include/bits/timesize.h" 1 3 4
# 19 "/usr/include/bits/timesize.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 20 "/usr/include/bits/timesize.h" 2 3 4
# 22 "/usr/include/features-time64.h" 2 3 4
# 393 "/usr/include/features.h" 2 3 4
# 490 "/usr/include/features.h" 3 4
# 1 "/usr/include/sys/cdefs.h" 1 3 4
# 551 "/usr/include/sys/cdefs.h" 3 4
# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 552 "/usr/include/sys/cdefs.h" 2 3 4
# 1 "/usr/include/bits/long-double.h" 1 3 4
# 553 "/usr/include/sys/cdefs.h" 2 3 4
# 491 "/usr/include/features.h" 2 3 4
# 514 "/usr/include/features.h" 3 4
# 1 "/usr/include/gnu/stubs.h" 1 3 4




# 1 "/usr/include/bits/wordsize.h" 1 3 4
# 6 "/usr/include/gnu/stubs.h" 2 3 4


# 1 "/usr/include/gnu/stubs-lp64.h" 1 3 4
# 9 "/usr/include/gnu/stubs.h" 2 3 4
# 515 "/usr/include/features.h" 2 3 4
# 36 "/usr/include/assert.h" 2 3 4
# 64 "/usr/include/assert.h" 3 4




# 67 "/usr/include/assert.h" 3 4
extern void __assert_fail (const char *__assertion, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));


extern void __assert_perror_fail (int __errnum, const char *__file,
      unsigned int __line, const char *__function)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));




extern void __assert (const char *__assertion, const char *__file, int __line)
     __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));



# 4 "strp.c" 2



# 6 "strp.c"
size_t Str_getLength(const char *pcSrc) {

    const char *pc;
    size_t uLength = 0;

    
# 11 "strp.c" 3 4
   ((
# 11 "strp.c"
   pcSrc != 
# 11 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 11 "strp.c"
   "pcSrc != NULL"
# 11 "strp.c" 3 4
   , "strp.c", 11, __extension__ __PRETTY_FUNCTION__))
# 11 "strp.c"
                        ;

    pc = pcSrc;
    while (*pc != '\0') {
        uLength++;
        pc++;
    }

    return uLength;
}




char *Str_copy(char *pcDest, const char *pcSrc) {

    char *pcDestStart;

    
# 29 "strp.c" 3 4
   ((
# 29 "strp.c"
   pcDest != 
# 29 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 29 "strp.c"
   "pcDest != NULL"
# 29 "strp.c" 3 4
   , "strp.c", 29, __extension__ __PRETTY_FUNCTION__))
# 29 "strp.c"
                         ;
    
# 30 "strp.c" 3 4
   ((
# 30 "strp.c"
   pcSrc != 
# 30 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 30 "strp.c"
   "pcSrc != NULL"
# 30 "strp.c" 3 4
   , "strp.c", 30, __extension__ __PRETTY_FUNCTION__))
# 30 "strp.c"
                        ;

    pcDestStart = pcDest;

    while (*pcSrc != '\0') {
        *pcDest = *pcSrc;
        pcDest++;
        pcSrc++;
    }
    *pcDest = '\0';

    return pcDestStart;
}



char *Str_concat(char *pcDest, const char *pcSrc) {

    char *pcDestStart;

    
# 50 "strp.c" 3 4
   ((
# 50 "strp.c"
   pcDest != 
# 50 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 50 "strp.c"
   "pcDest != NULL"
# 50 "strp.c" 3 4
   , "strp.c", 50, __extension__ __PRETTY_FUNCTION__))
# 50 "strp.c"
                         ;
    
# 51 "strp.c" 3 4
   ((
# 51 "strp.c"
   pcSrc != 
# 51 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 51 "strp.c"
   "pcSrc != NULL"
# 51 "strp.c" 3 4
   , "strp.c", 51, __extension__ __PRETTY_FUNCTION__))
# 51 "strp.c"
                        ;

    pcDestStart = pcDest;


    while (*pcDest != '\0')
        pcDest++;

    while (*pcSrc != '\0') {
        *pcDest = *pcSrc;
        pcDest++;
        pcSrc++;
    }
    *pcDest = '\0';

    return pcDestStart;
}




int Str_compare(const char *pcS1, const char *pcS2) {

    
# 74 "strp.c" 3 4
   ((
# 74 "strp.c"
   pcS1 != 
# 74 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 74 "strp.c"
   "pcS1 != NULL"
# 74 "strp.c" 3 4
   , "strp.c", 74, __extension__ __PRETTY_FUNCTION__))
# 74 "strp.c"
                       ;
    
# 75 "strp.c" 3 4
   ((
# 75 "strp.c"
   pcS2 != 
# 75 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 75 "strp.c"
   "pcS2 != NULL"
# 75 "strp.c" 3 4
   , "strp.c", 75, __extension__ __PRETTY_FUNCTION__))
# 75 "strp.c"
                       ;

    while ((*pcS1 != '\0') && (*pcS2 != '\0') && (*pcS1 == *pcS2)) {
        pcS1++;
        pcS2++;
    }

    return (int)((unsigned char)*pcS1 - (unsigned char)*pcS2);
}



char *Str_search(const char *pcHaystack, const char *pcNeedle) {

    const char *pcHaystackStart;
    const char *pcHaystackScan;
    const char *pcNeedleScan;

    
# 93 "strp.c" 3 4
   ((
# 93 "strp.c"
   pcHaystack != 
# 93 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 93 "strp.c"
   "pcHaystack != NULL"
# 93 "strp.c" 3 4
   , "strp.c", 93, __extension__ __PRETTY_FUNCTION__))
# 93 "strp.c"
                             ;
    
# 94 "strp.c" 3 4
   ((
# 94 "strp.c"
   pcNeedle != 
# 94 "strp.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 94 "strp.c"
   "pcNeedle != NULL"
# 94 "strp.c" 3 4
   , "strp.c", 94, __extension__ __PRETTY_FUNCTION__))
# 94 "strp.c"
                           ;

    if (*pcNeedle == '\0')
        return (char *)pcHaystack;

    pcHaystackStart = pcHaystack;

    while(*pcHaystackStart != '\0') {
        pcHaystackScan = pcHaystackStart;
        pcNeedleScan = pcNeedle;

        while ((*pcNeedleScan != '\0') && (*pcHaystackScan != '\0') && (*pcHaystackScan == *pcNeedleScan)) {
            pcHaystackScan++;
            pcNeedleScan++;
        }

        if (*pcNeedleScan == '\0')
            return (char *)pcHaystackStart;

        pcHaystackStart++;
    }

    return 
# 116 "strp.c" 3 4
          ((void *)0)
# 116 "strp.c"
              ;
}
