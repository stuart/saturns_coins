#include "eldo_inc_coins"
#include "x2_inc_switches"

void MoveCoinToPurse(object oPC, object oItem){
    object oPurse = GetItemPossessedBy(oPC, "eldo_purse");
    if(oPurse != OBJECT_INVALID){
      AssignCommand(oPC, ActionGiveItem(oItem, oPurse));
    }
}

void main()
{
    int    nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;

    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACQUIRE:
            oPC = GetModuleItemAcquiredBy();
            oItem = GetModuleItemAcquired();

            MoveCoinToPurse(oPC, oItem);
            AssignCoinWeight(oPC);

            break;

        case X2_ITEM_EVENT_UNACQUIRE:
            oPC = GetModuleItemLostBy();
            AssignCoinWeight(oPC);;

            break;
    }

    SetExecutedScriptReturnValue(nResult);
}
