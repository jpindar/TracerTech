/*
* dance bracelet v1.0
*Tracer Ping July 2016
*/
#include "lib.lsl"


default
{
    on_rez(integer n){llResetScript();}
    changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

    state_entry()
    {
       if(doneReadingNotecard == FALSE) state readNotecardToList;
    }
}

//this has to be after the default state
#include "readNotecardToList.lsl"
