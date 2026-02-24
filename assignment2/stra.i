# 0 "stra.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "stra.c"

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
# 3 "stra.c" 2
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



# 4 "stra.c" 2



# 6 "stra.c"
size_t Str_getLength(const char pcSrc[]) {
    size_t uLength = 0;
    
# 8 "stra.c" 3 4
   ((
# 8 "stra.c"
   pcSrc != 
# 8 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 8 "stra.c"
   "pcSrc != NULL"
# 8 "stra.c" 3 4
   , "stra.c", 8, __extension__ __PRETTY_FUNCTION__))
# 8 "stra.c"
                        ;

    while (pcSrc[uLength] != '\0')
        uLength++;

    return uLength;
}




char *Str_copy(char pcDest[], const char pcSrc[]) {
    size_t uIndex = 0;

    
# 22 "stra.c" 3 4
   ((
# 22 "stra.c"
   pcDest != 
# 22 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 22 "stra.c"
   "pcDest != NULL"
# 22 "stra.c" 3 4
   , "stra.c", 22, __extension__ __PRETTY_FUNCTION__))
# 22 "stra.c"
                         ;
    
# 23 "stra.c" 3 4
   ((
# 23 "stra.c"
   pcSrc != 
# 23 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 23 "stra.c"
   "pcSrc != NULL"
# 23 "stra.c" 3 4
   , "stra.c", 23, __extension__ __PRETTY_FUNCTION__))
# 23 "stra.c"
                        ;

    while (pcSrc[uIndex] != '\0'){
       pcDest[uIndex] = pcSrc[uIndex];
       uIndex++;
    }
    pcDest[uIndex] = '\0';

    return pcDest;
}




char *Str_concat(char pcDest[], const char pcSrc[]) {

    size_t uDestlen;
    size_t uIndex = 0;

    
# 42 "stra.c" 3 4
   ((
# 42 "stra.c"
   pcDest != 
# 42 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 42 "stra.c"
   "pcDest != NULL"
# 42 "stra.c" 3 4
   , "stra.c", 42, __extension__ __PRETTY_FUNCTION__))
# 42 "stra.c"
                         ;
    
# 43 "stra.c" 3 4
   ((
# 43 "stra.c"
   pcSrc != 
# 43 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 43 "stra.c"
   "pcSrc != NULL"
# 43 "stra.c" 3 4
   , "stra.c", 43, __extension__ __PRETTY_FUNCTION__))
# 43 "stra.c"
                        ;


    uDestlen = Str_getLength(pcDest);

    while (pcSrc[uIndex] != '\0') {
        pcDest[uDestlen + uIndex] = pcSrc[uIndex];
        uIndex++;
    }
    pcDest[uDestlen + uIndex] = '\0';

    return pcDest;
}




int Str_compare(const char pcS1[], const char pcS2[]){
    size_t uIndex = 0;

    
# 63 "stra.c" 3 4
   ((
# 63 "stra.c"
   pcS1 != 
# 63 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 63 "stra.c"
   "pcS1 != NULL"
# 63 "stra.c" 3 4
   , "stra.c", 63, __extension__ __PRETTY_FUNCTION__))
# 63 "stra.c"
                       ;
    
# 64 "stra.c" 3 4
   ((
# 64 "stra.c"
   pcS2 != 
# 64 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 64 "stra.c"
   "pcS2 != NULL"
# 64 "stra.c" 3 4
   , "stra.c", 64, __extension__ __PRETTY_FUNCTION__))
# 64 "stra.c"
                       ;


    while((pcS1[uIndex] != '\0') && (pcS2[uIndex] != '\0') && (pcS1[uIndex] == pcS2[uIndex]))
        uIndex++;


    return (int) ((unsigned char)pcS1[uIndex] - (unsigned char)pcS2[uIndex]);
}




char *Str_search(const char pcHaystack[], const char pcNeedle[]) {

    size_t uHay;
    size_t uNed;

    
# 82 "stra.c" 3 4
   ((
# 82 "stra.c"
   pcHaystack != 
# 82 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 82 "stra.c"
   "pcHaystack != NULL"
# 82 "stra.c" 3 4
   , "stra.c", 82, __extension__ __PRETTY_FUNCTION__))
# 82 "stra.c"
                             ;
    
# 83 "stra.c" 3 4
   ((
# 83 "stra.c"
   pcNeedle != 
# 83 "stra.c" 3 4
   ((void *)0)) ? (void) (0) : __assert_fail (
# 83 "stra.c"
   "pcNeedle != NULL"
# 83 "stra.c" 3 4
   , "stra.c", 83, __extension__ __PRETTY_FUNCTION__))
# 83 "stra.c"
                           ;

   if (pcNeedle[0] == '\0')
       return (char *)pcHaystack;

   for (uHay = 0; pcHaystack[uHay] != '\0'; uHay++) {
       uNed = 0;
       while ((pcNeedle[uNed] != '\0') && (pcHaystack[uHay + uNed] != '\0') && (pcHaystack[uHay + uNed] == pcNeedle[uNed]))
           uNed++;

       if (pcNeedle[uNed] == '\0')
           return (char *)&pcHaystack[uHay];
   }


   return 
# 98 "stra.c" 3 4
         ((void *)0)
# 98 "stra.c"
             ;
}
