#include "eldo_inc_coins"

/*
  On opening a store we convert all the coins in the character's inventory
  of the currency set on the merchant into GP.

*/
void main()
{
    object oPC = GetLastClosedBy();
    GPToMultipleCurrencyCoins(oPC,OBJECT_SELF);
    SetLocalInt(oPC, "ELDO_IN_STORE", FALSE);
}
