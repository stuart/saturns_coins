//:://////////////////////////////////////////////////
//:: X0_D2_DIDTHREAT
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Check if the PC threatened the NPC
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/26/2002
//:://////////////////////////////////////////////////

#include "x0_i0_common"

int StartingConditional()
{
    return GetThreaten(GetPCSpeaker());
}
