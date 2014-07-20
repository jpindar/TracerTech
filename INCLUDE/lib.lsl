
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
  integer ptr;
  integer i;
  list subList;      
  length = llGetListLength(newList);  
  for (i=0; i<length; i=i+2)
  {
      subList = llList2List(newList,i,i+1);
      // llSay(0, llList2CSV(subList));
      keyword = llList2List(subList,0,0);  // 
      //llSay(0, llList2CSV(key1));
      ptr = llListFindList(oldList,keyword);  //case sensitive, unfortunately
      //if (ptr != -1)//llSay(0,(string)ptr);
      oldList = llListReplaceList(oldList,subList,ptr, ptr+1);
   }
   return oldList;
}
   
   
   
   
