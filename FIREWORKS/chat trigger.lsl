//////////////////////////
// Tracer Tech
// sample chat trigger script
// reads channel from prim's description
/////////////////////////

integer channel;
key owner;
key toucher;

default
{
    touch_start(integer n)
    {
        owner=llGetOwner();
        toucher=llDetectedKey(0);
        channel = (integer)llGetObjectDesc();
        // if (toucher == owner) 
        //if (llSameGroup(toucher))
        llRegionSay(channel, "fire");    
    }

}

