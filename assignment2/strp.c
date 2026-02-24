/* strp.c: Pointer based implementation of the Str module */
#include "str.h"
#include <assert.h>

/* Retrun the length of the string pcSrc, without terminating character */
size_t Str_getLength(const char *pcSrc) {

    const char *pc;
    size_t uLength = 0;

    assert(pcSrc != NULL);

    pc = pcSrc;
    while (*pc != '\0') {
        uLength++;
        pc++;
    }

    return uLength;
}



/* Copy string pcSrc to pcDest with the terminating character */
char *Str_copy(char *pcDest, const char *pcSrc) {

    char *pcDestStart;

    assert(pcDest != NULL);
    assert(pcSrc != NULL);

    pcDestStart = pcDest;

    while (*pcSrc != '\0') {
        *pcDest = *pcSrc;
        pcDest++;
        pcSrc++; 
    }
    *pcDest = '\0';

    return pcDestStart;
}


/* add pcSrc to the end of pcDest  */
char *Str_concat(char *pcDest, const char *pcSrc) {

    char *pcDestStart;
    
    assert(pcDest != NULL);
    assert(pcSrc != NULL);

    pcDestStart = pcDest;

    /* points to the end of pcDest */
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



/* Compare pcS1 and pcS2 lexicographically returning negative 0 or positive */
int Str_compare(const char *pcS1, const char *pcS2) {

    assert(pcS1 != NULL);
    assert(pcS2 != NULL);

    while ((*pcS1 != '\0') && (*pcS2 != '\0') && (*pcS1 == *pcS2)) {
        pcS1++;
        pcS2++;
    }

    return (int)((unsigned char)*pcS1 - (unsigned char)*pcS2);
}


/* Return the pointer to the first occurence of the pcNeedle in pcHaystack (or if doesnt exist then null) */
char *Str_search(const char *pcHaystack, const char *pcNeedle) {

    const char *pcHaystackStart;
    const char *pcHaystackScan;
    const char *pcNeedleScan;

    assert(pcHaystack != NULL);
    assert(pcNeedle != NULL);

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

    return NULL;
}



