//::///////////////////////////////////////////////
//:: iValenStage01
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Checks if Valen Romance is at first stage
*/
//:://////////////////////////////////////////////
//:: Created By: Drew Karpyshyn
//:: Created On: Oct. 14, 2003
//:://////////////////////////////////////////////

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(),"iValenStage")==1;
    return iResult;
}
