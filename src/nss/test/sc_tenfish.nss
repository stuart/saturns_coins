#include "nw_i0_tool"
#include "eldo_inc_coins"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(ValuePurse(GetPurse(oPC)) < 30)
        return FALSE;

    return TRUE;
}
