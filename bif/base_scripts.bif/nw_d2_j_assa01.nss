#include "nw_i0_plot"
#include "NW_J_ASSASSIN"

int StartingConditional()
{
    if (GetLocalInt(Global(),"NW_G_Assa_Plot") == 0)
    {
        if (!PCAcceptedPlot(GetPCSpeaker()))
        {
            return CheckCharismaHigh();
        }
    }
    return FALSE;
}

