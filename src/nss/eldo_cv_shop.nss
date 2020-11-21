#include "eldo_inc_coins"

int StartingConditional()
{
    object oStore = GetNearestObjectByTag("ELDO_SHOP");
    string sCurrencies = "";
    string sCurTag = GetLocalString(oStore, "CURRENCY");
    int nIndex = 0;

    if(sCurTag != ""){
      sCurrencies = GetModuleCurrency(sCurTag).sName;
    }else{
      sCurTag = GetLocalString(oStore, "CURRENCY" + IntToString(nIndex));
      while(sCurTag != ""){
        sCurrencies += GetModuleCurrency(sCurTag).sName + "\n";
        sCurTag = GetLocalString(oStore, "CURRENCY" + IntToString(++nIndex));
      }
    }


    SetCustomToken(1000, sCurrencies);
    return TRUE;
}
