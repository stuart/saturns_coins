#include "eldo_inc_coins"
#include "x2_inc_switches"

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

        SetItemCursedFlag(oItem, TRUE);

        break;
    }

    SetExecutedScriptReturnValue(nResult);
}
