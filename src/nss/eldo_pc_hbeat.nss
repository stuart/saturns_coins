#include "eldo_inc_coins"

void main()
{
   if(!GetLocalInt(OBJECT_SELF, "ELDO_IN_STORE") && GetGold(OBJECT_SELF) > 0){
     int nHB = GetLocalInt(OBJECT_SELF, "ELDO_HB_COUNT");
     if(GetLocalInt(OBJECT_SELF, "ELDO_HB_COUNT") >= ELDO_HB_COUNT){
       GPToCoins(OBJECT_SELF, "default");
       SetLocalInt(OBJECT_SELF, "ELDO_HB_COUNT", 0);
     }else{
       SetLocalInt(OBJECT_SELF, "ELDO_HB_COUNT", nHB + 1);
     }
   }
}
