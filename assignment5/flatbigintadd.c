// skip asserts

// lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength)
lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength);

// if (oSum->lLength <= lSumLength) goto endifClear
if (oSum->lLength <= lSumLength) goto endifClear;
    memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
endifClear:

// ulCarry = 0
ulCarry = 0;
// lIndex = 0
lIndex = 0;
forloop1:
    if (lIndex >= lSumLength) goto endforloop1;
    ulSum = ulCarry;
    ulCarry = 0;

    ulSum += oAddend1->aulDigits[lIndex];
    if (ulSum >= oAddend1->aulDigits[lIndex]) goto endifCarry1;
        ulCarry = 1;
endifCarry1:

    ulSum += oAddend2->aulDigits[lIndex];
    if (ulSum >= oAddend2->aulDigits[lIndex]) goto endifCarry2;
        ulCarry = 1;
endifCarry2:

    oSum->aulDigits[lIndex] = ulSum;
    lIndex++;
    goto forloop1;
endforloop1:

if (ulCarry != 1) goto endifCarry3;
    if (lSumLength != MAX_DIGITS) goto endifFalse;
        return FALSE;
    endifFalse:
    oSum->aulDigits[lSumLength] = 1;
    lSumLength++;
endifCarry3:

oSum->lLength = lSumLength;
return TRUE;
