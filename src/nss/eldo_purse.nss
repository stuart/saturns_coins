#include "eldo_inc_coins"
#include "x2_inc_switches"
#include "x3_inc_string"

int ShowPurse(object oPC, struct Currency currency){
    string sResponse;
    int nValue;
    struct Purse purse = GetPurse(oPC, currency.sTag);

    if(purse.nCoin0 > 0){
        sResponse += StringToRGBString(purse.sName0, STRING_COLOR_GREEN) + ": " + IntToString(purse.nCoin0) + "\n";
    }
    if(purse.nCoin1 > 0){
        sResponse += StringToRGBString(purse.sName1, STRING_COLOR_GREEN) + ": " + IntToString(purse.nCoin1) + "\n";
    }
    if(purse.nCoin2 > 0){
        sResponse += StringToRGBString(purse.sName2, STRING_COLOR_GREEN) + ": " + IntToString(purse.nCoin2) + "\n";
    }
    if(purse.nCoin3 > 0){
        sResponse += StringToRGBString(purse.sName3, STRING_COLOR_GREEN) + ": " + IntToString(purse.nCoin3) + "\n";
    }
    if(purse.nCoin4 > 0){
        sResponse += StringToRGBString(purse.sName4, STRING_COLOR_GREEN) + ": " + IntToString(purse.nCoin4) + "\n";
    }

    nValue = ValuePurse(purse);
    if(nValue > 0){
      sResponse += StringToRGBString(currency.sName + " : " + IntToString(nValue/100) + "." + IntToString(nValue%100) + "GP", "740");

      SendMessageToPC(oPC, sResponse);
    }

    return(nValue);
}

void ShowPurses(object oPC)
{
    int nValue;
    string sResponse;
    struct Currency currency;
    int nGP = GetGold(oPC);

    currency = GetFirstCurrency(GetModule());

    while(currency.sTag != ""){
      nValue += ShowPurse(oPC, currency);
      currency = GetNextCurrency(GetModule());
    }

    sResponse = StringToRGBString("Total: " + IntToString(nValue/100 + nGP) + "." + IntToString(nValue%100) + "GP", "770");
    SendMessageToPC(oPC, sResponse);
}


void main()
{
    int    nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;

    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:
            oPC   = GetItemActivator();
            oItem = GetItemActivated();

            ShowPurses(oPC);
            break;
    }

    SetExecutedScriptReturnValue(nResult);
}
