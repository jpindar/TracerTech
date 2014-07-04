//////////////////////////
// Tracer Tech
// sample chat trigger script
// reads channel from prim's description
// or object's description
/////////////////////////
integer channel;

default
{
    touch_start(integer n)
    {
	    //channel = (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC]), 0);
        channel = (integer)llGetObjectDesc();
        llRegionSay(channel, "fire");    
    }

}