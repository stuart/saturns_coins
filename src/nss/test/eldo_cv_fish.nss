#include "eldo_inc_coins"

void main()
{
    object oPC = GetPCSpeaker();
    TakeCoinsFromPC(3, oPC);
    CreateItemOnObject("whiting", oPC);

}
