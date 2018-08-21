/*
* Tracer Tech
* chat trigger script 1.4
* reads channel from the description of the prim
* that the script is in. So if you want to put multiple trigger
* scripts on different channels in the same object, you can.
*/
integer channel;
key owner;
key toucher;
integer access;

/* If you want to use the description of the whole object, not the prim 
 * containing the script, uncomment the following line.
 */
//#define USE_ROOT_DESC

/*
 * If you want the trigger to be owner only, uncomment the folowing line
 */
//#define OWNER_ONLY


/*
 * If you want the trigger to be group only, uncomment the folowing line
 */
//#define GROUP_ONLY


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
      
        #if defined OWNER_ONLY
          if (!sameOwner(toucher))
            return;
        #endif
       
        #if defined GROUP_ONLY
           if (!llSameGroup(toucher))
              return;
        #endif
        
        /* Contrary to it's name, llGetObjectDesc() gets the prim's
        * description, not the object's description
        * to get the object description, we could use the line below
        * but that's not what we typically want.
        */
        #if defined USE_ROOT_DESC 
        channel = (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC]), 0);
        #else
        channel = (integer)llGetObjectDesc();
        #endif
        llOwnerSay((string)channel);
        llRegionSay(channel, "fire");
    }

}

