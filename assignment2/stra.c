/* stra.c: Array-based implementation */
#include "str.h"
#include <assert.h>

/* Retrun the length of the string without terminating character */
size_t Str_getLength(const char pcSrc[]) {
    size_t uLength = 0;
    assert(pcSrc != NULL);
    
    while (pcSrc[uLength] != '\0')
        uLength++;

    return uLength;
}



/* Copy the string pcSrc to pcDest with the termination character */
char *Str_copy(char pcDest[], const char pcSrc[]) {
    size_t uIndex = 0;

    assert(pcDest != NULL);
    assert(pcSrc != NULL);

    while (pcSrc[uIndex] != '\0'){
       pcDest[uIndex] = pcSrc[uIndex]; 
       uIndex++;
    }
    pcDest[uIndex] = '\0';

    return pcDest;
}



/* Add the string pcSrc to the end of pcDest */
char *Str_concat(char pcDest[], const char pcSrc[]) {

    size_t uDestlen;
    size_t uIndex = 0;

    assert(pcDest != NULL);
    assert(pcSrc != NULL);

    /* Calling my own function for length */
    uDestlen = Str_getLength(pcDest);

    while (pcSrc[uIndex] != '\0') {
        pcDest[uDestlen + uIndex] = pcSrc[uIndex];
        uIndex++;
    }
    pcDest[uDestlen + uIndex] = '\0';

    return pcDest;
}



/* Compare the two strings and return negative 0 or positive after a lexicographical comparisone */
int Str_compare(const char pcS1[], const char pcS2[]){
    size_t uIndex = 0;

    assert(pcS1 != NULL);
    assert(pcS2 != NULL);

    /* While loop skips equal values and ensures its non terminated */
    while((pcS1[uIndex] != '\0') && (pcS2[uIndex] != '\0') && (pcS1[uIndex] == pcS2[uIndex]))
        uIndex++;

    /* converts to char to literally subtracts their integer values but forces it to be unsigned to ensure they are equally numbered */
    return (int) ((unsigned char)pcS1[uIndex] - (unsigned char)pcS2[uIndex]);
}



/* Returns the pointer to the first occurence of the needle in the haystack (or NULL if it doesnt occur) */
char *Str_search(const char pcHaystack[], const char pcNeedle[]) {
    
    size_t uHay;
    size_t uNed;

    assert(pcHaystack != NULL);
    assert(pcNeedle != NULL);
    
   if (pcNeedle[0] == '\0')
       return (char *)pcHaystack;

   for (uHay = 0; pcHaystack[uHay] != '\0'; uHay++) {
       uNed = 0;
       while ((pcNeedle[uNed] != '\0') && (pcHaystack[uHay + uNed] != '\0') && (pcHaystack[uHay + uNed] == pcNeedle[uNed]))
           uNed++;

       if (pcNeedle[uNed] == '\0')
           return (char *)&pcHaystack[uHay];
   }

   /* If it doesnt exist */
   return NULL;
}

