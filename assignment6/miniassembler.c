/*--------------------------------------------------------------------*/
/* miniassembler.c                                                    */
/* Author: Joshua (Kimyung) Song, Sergei Kudriavtcev                  */
/*--------------------------------------------------------------------*/

#include "miniassembler.h"
#include <assert.h>
#include <stddef.h>

/*--------------------------------------------------------------------*/
/* Modify *puiDest in place,
   setting uiNumBits starting at uiDestStartBit (where 0 indicates
   the least significant bit) with bits taken from uiSrc,
   starting at uiSrcStartBit.
   uiSrcStartBit indicates the rightmost bit in the field.
   setField sets the appropriate bits in *puiDest to 1.
   setField never unsets any bits in *puiDest.                        */
static void setField(unsigned int uiSrc, unsigned int uiSrcStartBit,
                     unsigned int *puiDest, unsigned int uiDestStartBit,
                     unsigned int uiNumBits)
{
   /* Your code here */
   unsigned int uiMask;
   unsigned int uiField;

   if (uiNumBits == 32) { /* take all bits */
      uiMask = 0xffffffff;
   } else { /* shift by uiNumBits and subtract 1 */
      uiMask = (1 << uiNumBits) - 1;
   }

   uiField = (uiSrc >> uiSrcStartBit) & uiMask; /* shift and mask source */
   uiField = uiField << uiDestStartBit; /* shift field to destination */

   *puiDest = *puiDest | uiField; /* set bits in destination to 1 */
}

/*--------------------------------------------------------------------*/

unsigned int MiniAssembler_mov(unsigned int uiReg, int iImmed)
{
   /* Your code here */
   unsigned int uiInstr;
   unsigned int uiImmed;

   uiInstr = 0x52800000; /* 10100101 */
   uiImmed = (unsigned int)iImmed;

   setField(uiImmed, 0, &uiInstr, 5, 16);
   setField(uiReg, 0, &uiInstr, 0, 5);

   return uiInstr;
}

/*--------------------------------------------------------------------*/

unsigned int MiniAssembler_adr(unsigned int uiReg, unsigned long ulAddr,
   unsigned long ulAddrOfThisInstr)
{
   unsigned int uiInstr;
   unsigned int uiDisp;

   /* Base Instruction Code */
   uiInstr = 0x10000000;

   /* register to be inserted in instruction */
   setField(uiReg, 0, &uiInstr, 0, 5);

   /* displacement to be split into immlo and immhi and inserted */
   uiDisp = (unsigned int)(ulAddr - ulAddrOfThisInstr);

   setField(uiDisp, 0, &uiInstr, 29, 2);
   setField(uiDisp, 2, &uiInstr, 5, 19);

   return uiInstr;
}

/*--------------------------------------------------------------------*/

unsigned int MiniAssembler_strb(unsigned int uiFromReg,
   unsigned int uiToReg)
{
   /* Your code here */
   unsigned int uiInstr;

   uiInstr = 0x39000000; /* 00111001 */

   setField(uiFromReg, 0, &uiInstr, 0, 5);
   setField(uiToReg, 0, &uiInstr, 5, 5);

   return uiInstr;
}

/*--------------------------------------------------------------------*/

unsigned int MiniAssembler_b(unsigned long ulAddr,
   unsigned long ulAddrOfThisInstr)
{
   /* Your code here */
   unsigned int uiInstr;
   unsigned int uiDisp;

   uiInstr = 0x14000000; /* 00010100 */
   uiDisp = (unsigned int)((ulAddr - ulAddrOfThisInstr) >> 2);

   setField(uiDisp, 0, &uiInstr, 0, 26);

   return uiInstr;
}

/*--------------------------------------------------------------------*/

unsigned int MiniAssembler_bl(unsigned long ulAddr,
   unsigned long ulAddrOfThisInstr) {
      unsigned int uiInstr;
      unsigned int uiDisp;

      uiInstr = 0x94000000; /* 10010100 */
      uiDisp = (unsigned int)((ulAddr - ulAddrOfThisInstr) >> 2);

      setField(uiDisp, 0, &uiInstr, 0, 26);

      return uiInstr;
}