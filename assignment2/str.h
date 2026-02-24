/* str.h: Interface for the Str string handling module */
#ifndef STR_INCLUDED
#define STR_INCLUDED

#include <stddef.h>

/* Return the length of the string pcSrc without the termination character*/
size_t Str_getLength(const char *pcSrc);

/* Copies the pcSrc to pcDest with the termination character returns pcDest */
char *Str_copy(char *pcDest, const char *pcSrc);
 
/* Appends the pcSrc string to the pcDest string and returns pcDest */
char *Str_concat(char *pcDest, const char *pcSrc);

/* Compares the two inputs to see if pcS1 is lexicographically less than equal or greater than pcS2 returning a negative, 0, or positive value respectively */
int Str_compare(const char *pcS1, const char *pcS2);

/* Finds the first occurence of the string pcNeedle within the pcHaystack string. Returns a pointer to the start of the located string (or null if not found)*/
char *Str_search(const char *pcHaystack, const char *pcNeedle);


#endif
