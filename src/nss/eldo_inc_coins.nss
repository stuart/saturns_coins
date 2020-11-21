//::///////////////////////////////////////////////
//:: eldo_inc_coins
//:: (c) 2020 Stuart Coyle
//::
//::
//:://////////////////////////////////////////////
/*
  Include file for currency and coin system.

  See README.txt for how to use this.

*/
//:://////////////////////////////////////////////
//:: Created By: Stuart Coyle
//:: Created On: 2020-11-16
//:://////////////////////////////////////////////

/*
    When ELDO_FETCH_CURRENCIES_FROM_2DA is TRUE
    Currency data is fetched on the first lookup from
    the currency.2da file. This data is then set
    as local variables on the module. If you don't want
    this behaviour set it to FALSE. Then just use
    the default currency with tag "default" or add your
    own vars to the module.

    Given a currency tag of "xxx" the variable names
    you need are:
      A string set to the tag with an index n for each currency.
      These must start at 0 and be sequential.
        "currency_n_tag"= "xxx"

      A String for the currency name:
        "currency_xxx_name"

      Integers denoting how many cents each denomination
      is worth:
        "currency_xxx_value0"
        "currency_xxx_value1"
        "currency_xxx_value2"
        "currency_xxx_value3"
        "currency_xxx_value4"

    A note on efficiency:

    Calls to SetPurse and GetPurse do a single traverse
    of the player's inventory. If there are a lot of
    items in there this can take some time.
    I have tried to minimise calls to these functions
    and so should you. Pass purse struct and save purses
    to locals where you can instead of using GetPurse
    every time.

*/

const int ELDO_FETCH_CURRENCIES_FROM_2DA = TRUE;

/*
   When this is true the weight item will be added for coins.
*/
const int ELDO_COIN_WEIGHT = TRUE;

/*
   How many coins make up one pound of weight.
*/
const int ELDO_COINS_PER_POUND = 50;

/*
  Sets wether the purse item can be stolen.
*/
const int ELDO_PURSE_IS_PICKPOCKETABLE = FALSE;

/*
   The tag of coin items.
*/
const string ELDO_COIN_TAG = "eldo_coin";

/*
   The tag and resref of the coin stack item used for weight tracking.
*/
const string ELDO_COIN_STACK_TAG = "eldo_coin_stack";
const string ELDO_COIN_STACK_RESREF = "eldo_coin_stack";

/*
  The tag and resref of the purse item.
*/
const string ELDO_PURSE_TAG = "eldo_purse";
const string ELDO_PURSE_RESREF = "eldo_purse";

/*
  The heartbeat script for the PC to convert GP to coins.
  See: eldo_pc_hbeat for how it works and add that code
  to your own heartbeat script for PCs if you use one.
*/
const int ELDO_SET_HEARTBEAT_SCRIPT = TRUE;
const string ELDO_PC_HEARTBEAT_SCRIPT = "eldo_pc_hbeat";
const int ELDO_HB_COUNT = 0;

/*
    These are the denomination values for the default currency.
*/
const int ELDO_CURRENCY_DEFAULT_VALUE0 = 1;    //CP
const int ELDO_CURRENCY_DEFAULT_VALUE1 = 10;   //SP
const int ELDO_CURRENCY_DEFAULT_VALUE2 = 50;   //EP
const int ELDO_CURRENCY_DEFAULT_VALUE3 = 100;  //GP
const int ELDO_CURRENCY_DEFAULT_VALUE4 = 1000; //PP

/*
  A struct describing the set of coins in a particular
  currency that a character has (or had).
*/
struct Purse{
  string sCurrency;
  int nCoin0;
  int nCoin1;
  int nCoin2;
  int nCoin3;
  int nCoin4;
  string sName0;
  string sName1;
  string sName2;
  string sName3;
  string sName4;
};


struct Currency{
    int nIndex;
    string sTag;
    string sName;
    int nValue0;
    int nValue1;
    int nValue2;
    int nValue3;
    int nValue4;
};



/*
   Call this for each PC entering the module.
   Call it in the first Area they enter rather than
   in the Module entry. Or call it with a delay to
   ensure the PC is loaded into an area.
*/
void SetupPCOnEntry(object oPC);

void CreatePurse(object oPC);


/*
  Loads currencies from the currencies.2da
  You don't need to call this, the scripts will call
  it automatically on first currency lookup.

  Returns the number of loaded currencies.
*/
void LoadCurrenciesFrom2DA();

/*

  Lookup a currency for the module give a tag.
  The tags "" and "default" denote the default currency.

  Loads currencies from the 2da or sets up a default currency
  if they have not already been set up.

*/
struct Currency GetModuleCurrency(string sTag);

/*
   Get the first currency for the module.
*/
int nCurrencyCursor = 0;// Yes I know global vars have issues. Deal with it.

struct Currency GetFirstCurrency(object oMod){
    nCurrencyCursor = 0;
    return GetModuleCurrency(GetLocalString(oMod, "currency_0_tag"));
}

/*
    Get the next currency for the module.
    Assumes that GetFirstCurrency has been called
    previously to reset the cursor.
*/
struct Currency GetNextCurrency(object oMod){
    nCurrencyCursor++;
    return GetModuleCurrency(GetLocalString(oMod, "currency_" + IntToString(nCurrencyCursor) + "_tag"));
}

/*
    Adjusts the coins on a PC by nAmount in cents.
*/
void GiveCoinsToPC(int nAmount, object oPC, string sCurrency = "default");
void TakeCoinsFromPC(int nAmount, object oPC, string sCurrency = "default");

/*
    Converts the coin Items on a PC to GP for a particular currency.
    It saves the purse to local vars so that when we convert
    back to coins we can give change based on the actual set
    of coins the PC was holding.

*/
void CoinsToGP(object oPC, string sVarName, string sCurrency = "default");

/*
    Converts all the character's GP into coins of a particular
    currency. Uses the saved purse if it available to ensure change
    is given based on the coins the PC held before they were converted
    to GP.
*/
void GPToCoins(object oPC, string sVarName = "", string sCurrency = "default");

/*
   Use these functions on opening and closing merchant stores
   if you are using multiple currencies in your mod.

   Requires the merchant to have the local string CURRENCY or
   CURRENCY0, CURRENCY1 etc.
*/
void MultipleCurrencyCoinsToGP(object oPC, object oMerchant);
void GPToMultipleCurrencyCoins(object oPC, object oMerchant);

/*
    Returns the value of a purse in cents.
    Use GetPurse(oPC, sCurrency) to get a purse to check the value of.

    For example if I want to know how much goblin money oPC has
    in inventory do this:
        int nCents = ValuePurse(GetPurse(oPC, "goblin"));

*/
int ValuePurse(struct Purse purse);


/*
    Returns a purse with correct change given according to the nAmount
    adjustment. if bCents is TRUE nAmount is treated as cents.
    Otherwise it is treated as a GP amount and will not touch cents.
    Gives the largest denomination coins possible, and takes change from
    the smallest first.
*/
struct Purse AdjustPurse(int nAmount, struct Purse purse, int bCents = FALSE);

/*
    Gets a purse struct representing the coins that a character has in
    inventory of a particular currency. If sCurrency is blank it returns
    a purse for the default currency.
*/
struct Purse GetPurse(object oPC, string sCurrency = "default");

/*
    Sets the coins in a character's inventory according to the purse passed in.
*/
void SetPurse(struct Purse purse, object oPC);

/*
    Stores a purse struct for later use as Locals on object oSave.
    sVarName is appended to the local vars.
*/
void SavePurse(struct Purse purse, object oSave, string sVarName);

/*
   Loads a purse struct from locals on oSave.
*/
struct Purse LoadPurse(object oSave, string sVarName);


/*
  Constructs the resref for a coin Item of a particular currency.
  This is of the form: coin_xxx_n where xxx is the currency and n is the
  denomination.
*/
string CoinResRef(int nDenom, string sCurrency){
   return("coin_" + sCurrency + "_" + IntToString(nDenom));
}

void SetupPCOnEntry(object oPC)
{
  if(GetIsPC(oPC)){
    AssignCommand(oPC, CreatePurse(oPC));
    if(ELDO_SET_HEARTBEAT_SCRIPT){
      SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, ELDO_PC_HEARTBEAT_SCRIPT);
    }
  }
}

void CreatePurse(object oPC)
{
    object oPurse = CreateItemOnObject(ELDO_PURSE_RESREF, oPC);
    SetPickpocketableFlag(oPurse, ELDO_PURSE_IS_PICKPOCKETABLE);

    if(oPurse == OBJECT_INVALID){
        SendMessageToPC(oPC, "Cannot create purse");
    }
    GPToCoins(oPC, "default", "default");
}

void CoinsToGP(object oPC, string sVarName, string sCurrency = "default"){
    struct Purse emptyPurse;
    emptyPurse.sCurrency = sCurrency;
    struct Purse purse = GetPurse(oPC, sCurrency);
    int nCents = ValuePurse(purse);
    int nGP = nCents/100;

    SavePurse(purse, oPC, sVarName);
    SetPurse(emptyPurse, oPC);

    GiveGoldToCreature(oPC, nGP);
}

void GPToCoins(object oPC, string sVarName = "", string sCurrency = "default")
{
    int nGP = GetGold(oPC);
    struct Purse purse;
    struct Purse savedPurse;
    int nCents;

    purse = GetPurse(oPC, sCurrency);
    if(sVarName != ""){
      savedPurse = LoadPurse(oPC, sVarName);
    }
    nCents = ValuePurse(savedPurse);

    // Ensures that if we have picked up coins
    // while shop is open they are not deleted.
    purse.nCoin0 += savedPurse.nCoin0;
    purse.nCoin1 += savedPurse.nCoin1;
    purse.nCoin2 += savedPurse.nCoin2;
    purse.nCoin3 += savedPurse.nCoin3;
    purse.nCoin4 += savedPurse.nCoin4;
    purse = AdjustPurse(nGP - (nCents / 100), purse);

    SetPurse(purse, oPC);
    TakeGoldFromCreature(nGP, oPC, TRUE);
}

void MultipleCurrencyCoinsToGP(object oPC, object oMerchant){
  string sCurrency = GetLocalString(oMerchant, "CURRENCY0");
  int nIndex;

  if(sCurrency != ""){
    while(sCurrency != ""){
      CoinsToGP(oPC, GetTag(oMerchant) + sCurrency, sCurrency);
      sCurrency = GetLocalString(oMerchant, "CURRENCY" + IntToString(++nIndex));
    }
  }else{
    sCurrency = GetLocalString(oMerchant, "CURRENCY");
    CoinsToGP(oPC, GetTag(oMerchant), sCurrency);
  }
}


void GPToMultipleCurrencyCoins(object oPC, object oMerchant){
   int nGP = GetGold(oPC);
   string sCurrency = GetLocalString(oMerchant, "CURRENCY");
   struct Purse purse;
   struct Purse savedPurse;
   int nIndex;
   int nCents;

   if(sCurrency == ""){
     /* Find the last currency */
     nIndex = 100;
     while(sCurrency == ""){
       sCurrency = GetLocalString(oMerchant, "CURRENCY" + IntToString(--nIndex));
     }
     while(sCurrency != ""){
       purse = GetPurse(oPC, sCurrency);
       savedPurse = LoadPurse(oPC, GetTag(oMerchant) + sCurrency);
       nCents = ValuePurse(savedPurse);

       purse.nCoin0 += savedPurse.nCoin0;
       purse.nCoin1 += savedPurse.nCoin1;
       purse.nCoin2 += savedPurse.nCoin2;
       purse.nCoin3 += savedPurse.nCoin3;
       purse.nCoin4 += savedPurse.nCoin4;

       if(nGP > (nCents / 100) && nIndex > 0){
         SetPurse(purse, oPC);
         TakeGoldFromCreature(nCents/100, oPC, TRUE);
         nGP -= (nCents/100);
       }else{
         purse = AdjustPurse(nGP - (nCents / 100), purse);
         SetPurse(purse, oPC);
         TakeGoldFromCreature(nGP, oPC, TRUE);
         nGP = 0;
       }

       sCurrency = GetLocalString(oMerchant, "CURRENCY" + IntToString(--nIndex));
     }
   }else{
    sCurrency = GetLocalString(oMerchant, "CURRENCY");
    GPToCoins(oPC, GetTag(oMerchant), sCurrency);
  }

}

void GiveCoinsToPC(int nAmount, object oPC, string sCurrency = "default"){
    struct Purse purse = GetPurse(oPC, sCurrency);
    purse = AdjustPurse(nAmount, purse, TRUE);
    SetPurse(purse, oPC);
}

void TakeCoinsFromPC(int nAmount, object oPC, string sCurrency = "default"){
    struct Purse purse = GetPurse(oPC, sCurrency);
    purse = AdjustPurse(-nAmount, purse, TRUE);
    SetPurse(purse, oPC);
}

struct Purse GetPurse(object oPC, string sCurrency = "default"){
    object oItem = GetFirstItemInInventory(oPC);
    string sTag;
    int nStack;
    struct Purse p;
    int i;

    p.sCurrency = sCurrency;

    while(oItem != OBJECT_INVALID){
        sTag = GetResRef(oItem);

        for(i = 0; i < 5; i++){
          if(sTag == CoinResRef(i, sCurrency)){
            nStack = GetItemStackSize(oItem);
            switch(i){
            case 0:
                p.nCoin0 += nStack;
                p.sName0 = GetName(oItem);
                break;
            case 1:
                p.nCoin1 += nStack;
                p.sName1 = GetName(oItem);
                break;
            case 2:
                p.nCoin2 += nStack;
                p.sName2 = GetName(oItem);
                break;
            case 3:
                p.nCoin3 += nStack;
                p.sName3 = GetName(oItem);
                break;
            case 4:
                p.nCoin4 += nStack;
                p.sName4 = GetName(oItem);
                break;
            }
          }
        }

        oItem = GetNextItemInInventory(oPC);
  }

  return(p);
}

void SetPurse(struct Purse purse, object oPC){
    string sCurrency = purse.sCurrency;
    struct Currency currency = GetModuleCurrency(sCurrency);

    struct Purse existingPurse = GetPurse(oPC, sCurrency);
    int i;
    int nDiff0, nDiff1, nDiff2, nDiff3, nDiff4;
    object oItem;
    string sTag;
    int nStack;

    nDiff0 = purse.nCoin0 - existingPurse.nCoin0;
    nDiff1 = purse.nCoin1 - existingPurse.nCoin1;
    nDiff2 = purse.nCoin2 - existingPurse.nCoin2;
    nDiff3 = purse.nCoin3 - existingPurse.nCoin3;
    nDiff4 = purse.nCoin4 - existingPurse.nCoin4;

    //Remove coins in one pass of inventory where there is a surplus.
    oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID){
        sTag = GetResRef(oItem);
        nStack = GetItemStackSize(oItem);

        if(nDiff0 < 0 && sTag == CoinResRef(0, sCurrency)){
            // nDiff0 is negative at this point
            if(nStack > -nDiff0){
                SetItemStackSize(oItem, nStack + nDiff0);
                nDiff0 = 0;
            }else{
                DestroyObject(oItem);
                nDiff0 += nStack;
            }
        }

        if(nDiff1 < 0 && sTag == CoinResRef(1, sCurrency)){
            if(nStack > -nDiff1){
                SetItemStackSize(oItem, nStack + nDiff1);
                nDiff1 = 0;
            }else{
                DestroyObject(oItem);
                nDiff1 += nStack;
            }
        }

        if(nDiff2 < 0 && sTag == CoinResRef(2, sCurrency)){
            if(nStack > -nDiff2){
                SetItemStackSize(oItem, nStack + nDiff2);
                nDiff2 = 0;
            }else{
                DestroyObject(oItem);
                nDiff2 += nStack;
            }
        }

        if(nDiff3 < 0 && sTag == CoinResRef(3, sCurrency)){
            if(nStack > -nDiff3){
                SetItemStackSize(oItem, nStack + nDiff3);
                nDiff3 = 0;
            }else{
                DestroyObject(oItem);
                nDiff3 += nStack;
            }
        }

        if(nDiff4 < 0 && sTag == CoinResRef(4, sCurrency)){
            if(nStack > -nDiff4){
                SetItemStackSize(oItem, nStack + nDiff4);
                nDiff4 = 0;
            }else{
                DestroyObject(oItem);
                nDiff4 += nStack;
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }

    /*
        Create coins whree there is a deficit.
        N.B. Coins are created on the purse's container not
        necessarily the PC.

        If a coin item template is not available then
        this flows to the next smallest denomination.
    */
    sTag = CoinResRef(4, sCurrency);
    while(nDiff4 > 0){
      oItem = CreateItemOnObject(sTag, oPC, nDiff4);
      if(oItem == OBJECT_INVALID){
        nDiff3 += nDiff4 * currency.nValue4 / currency.nValue3;
        nDiff4 = 0;
      }else{
        nDiff4 -= GetItemStackSize(oItem);
      }
    }

    sTag = CoinResRef(3, sCurrency);
    while(nDiff3 > 0 ){
      oItem = CreateItemOnObject(sTag, oPC, nDiff3);
      if(oItem == OBJECT_INVALID){
        nDiff2 += nDiff4 * currency.nValue3 / currency.nValue2;
        nDiff3 = 0;
      }else{
        nDiff3 -= GetItemStackSize(oItem);
      }
    }

    sTag = CoinResRef(2, sCurrency);
    while(nDiff2 > 0){
      oItem = CreateItemOnObject(sTag, oPC, nDiff2);
      if(oItem == OBJECT_INVALID){
        nDiff1 += nDiff2 * currency.nValue2 / currency.nValue1;
        nDiff2 = 0;
      }else{
        nDiff2 -= GetItemStackSize(oItem);
      }
    }

    sTag = CoinResRef(1, sCurrency);
    while(nDiff1 > 0){
      oItem = CreateItemOnObject(sTag, oPC, nDiff1);
      if(oItem == OBJECT_INVALID){
        nDiff0 += nDiff1 * currency.nValue1 / currency.nValue0;
        nDiff1 = 0;
      }else{
        nDiff1 -= GetItemStackSize(oItem);
      }
    }

    sTag = CoinResRef(0, sCurrency);
    while(nDiff0 > 0){
      oItem = CreateItemOnObject(sTag, oPC, nDiff0);
      if(oItem == OBJECT_INVALID){
        nDiff0 = 0;
        /* We have not found any coin Item templates for this currency. */
        WriteTimestampedLogEntry("[ELDO_ERROR] Missing coin templates for currency: " + sCurrency);
      }else{
        nDiff0 -= GetItemStackSize(oItem);
      }
    }
}

void SavePurse(struct Purse purse, object oSave, string sVarName){
    SetLocalString(oSave, sVarName + "_CURRENCY", purse.sCurrency);
    SetLocalInt(oSave, sVarName + "_COIN0", purse.nCoin0);
    SetLocalInt(oSave, sVarName + "_COIN1", purse.nCoin1);
    SetLocalInt(oSave, sVarName + "_COIN2", purse.nCoin2);
    SetLocalInt(oSave, sVarName + "_COIN3", purse.nCoin3);
    SetLocalInt(oSave, sVarName + "_COIN4", purse.nCoin4);
}

struct Purse LoadPurse(object oSave, string sVarName){
    struct Purse purse;
    purse.sCurrency = GetLocalString(oSave, sVarName + "_CURRENCY");
    purse.nCoin0 = GetLocalInt(oSave, sVarName + "_COIN0");
    purse.nCoin1 = GetLocalInt(oSave, sVarName + "_COIN1");
    purse.nCoin2 = GetLocalInt(oSave, sVarName + "_COIN2");
    purse.nCoin3 = GetLocalInt(oSave, sVarName + "_COIN3");
    purse.nCoin4 = GetLocalInt(oSave, sVarName + "_COIN4");

    return purse;
}

int ValuePurse(struct Purse purse){
    struct Currency currency = GetModuleCurrency(purse.sCurrency);

    return(purse.nCoin0 * currency.nValue0 +
           purse.nCoin1 * currency.nValue1 +
           purse.nCoin2 * currency.nValue2 +
           purse.nCoin3 * currency.nValue3 +
           purse.nCoin4 * currency.nValue4);
}

// Integer division rounding to negative infinity rather than to zero.
int FloorDiv(int a, int b){
    float q = IntToFloat(a) / IntToFloat(b);
    int nResult;

    if(q < 0.0){
        nResult = FloatToInt(q) - 1;
    }else{
        nResult = FloatToInt(q);
    }
    return(nResult);
}

struct Purse AdjustPurse(int nAmount, struct Purse p, int bCents = FALSE)
{
    int nDiff;
    int nChange;
    struct Currency currency = GetModuleCurrency(p.sCurrency);

    // We don't want to adjust cents if bCents is FALSE
    if(bCents){
      nChange = nAmount;
    }
    else{
      nChange = nAmount * 100;
    }

    if(nChange < 0){
        if(-nChange <= p.nCoin0 * currency.nValue0){
            p.nCoin0 += nChange;
            nChange = 0;
        }else{
            nChange += p.nCoin0 * currency.nValue0;
            p.nCoin0 = 0;
        }

        if(-nChange <= p.nCoin1 * currency.nValue1 && currency.nValue1 != 0){
           nDiff = FloorDiv(nChange, currency.nValue1);
           p.nCoin1 += nDiff;
           nChange -= nDiff * currency.nValue1;
        }else{
            nChange += p.nCoin1 * currency.nValue1;
            p.nCoin1 = 0;
        }

        if(-nChange <= p.nCoin2 * currency.nValue2 && currency.nValue2 != 0){
           nDiff = FloorDiv(nChange, currency.nValue2);
           p.nCoin2 += nDiff;
           nChange -= nDiff * currency.nValue2;
        }else{
           nChange += p.nCoin2 * currency.nValue2;
           p.nCoin2 = 0;
        }

        if(-nChange <= p.nCoin3 * currency.nValue3 && currency.nValue3 != 0){
           nDiff = FloorDiv(nChange, currency.nValue3);
           p.nCoin3 += nDiff;
           nChange -= nDiff * currency.nValue3;
        }else{
            nChange += p.nCoin3 * currency.nValue3;
            p.nCoin3 = 0;
        }

        if(-nChange <= p.nCoin4 * currency.nValue4 && currency.nValue4 != 0){
           nDiff = FloorDiv(nChange, currency.nValue4);
           p.nCoin4 += nDiff;
           nChange -= nDiff *  currency.nValue4;
        }else{
            nChange += p.nCoin4 *  currency.nValue4;
            p.nCoin4 = 0;
        }
    }

    if(nChange >= currency.nValue4 && currency.nValue4 != 0){
        nDiff = nChange / currency.nValue4;
        p.nCoin4 += nDiff;
        nChange -= nDiff * currency.nValue4;
    }

    if(nChange >= currency.nValue3 && currency.nValue3 != 0){
        nDiff = nChange / currency.nValue3;
        p.nCoin3 += nDiff;
        nChange -= nDiff * currency.nValue3;
    }

    if(nChange >= currency.nValue2 && currency.nValue2 != 0){
        nDiff = nChange / currency.nValue2;
        p.nCoin2 += nDiff;
        nChange -= nDiff * currency.nValue2;
    }

    if(nChange >= currency.nValue1 && currency.nValue1 != 0){
        nDiff = nChange / currency.nValue1;
        p.nCoin1 += nDiff;
        nChange -= nDiff * currency.nValue1;
    }

    if(nChange >= currency.nValue0 && currency.nValue0 != 0){
        nDiff = nChange / currency.nValue0;
        p.nCoin0 += nDiff;
        nChange -= nDiff * currency.nValue0;
    }

    return(p);
}

void LoadCurrenciesFrom2DA(){
   int nRow = 0;
   int nName;
   object oMod = GetModule();
   struct Currency c;
   WriteTimestampedLogEntry("Loading Currencies");

   string sTag = Get2DAString("currencies", "Tag", nRow);

   while(sTag != ""){
      WriteTimestampedLogEntry("Loading Currency: " + sTag);
      WriteTimestampedLogEntry("Row: " + IntToString(nRow));

      c.nIndex = nRow;
      c.sTag = sTag;
      nName = StringToInt(Get2DAString("currencies", "Name", nRow));
      c.sName = GetStringByStrRef(nName);
      c.nValue0 = StringToInt(Get2DAString("currencies", "Value0", nRow));
      c.nValue1 = StringToInt(Get2DAString("currencies", "Value1", nRow));
      c.nValue2 = StringToInt(Get2DAString("currencies", "Value2", nRow));
      c.nValue3 = StringToInt(Get2DAString("currencies", "Value3", nRow));
      c.nValue4 = StringToInt(Get2DAString("currencies", "Value4", nRow));

      SetLocalString(oMod, "currency_" + IntToString(nRow) + "_tag", c.sTag);
      SetLocalString(oMod, "currency_" + sTag + "_name", c.sName);
      SetLocalInt(oMod, "currency_" + sTag + "_value0", c.nValue0);
      SetLocalInt(oMod, "currency_" + sTag + "_value1", c.nValue1);
      SetLocalInt(oMod, "currency_" + sTag + "_value2", c.nValue2);
      SetLocalInt(oMod, "currency_" + sTag + "_value3", c.nValue3);
      SetLocalInt(oMod, "currency_" + sTag + "_value4", c.nValue4);

      sTag = Get2DAString("currencies", "Tag", ++nRow);
   }
}

struct Currency GetModuleCurrency(string sTag){
    struct Currency c;
    object oMod = GetModule();

    if(!GetLocalInt(oMod, "currencies_init")){
      if(ELDO_FETCH_CURRENCIES_FROM_2DA){
        LoadCurrenciesFrom2DA();
        SetLocalInt(oMod, "currencies_init", TRUE);
      }
      else {
        SetLocalString(oMod, "currency_default_name", "Default Currency");
        SetLocalInt(oMod, "currency_default_value0", ELDO_CURRENCY_DEFAULT_VALUE0);
        SetLocalInt(oMod, "currency_default_value1", ELDO_CURRENCY_DEFAULT_VALUE1);
        SetLocalInt(oMod, "currency_default_value2", ELDO_CURRENCY_DEFAULT_VALUE2);
        SetLocalInt(oMod, "currency_default_value3", ELDO_CURRENCY_DEFAULT_VALUE3);
        SetLocalInt(oMod, "currency_default_value4", ELDO_CURRENCY_DEFAULT_VALUE4);
      }
      // Reload module so we ensure Vars update.
      oMod = GetModule();
    }

    c.sTag = sTag;
    c.sName = GetLocalString(oMod,"currency_" + sTag + "_name");
    c.nValue0 = GetLocalInt(oMod,"currency_" + sTag + "_value0");
    c.nValue1 = GetLocalInt(oMod,"currency_" + sTag + "_value1");
    c.nValue2 = GetLocalInt(oMod,"currency_" + sTag + "_value2");
    c.nValue3 = GetLocalInt(oMod,"currency_" + sTag + "_value3");
    c.nValue4 = GetLocalInt(oMod,"currency_" + sTag + "_value4");

    return(c);
}

void DoAssignCoinWeight(object oPC);

void AssignCoinWeight(object oPC){
   if(!ELDO_COIN_WEIGHT || GetLocalInt(oPC, "ELDO_ASSIGNING_COINS")){
        return;
   }
   SetLocalInt(oPC, "ELDO_ASSIGNING_COINS", TRUE);
   AssignCommand(oPC, DoAssignCoinWeight(oPC));
}

void DoAssignCoinWeight(object oPC){
    object oItem = GetFirstItemInInventory(oPC);
    int nCoins = 0;
    int nWeightsRequired;
    object oContainer = oPC;

    while(oItem != OBJECT_INVALID){
        if(GetTag(oItem) == ELDO_PURSE_TAG){
           oContainer = oItem;
        }
        if(GetTag(oItem) == ELDO_COIN_TAG){
            nCoins += GetItemStackSize(oItem);
        }
        if(GetTag(oItem) == ELDO_COIN_STACK_TAG){
           SetTag(oItem, "_destroy");
           DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oPC);
    }
    nWeightsRequired = (nCoins / ELDO_COINS_PER_POUND);

   while (nWeightsRequired > 0){
     if (nWeightsRequired >= 50000){
       CreateItemOnObject(ELDO_COIN_STACK_RESREF, oContainer, 50000);
       nWeightsRequired = nWeightsRequired - 50000;
     }else{
       CreateItemOnObject(ELDO_COIN_STACK_RESREF, oContainer, nWeightsRequired);
       nWeightsRequired = 0;
    }
  }

  SetLocalInt(oPC, "ELDO_ASSIGNING_COINS", FALSE);
}
