#include "eldo_inc_coins"

int StartingConditional()
{
    int iResult;
    iResult = ValuePurse(GetPurse(GetPCSpeaker(), "default"));
    SetCustomToken(2005, GetModuleCurrency("default").sName);

    return(iResult);
}
