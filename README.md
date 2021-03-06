
# Dr Saturn's Coins System

## Status
This should be regarded as still in "Beta". I have not completed
all features, nor have I tested extensively on multiplayer servers.

Even so it is certainly in a stable usable state and updates will be forthcoming.

## Description
This system provides coins as items replacing the more abstract GP system that
is provided in NWN. It is aimed at modules that want to provide more
detailed role-play feel and economic structure to the game.

It allows module developers create items and services that can be sold for
fractions of a GP (Copper or Silver Pieces) just like in Pen and Paper games.
This is best done with a conversation based shop. A simple example is provided
in the demo module.

It allows builders to provide multiple currencies that not every merchant will
accept.

The system is configurable by module builders
and provides useful functions for scripters to hook into it.

## Features
1. Multiple currencies each with up to five configurable coin denominations.
2. Merchants automatically use the system and can be configured individually to use
one or more of the currencies.
3. Coins can be set to have weight and thus encumber characters.
4. Uses one optional heartbeat script on a PC.
5. CEP Compatible, but not CEP dependent.
6. Money changer conversation and scripts included. Examples of this is in the demo module.
7. Change given by merchants is based on the coins the PC was holding before opening the shop.
8. Provides a purse item into which all coins are automatically moved to keep inventory
clutter minimised. The purse has an on use action showing the PC's wealth to them.
9. The purse item may be set as not pick-pocketable thus providing some security for
a player's wealth on PvP servers.
10. Coins can be traded to other players, dropped on the ground and put into containers just
as any other item can be.
11. Coins are valued in steps of cents (1/100 GP)
12. Default NWN treasure script have been modified to give coins rather than gold.

## Details
This system works by converting all coins to NWN gold on opening a shop. It
then converts all gold back to coins on closing a store. Coin quantities are
stored on the PC in local variables while the store is open and adjustments
to the coins are made based on those.

Each currency may have up to five denominations that are configurable per
currency, thus you may have currencies with different value coins.

Coin items are stackable to 50000 per stack.

Weight items are 1 pound each and by default represent 50 coins. This can be
changed if required, or the feature may be turned off. The weight items are
automatically created and destroyed and will be placed in the PC's purse if
they have one.

There is an on_enter script included that can be run on a PC to give them
a purse and do the initial change of GP to coins. This code should be run
in the OnEnter event of the first Area that the PC comes to on starting the game.
Running it in the OnEnter event of the Module will not work.

## Installation
   1. Unzip
   2. Move the .hak to /hak
   3. Move the .erf to /erf
   4. Move the .tlk to /tlk
   5. Add the .hak to your module.
   6. Import the .erf
   7. Edit the required scripts and items to your liking.

The system is contained in a .hak file a .tlk and a .erf. The .hak is to be added to the
list of haks for the module. The .tlk entries (starting at 78500) need to be added to
the .tlk file of the module (or if you don't use one now just use the provided one).

The .erf is intended to be imported into the toolset by the module builder
and provides the scripts and item blueprints needed.

There is a module provided which shows builders how all the bits work together.

## Setup of Currencies
Currencies may be set up in three ways. The first and simplest is to just have
the one "default" currency. The second is to add local variables to your module
describing the currencies. The third is to use a .2da file containing the
currency information. An example .2da is provided in the .hak and is expected
to be overridden by your own module's variant. Denomination values are all in
cents (1/100GP).

###*The default currency only method.*
   1. Set the constant ELDO_FETCH_CURRENCIES_FROM_2DA in "eldo_inc_coins" to FALSE.
   2. Ensure you have coin item blueprints with ResRef and Tag "coin_default_0", "coin_default_1",
   "coin_default_2", "coin_default_3" and "coin_default_4".
   3. Set other configuration as desired (See the Configuration section below.)

###*The Module local variable method.*
  1. Set the constant ELDO_FETCH_CURRENCIES_FROM_2DA in "eldo_inc_coins" to FALSE.
  2. Ensure you have coin item blueprints with ResRef "coin_default_0", "coin_default_1",
  "coin_default_2", "coin_default_3" and "coin_default_4". These should have the tag "eldo_coin".
  3. Ensure you have coin item blueprints for each currency (where "xxx" is the currency tag)
  with ResRef "coin_xxx_0", "coin_xxx_1" etc. up to 4. These should have the tag "eldo_coin".
  You do not have to have all 5 denominations but they must start at 0 and be consecutive with increasing values.
  4. Set the following local variables on the Module for currency "xxx":
      - string currency_n_tag = xxx , where n is the currency index starting at 0 and going up one
      for each currency.  
      - string currency_xxx_name = "My Currency Name"
      - int currency_xxx_value0 = 1 The smallest coin must have a value of one or bad things may happen.
      - int currency_xxx_value1
      - int currency_xxx_value2  
      - int currency_xxx_value3  
      - int currency_xxx_value4

    The value locals must increase in value or be 0.

    A currency with 5 denominations:

          currency_xxx_value0 = 1
          currency_xxx_value1 = 10
          currency_xxx_value2 = 20
          currency_xxx_value3 = 100
          currency_xxx_value4 = 1000

    A currency with only three denominations:

          currency_xxx_value0 = 1
          currency_xxx_value1 = 10
          currency_xxx_value2 = 100
          currency_xxx_value3 = 0
          currency_xxx_value4 = 0

###*The 2da Method*

  To use this successfully you need to know your way around tools to edit .2da files
  and the files contained in a .hak file. You may edit the file in the .hak and distribute that
  to users of your module or you might place it in your own module .hak.
  1. Set the constant ELDO_FETCH_CURRENCIES_FROM_2DA in "eldo_inc_coins" to FALSE.
  2. Ensure you have coin item blueprints with ResRef "coin_default_0", "coin_default_1",
  "coin_default_2", "coin_default_3" and "coin_default_4". These should have the tag "eldo_coin".
  3. Ensure you have coin item blueprints for each currency (where "xxx" is the currency tag)
  with ResRef "coin_xxx_0", "coin_xxx_1" etc. up to 4. These should have the tag "eldo_coin".
  You do not have to have all 5 denominations but they must start at 0 and be increasing.
  4. Create a .2da file (preferrably edit the supplied one!) with a row for each currency.
  The first row must be the default currency.

  Each row has the following format:
       Row   Name   Tag   Value0   Value1   Value2   Value3   Value4

  The Name needs to be a StrRef defined in your module's .tlk file. This is
  the human readable name of the currency shown in conversations etc.

  The tag is unique for each currency and is used to find coins and store
  individual currency data. The currency with tag "default" *must* exist.

  Value0 must be set to 1 or bad things(tm) may happen.
  Values 1 through 4 must be set consecutively rising or set to \*\*\*\*.
  Don't set \*\*\*\* in the middle of the sequence. If, for example, you want only
  three denominations in a currency set Value0, Value1 and Value2 to integers
  and leave Value3 and Value4 as \*\*\*\*.

## Setup of Merchants  
  Merchants in this system need three important but simple configuration changes.
   1. That is to add the "Coin" item type to the Restricted Items list for the merchant.
   2. Set the OnOpenStore script to "eldo_storeopen"
   3. Set the OnCloseStore script to "eldo_closestore"

  Merchants will use the currency with tag "default" unless the following variables
  are set on them:

      string CURRENCY

  This sets a single currency for the merchant to accept. Set it to the tag
  of the currency you want the merchant to use.

      string CURRENCY0
      string CURRENCY1
      string CURRENCY3
      etc

  These set a list of currencies that the merchant will accept. Transactions will
  be preferentially conducted in CURRENCY0 then CURRENCY1 etc.
  If a trade results in the PC gaining money then it will be all in CURRENCY0.
  If a trade results in a PC spending money then it will be taken from CURRENCY0 first
  then CURRENCY1 etc. until the amount is paid.

  Money gained is given in the highest available denominations of the currency that
  can fit the amount .

  Money spent is taken from the lowest available denominations of the currency first.  

  There is a template merchant in the .erf with the required basic settings that you
  can use.

## Setup of Loot Containers
  Setup your loot containers as detailed in the x0_i0_treasure include script.

  If you want a container to drop a certain currency then set a local string "CURRENCY"
  on that container.

## Usage in Your own Scripts
These instructions are for scripters who want to modify things and make their own
cool things using this system.

Scripts using this system need to have this include:
     #include "eldo_inc_coins"
The include file has a decent amount of documentation to assist scripters.

### Finding Currencies
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

      struct Currency GetModuleCurrency(string sTag)
      struct Currency GetFirstCurrency()
      struct Currency GetNextCurrency()

Use these functions to get currency structs from the module. If using the iterators
check that currency.sTag == "" to end the iteration and avoid infinite loops.

### Giving and taking coins
    void GiveCoinsToPC(int nAmount, object oPC, string sCurrency = "default");
    void TakeCoinsFromPC(int nAmount, object oPC, string sCurrency = "default");
These do as expected and give or take nAmount in cents of coins of the desired currency
to and from a character. Use these on scripts where a player buys something or gets a
reward. You can of course just create the coin items from the
blueprints using CreateItemOnObject("coin_xxx_n", oPC) if you need to.

### Converting Coins
    void CoinsToGP(object oPC, string sVarName, string sCurrency = "default");
    void GPToCoins(object oPC, string sVarName, string sCurrency = "default");
These convert coins of a single currency to GP and vice versa. The sVarName
parameter is a local variable used to store the coins between calls to these
so that change can be correctly given.

    void MultipleCurrencyCoinsToGP(object oPC, object oMerchant);
    void GPToMultipleCurrencyCoins(object oPC, object oMerchant);
These are the functions used on opening and closing shops. They require the
merchant object to have the correct currency variables set up. You may find
another interesting use for them somewhere. (Money changer? Bank?)

### Inspecting a PC's purse
Data for the set of coins of a particular currency held by a PC is represented
by the Purse struct:

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

To check a PC's purse for a currency there are a couple of useful functions:

    struct Purse GetPurse(object oPC, string sCurrency = "default");
    int ValuePurse(struct Purse purse);

ValuePurse returns the purse value in cents.
N.B. The purse struct is nothing to do with the purse item.

### Purse saving
    void SavePurse(struct Purse purse, object oSave, string sVarName);
    struct Purse LoadPurse(object oSave, string sVarName);

These functions save and load a purse onto the object oSave as a set of
local variables. The variable names will all start with sVarName.

A persistent version of this functionality has not been implemented yet.  

### Modifying a PC's purse
    struct Purse AdjustPurse(int nAmount, struct Purse purse, int bCents = FALSE);
    void SetPurse(struct Purse purse, object oPC);

To modify a purse you are best to use GiveCoinsToPC and TakeCoinsFromPC functions.
All these actually do is call AdjustPurse then SetPurse. You may find
reason to use AdjustPurse by itself, for example if you wanted to check what
the result of an adjustment to a purse would be without actually changing the
coins. SetPurse can be used with a constructed Purse struct to assign a particular
set of coins to a character.

## Configuration
This system should work "out of the box", but there are settings that a
module builder may want to change.

The following constants in the main script: "eldo_inc_coins" control
all the configuration (shown with their default setting):

####    const int ELDO_FETCH_CURRENCIES_FROM_2DA = TRUE  
If set to true then currencies will be fetched from the currency.2da file.
As described above. Otherwise they have to be setup with Module local variables
or just left to have a single default currency.

#### const int ELDO_MAX_CURRENCIES = 50;
This is not actually the number of currencies allowed by the system as a whole but
rather the number of currencies that an individual merchant may deal in.
You'd be crazy to want more (but you must be since you play this ancient game).

#### const int ELDO_COIN_WEIGHT = TRUE;
#### const int ELDO_COINS_PER_POUND = 50;
These constants determine whether the weight system is used and what the weight
added for coins will be. The default matches the usual D&D weight.

#### const int ELDO_PURSE_IS_PICKPOCKETABLE = FALSE;
This flag sets whether the purse item can be stolen from a PC.

#### const string ELDO_COIN_TAG = "eldo_coin";
All coin items must have this tag so that the Tag Based scripting works.
If you change this then you must change the name of the script "eldo_coin.nss"
to match.

#### const string ELDO_COIN_STACK_TAG = "eldo_coin_stack";
The coin weight item must have this Tag. If you change this then you must
change the name of the script "eldo_coin_stack.nss" to match.

#### const string ELDO_COIN_STACK_RESREF = "eldo_coin_stack";
This is the ResRef of the coin weight item.

#### const string ELDO_PURSE_TAG = "eldo_purse";
This is the Tag of the purse item. If you change this, change the name of the script
"eldo_purse.nss" to match it.

#### const string ELDO_PURSE_RESREF = "eldo_purse";
This is the ResRef of the purse item used to hold a PC's coins.

#### const int ELDO_SET_HEARTBEAT_SCRIPT = TRUE;
#### const string ELDO_PC_HEARTBEAT_SCRIPT = "eldo_pc_hbeat";
#### const int ELDO_HB_COUNT = 0;
These control whether the heartbeat script is applied to the PC and which script is used.
Set this to FALSE if your module assigns it's own heartbeat script or if you
don't want the heartbeat functionality.
Without the heartbeat script any ordinary NWN gold picked up will stay with the
character until they visit a merchant. With it, whenever they have NWN gold it is
replaced with coins within one heartbeat (6 seconds).
ELDO_HB_COUNT will set the script to run less often. With this set to 1 the gold
will only be changed every 2 heartbeats. Set it higher if performance is an issue
and you have NWN gold being available in your module.

#### const int ELDO_CURRENCY_DEFAULT_VALUE0 = 1;    //CP
#### const int ELDO_CURRENCY_DEFAULT_VALUE1 = 10;   //SP
#### const int ELDO_CURRENCY_DEFAULT_VALUE2 = 50;   //EP
#### const int ELDO_CURRENCY_DEFAULT_VALUE3 = 100;  //GP
#### const int ELDO_CURRENCY_DEFAULT_VALUE4 = 1000; //PP
These set the value of the default currency if these are not found on the module.
They are by default set to normal D&D values.

## Ideas for Module Builders

Create coinage for ancient lost civilisations that can be found in deep dungeons.
No merchants will accept it but a goldsmith might melt the coins down so will pay
a reasonable sum for them. Or an ancient lich in a tomb runs a shop only using those coins.

Create racial coinage used by Elves, Dwarves and Halflings. Elven coins might be
wooden or certain leaves. Dwarves may use exotic metals.

Giants coins would be very heavy. Add the IncreasedWeight property to coins.

A money changer might offer written promissory notes for coins. This will help
rich characters with their load.

Gems and jewellery become useful items of exchange if they have no weight and high value compared to
coinage. Create a merchant that has a close to 100% buy price for these items.

Coins can be given magical properties. Wierd and wonderful stuff! (Buyer Beware!)

## Things To Do

I'm working on incorporation of these coins into the various NWN loot generation
systems. That will probably be a separate piece of work.

A version of this with premade currencies from Faerun.

A version of this with currencies for Eldoria.
https://rpggeek.com/rpgsetting/38750/eldoria

Merchants that don't have certain coins in a currency.
e.g. Not all traders will have access to Platinum pieces.

Varying rates of exchange between different currencies.

An expanded shop system for small cheap items and services.

## Contact
Dr Saturn aka Stuart Coyle - stuart.coyle@gmail.com

## Acknowledgements
This system is based on the one by David Douglas
https://neverwintervault.org/project/nwn1/hakpak/original-hakpak/pnp-coins-nwn
which itself was based on code from C.R.A.P.
Scripts have been rewritten from scratch.
Images, textures and models are from C.R.A.P.

## Revision History
0.1
  - Initial Release

0.2
  - Fix bug with heartbeat script referencing wrong variable.
  - Improve purse use message.
  - Add ELDO_HB_COUNT constant to rate-limit heartbeat.

0.3
  - Minor compilation fixes
  - Added treasure generation of coinage.
  - Fixed the demonstration moneychanger's dialog.
