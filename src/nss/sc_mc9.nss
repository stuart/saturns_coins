#include "eldo_inc_coins"

int StartingConditional()
{
    int iResult;
    iResult = ValuePurse(GetPurse(GetPCSpeaker(), "goblin"));
    SetCustomToken(2003, GetModuleCurrency("goblin").sName);

    return(iResult);
}
