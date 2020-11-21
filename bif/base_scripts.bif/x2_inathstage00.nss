//::///////////////////////////////////////////////
//:: iNathyrraStage01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Checks if Nathyrra Romance is not started
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iNathyrraStage")==0;
    return iResult;
}


