#include "eldo_inc_coins"

void main()
{
    object oPC = GetLastOpenedBy();
    SetLocalInt(oPC, "ELDO_IN_STORE", TRUE);
    MultipleCurrencyCoinsToGP(oPC, OBJECT_SELF);
}
