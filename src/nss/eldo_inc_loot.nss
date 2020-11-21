/*
  Gold generation for Saturn's Coin System.
  Is called in nw_o2_coninclude to generate
  money in loot. Instead of generating default
  gold this generates coins.

  If you set the "CURRENCY" local string on a container
  you can generate coins of that currency.

*/
#include "eldo_inc_coins"

void ELDOCreateGold(object oTarget, int nTreasureType, int nAmount)
{
  struct Purse purse;
  purse.sCurrency = GetLocalString(oTarget, "CURRENCY");
  if(purse.sCurrency == ""){
    purse.sCurrency = "default";
  }
  struct Currency currency = GetModuleCurrency(purse.sCurrency);

  int nRoll;
  int nFraction;
  int nRemaining = nAmount;

  if(nTreasureType == TREASURE_LOW){
    // Add coins until the value is at least 90% of nAmount.
    // This takes 1 to 6 passes most of the time.
    while(nRemaining > nAmount/10)
    {
      nRoll = d10();
      // Get a random fraction of the remaining amount.
      nFraction = FloatToInt(nRemaining * d100() / 100.0);
      SendMessageToPC(GetFirstPC(), "Low : " + IntToString(nRoll) + " " + IntToString(nFraction));
      switch(nRoll){
      case 1:
      case 2:
      case 3:
      case 4:
        if(currency.nValue0 > 0){
          purse.nCoin0 += nFraction/currency.nValue0;
        }
        break;
      case 5:
      case 6:
      case 7:
      case 8:
        if(currency.nValue1 > 0){
           purse.nCoin1 += nFraction/currency.nValue1;
        }
        break;
      case 9:
        if(currency.nValue2 > 0){
           purse.nCoin2 += nFraction/currency.nValue2;
        }
        break;
      case 10:
        if(currency.nValue3 > 0){
           purse.nCoin3 += nFraction/currency.nValue3;
        }
        break;
      }
      nRemaining = nAmount - ValuePurse(purse);
    }
  }

  if(nTreasureType == TREASURE_MEDIUM){
    while(nRemaining > nAmount/20)
    {
      nRoll = d10();
      nFraction = FloatToInt(nRemaining * d100() / 100.0);
      switch(nRoll){
      case 1:
      case 2:
        if(currency.nValue0 >0){
         purse.nCoin0 += nFraction/currency.nValue0;
        }
        break;
      case 3:
      case 4:
      case 5:
      case 6:
        if(currency.nValue1 >0){
         purse.nCoin1 += nFraction/currency.nValue1;
        }
        break;
      case 7:
      case 8:
        if(currency.nValue2 >0){
          purse.nCoin2 += nFraction/currency.nValue2;
        }
        break;
      case 9:
      case 10:
        if(currency.nValue3 >0){
          purse.nCoin3 += nFraction/currency.nValue3;
        }
        break;
      }
      nRemaining = nAmount - ValuePurse(purse);
    }
  }

  if(nTreasureType == TREASURE_HIGH){
    while(nRemaining > nAmount/20){
        nRoll = d10();
        nFraction = FloatToInt(nRemaining * d100() / 100.0);
       switch(nRoll){
       case 1:
         if(currency.nValue0 >0){
           purse.nCoin0 += nFraction/currency.nValue0;
         }
        break;
        case 2:
          if(currency.nValue1 >0){
            purse.nCoin1 += nFraction/currency.nValue1;
          }
          break;
        case 3:
        case 4:
          if(currency.nValue2 >0){
            purse.nCoin2 += nFraction/currency.nValue2;
          }
          break;
        case 5:
        case 6:
        case 7:
        case 8:
          if(currency.nValue3 >0){
            purse.nCoin3 += nFraction/currency.nValue3;
          }
          break;
        case 9:
        case 10:
          if(currency.nValue4 >0){
            purse.nCoin4 += nFraction/currency.nValue4;
          }
        }
    nRemaining = nAmount - ValuePurse(purse);
    }
  }
  SetPurse(purse, oTarget);
}
