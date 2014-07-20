
#ifndef LIB_H
  #include "libh.lsl"
#endif

#define GLOW_ON llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0])
#define GLOW_OFF llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0])

integer sameOwner(key id)
{
if (id == llGetOwner())
  return TRUE;
else if (llGetOwnerKey(id) == llGetOwner())
  return TRUE;
else 
  return FALSE;  
}

integer randomChan()
{
   return (integer)(llFrand(-1000000000.0) - 1000000000.0);
}

repeatSound(key sound, float volume)
{
    llRegionSay(SOUND_REPEAT_CHAN, (string)sound + ":" + (string)volume);
}

debugSay(string msg)
{
//if (debug)
//   llOwnerSay(msg);
   llSay(MY_DEBUG_CHAN,msg);
}

integer objectDescToInt()
{
   return (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC ]), 0);
}  

setObjectDesc(string s)
{ //there is a good reason not to use llSetLinkPrimitiveParamsFast here
    llSetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC,s]);
}
	
playInventorySound()
{
   llPlaySound(llGetInventoryName(INVENTORY_SOUND,0),1);
}

string getInventoryTexture()
{
    return llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
}

list mergeLists(list newList, list oldList)
{
  integer length;
  list keyword;
  list value;
  integer ptr;
  integer i;
  list subList;      
  length = llGetListLength(newList);  
  for (i=0; i<length; i=i+2)
  {
      subList = llList2List(newList,i,i+1);
      subList = list_cast(subList);
      // llSay(0, llList2CSV(subList));
      keyword = llList2List(subList,0,0); 
      value = llList2List(subList,1,1);  

      //llSay(0, llList2CSV(key1));
      ptr = llListFindList(oldList,keyword);  //case sensitive, unfortunately
      //if (ptr != -1)//llSay(0,(string)ptr);
      oldList = llListReplaceList(oldList,subList,ptr, ptr+1);
   }
   return oldList;
}
   
//This function typecasts a list of strings, into the types they appear to be. 
//Extremely useful for feeding user data into llSetPrimitiveParams
//It takes a list as an input, and returns that list, with all elements correctly typecast, as output
//Written by Fractured Crystal, 27 Jan 2010, Commissioned by WarKirby Magojiro, this function is Public Domain
list list_cast(list in)
{
    list out;
    integer i = 0;
    integer l= llGetListLength(in);
    while(i < l)
    {
        string d= llStringTrim(llList2String(in,i),STRING_TRIM);
        if(d == "")
	    out += "";
        else
        {
            if(llGetSubString(d,0,0) == "<")
            {
                if(llGetSubString(d,-1,-1) == ">")
                {
                    list s = llParseString2List(d,[","],[]);
                    integer sl= llGetListLength(s);
                    if(sl == 3)
                    {
                        out += (vector)d;
                        //jump end;
                    }else if(sl == 4)
                    {
                        out += (rotation)d;
                        //jump end;
                    }
                }
                //either malformed,or identified
                jump end;
            }
            if(llSubStringIndex(d,".") != -1)
            {
                out += (float)d;
            }else
            {
                integer lold = (integer)d;
                if((string)lold == d)out += lold;
                else
                {
                    key kold = (key)d;
                    if(kold)out += [kold];
                    else out += [d];
                }
            }
        }
        @end;
        i += 1;
    }
 
    return out;   
 }  
   
