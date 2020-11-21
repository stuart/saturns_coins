//:://////////////////////////////////////////////////
//:: X0_D2_HEN_INTER
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Return TRUE if the henchman has an interjection to make
to this PC right now. 
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////


#include "x0_i0_henchman"

int StartingConditional()
{
    return GetHasInterjection(GetPCSpeaker());
}
