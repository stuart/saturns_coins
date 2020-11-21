#include "eldo_inc_coins"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sCurrency = GetLocalString(oPC, "FROM_CURRENCY");
    int nValue = ValuePurse(GetPurse(oPC, sCurrency));
    int nFee = GetLocalInt(OBJECT_SELF, "FEE") * nValue / 100;

    string sValue = IntToString(nValue/100) + "." + IntToString(nValue % 100);
    string sFee = IntToString(nFee/100) + "." + IntToString(nFee % 100);

    SetCustomToken(2007, sValue);
    SetCustomToken(2008, sFee);

    return TRUE;
}
