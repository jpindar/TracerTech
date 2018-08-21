/*
* Tracer Tech
* chat trigger script 1.3
* reads channel from the description of the prim
* that the script is in. So if you want to put multiple trigger
* scripts on different channels in the same object, you can.
*/
integer channel;
key owner;
key toucher;
integer access;


integer sameOwner(key id)
{
   return ( (id == owner) || (llGetOwnerKey(id) == owner) );
}


default
{
    touch_start(integer n)
    {
        owner=llGetOwner();
        toucher=llDetectedKey(0);
      
        // if (!sameOwner(toucher))
        //    return;

        //if (!llSameGroup(toucher))
        //    return;
      
        /* Contrary to it's name, llGetObjectDesc() gets the prim's
         * description, not the object's description
         * to get the object description, we could use the line below
         * but that's not what we typically want.
	 */ 
         //channel = (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC]), 0);

        channel = (integer)llGetObjectDesc();
        llRegionSay(channel, "fire");
    }

}

