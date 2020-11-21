#include "eldo_inc_coins"

int StartingConditional()
{
    int iResult;
    iResult = ValuePurse(GetPurse(GetPCSpeaker(), "elf"));
    SetCustomToken(2004, GetModuleCurrency("elf").sName);

    return(iResult);
}
