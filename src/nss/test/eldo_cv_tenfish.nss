#include "eldo_inc_coins"

void main()
{
    object oPC = GetPCSpeaker();
    int i;

    TakeCoinsFromPC(27, oPC);

    for(i = 0; i < 10; i++){
      CreateItemOnObject("whiting", oPC);
    }
}
