int StartingConditional()
{
    int nResult = GetLocalString(GetPCSpeaker(), "FROM_CURRENCY") != "default";
    return nResult;
}
