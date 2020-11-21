#include "eldo_inc_coins"

void main()
{
   object oPC = GetPCSpeaker();
   string sFromCurrency = GetLocalString(oPC, "FROM_CURRENCY");
   string sToCurrency = GetLocalString(oPC, "TO_CURRENCY");
   int nFeeRate = GetLocalInt(OBJECT_SELF, "FEE");

   int nValue = ValuePurse(GetPurse(oPC, sFromCurrency));
   int nFee = nValue * nFeeRate / 100;

   TakeCoinsFromPC(nValue, oPC, sFromCurrency);
   GiveCoinsToPC(nValue - nFee, oPC, sToCurrency);
}
