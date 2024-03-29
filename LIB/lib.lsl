
/*
 *  lib.lsl    main library
 *
 */
#define LIBRARY_VERSION "2.0"

#ifndef LIB_H
  #include "libh.lsl"
#endif

#if defined TRACERGRID
   #define HYPERGRID
#endif

#ifndef DEBUGLEVEL
   #define DEBUGLEVEL 0
#endif
integer debug = DEBUGLEVEL;
float volume = 1.0;  // 0.0 = silent to 1.0 = full volume
float systemSafeSet = 0.00;//prevents erroneous particle emissions
list linknumberList;

debugSay(integer debugLevel, string msg)
{
   if (debug >= debugLevel)
      llOwnerSay(msg);
   //llSay(MY_DEBUG_CHAN,msg);
   //llShout(0,msg);
}

debugList(integer debugLevel, list values)
{
   if (debug >= debugLevel)
      llOwnerSay (llList2CSV (values));
}

integer assert(integer b, string s)
{
   if (b)
   {
      return TRUE;
   }
   else
   {
   debugSay(0,s);
   return FALSE;
   }
}

integer equals(float a,float b, float e)
{
 float d;
 d = llFabs(a-b);
 if (d<e)
   return TRUE;
 else
   return FALSE;
}

/* Convert a string containing a color name
 * to a string representing the color
 * in vector form.
 *
 * An error returns <0,0,0> because that's what
 * iwNameToColor() did.
 */
string nameToColor(string c)
{
#if defined INWORLDZ
   return (string)iwNameToColor(c);
#else
   if(c=="white") return "<1.00,1.00,1.00>";
   if(c=="black") return "<0.00,0.00,0.00>";
   if(c=="red")   return "<1.00,0.00,0.00>";
   if(c=="green")  return "<0.00,1.00,0.00>";
   if(c=="blue")   return "<0.00,0.00,1.00>";
   if(c=="gold")   return "<1.00,0.80,0.20>";
   if(c=="yellow") return "<1.00,1.00,0.00>";
   if(c=="orange") return "<1.00,0.50,0.00>";
   if(c=="purple") return "<1.00,0.00,1.00>";
   if(c=="darkgreen")  return "<0.00,0.80,0.20>";
   if(c=="hotpink")    return COLOR_HOTPINK;
   if(c=="bluepurple") return COLOR_BLUEPURPLE;
   if(c=="lightblue")  return COLOR_LIGHTBLUE;
   if(c=="brightblue")  return COLOR_BRIGHT_BLUE;
   if(c=="teal")  return COLOR_TEAL;
   if(c=="cyan")  return COLOR_CYAN;
   if(c=="pridered")  return COLOR_PRIDE_RED;
   if(c=="prideorange")  return COLOR_PRIDE_ORANGE;
   if(c=="prideyellow")  return COLOR_PRIDE_YELLOW;
   if(c=="pridegreen")  return COLOR_PRIDE_GREEN;
   if(c=="prideblue")  return COLOR_PRIDE_BLUE;
   if(c=="pridepurple")  return COLOR_PRIDE_PURPLE;
   if(c=="amber") return COLOR_AMBER;
   //usually non-colors should be black, but in some special cases
   //we may want to pass them through to be handled later
   if(llGetSubString(c,0,0) =="!")  return c;
   if(llGetSubString(c,-1,-1) =="!")  return c;
   return "<0.0,0.0,0.0>";
#endif
}

/*
   get a color name from a list based on a keyword
   if it isn't a string represntation of a color vector,
   use nameToColor() to make it one
 */
string parseColor(list n, string keyword)
{
   string color = getString(n,keyword);
   if (llSubStringIndex(color,"<")== -1)
       color = nameToColor(color);
   return color;
}


setRot(rotation rot)
{
   // llSetRot() has  a delay, this doesn't
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION,rot]);
}

setGlow(integer prim, float  amount)
{
   llSetLinkPrimitiveParamsFast(prim,[PRIM_GLOW,ALL_SIDES,amount]);
}

setFullbright(integer prim, integer on)
{
   llSetLinkPrimitiveParamsFast(prim,[PRIM_FULLBRIGHT,ALL_SIDES,on]);
}

setColor(integer prim, vector c, float alpha)
{
   llSetLinkPrimitiveParamsFast(prim,[PRIM_COLOR,ALL_SIDES,c,alpha]);
}

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

integer ownerChan()
{
   return (integer)("0xF" + llGetSubString(llGetOwner(),0,6));
}

repeatSound(key sound, float volume)
{
   llRegionSay(SOUND_REPEAT_CHAN, (string)sound + ":" + (string)volume);
   //llShout(SOUND_REPEAT_CHAN, (string)sound + ":" + (string)volume);
   //llSay(SOUND_REPEAT_CHAN, (string)sound + ":" + (string)volume);
   //llShout(0, (string)sound + ":" + (string)volume);
 }

debugSound(key sound, float volume)
{
   llRegionSay(SOUND_DEBUG_CHAN, (string)sound + ":" + (string)volume);
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


string getNotecardName(string d)
{
   string s = d;
   if (s == "")
      s = llGetInventoryName(INVENTORY_NOTECARD,0);
   //llOwnerSay("looking for notecard <" + s + ">");
   if (llGetInventoryType(s) == INVENTORY_NONE)
   {
      llOwnerSay("notecard '" + d + "' not found");
      s = "";
   }
   return s;
}


string getString(list notecardList, string name)
{
   string s;
   integer ptr = llListFindList(notecardList,[name]);
   if (ptr > -1)
       s = llList2String(notecardList,ptr+1);  //case sensitive, unfortunately
   return s;
}

float getFloat(list notecardList, string name, float defaultValue)
{
   float f = defaultValue;
   integer ptr = llListFindList(notecardList,[name]);
   if (ptr > -1)
      f = llList2Float(notecardList,ptr+1);  //case sensitive, unfortunately
   return f;
}

integer getInteger(list notecardList, string name, integer defaultValue)
{
   integer i = defaultValue;
   integer ptr = llListFindList(notecardList,[name]);
   if (ptr > -1)
       i = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return i;
}

float getAngle(list notecardList, string name, float defaultValue)
{
   float f = defaultValue;
   //name is case sensitive
   integer ptr = llListFindList(notecardList,[name]);
   if (ptr > -1)
   {
      f = llList2Integer(notecardList,ptr+1) * DEG_TO_RAD;
   }
   return f;
}

integer getChatChan(list notecardList)
{
   integer n = 0;
   integer ptr = llListFindList(notecardList,["channel"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getMenuMode(list notecardList)
{
   integer n = -1;
   integer ptr = llListFindList(notecardList,["menu"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getexplodeOnCollision(list notecardList)
{
   integer n = 0;
   integer ptr = llListFindList(notecardList,["collision"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   return n;
}

integer getAccess(list notecardList)
{
   integer n = ACCESS_PUBLIC;
   integer ptr = llListFindList(notecardList,["access"]);
   if (ptr > -1)
       n = llList2Integer(notecardList,ptr+1);  //case sensitive, unfortunately
   else
       n = -1;
   return n;
}

float getVolume(list notecardList)
{
    float f = 1.0;
    integer ptr = llListFindList(notecardList,["volume"]);
    if (ptr > -1)
        f = llList2Float(notecardList,ptr+1);
    return f;
}

float getDelay(list notecardList)
{
    #define DEFAULT_DELAY 20.0;
    float f = DEFAULT_DELAY;
    integer ptr = llListFindList(notecardList,["delay"]);
    if (ptr > -1)
        f = llList2Float(notecardList,ptr+1);
    return f;
}

integer getFlightTime()
{
    #define DEFAULT_TIME 3;
    integer f = DEFAULT_TIME;
    integer ptr = llListFindList(notecardList,["flighttime"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

integer getBouyancy()
{
    #define DEFAULT_BOUY 5;
    integer f = DEFAULT_BOUY;
    integer ptr = llListFindList(notecardList,["bouyancy"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

integer getPitch()
{
    #define DEFAULT_PITCH 0;
    integer f = DEFAULT_PITCH;
    integer ptr = llListFindList(notecardList,["pitch"]);
    if (ptr > -1)
        f = llList2Integer(notecardList,ptr+1);
    return f;
}

#ifdef INWORLDZ
integer getLinkWithName(string name) {
   list foo = iwSearchLinksByName(name,IW_MATCH_EQUAL,TRUE);
   return llList2Integer(foo, 0);
}
#else
integer getLinkWithName(string name) {
    integer i = llGetLinkNumber() != 0;   // Start at zero (single prim) or 1 (two or more prims)
    integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
    for (; i < x; ++i)
        if (llGetLinkName(i) == name)
        {
            return i; // Found it! Exit loop early with result
         }
    return -1; // No prim with that name, return -1.
}
/*
integer getLinkWithName(string name) {
   //list foo = iwSearchLinksByName(name,IW_MATCH_EQUAL,TRUE);
   //return llList2Integer(foo, 0);
   if (name == "preloader")
       return 2;
	else
       return 0;
}
*/
#endif

list getLinknumberList()
    {
	linknumberList = [];
    integer i = llGetLinkNumber() != 0;   // Start at zero (single prim) or 1 (two or more prims)
    integer x = llGetNumberOfPrims() + i; // [0, 1) or [1, llGetNumberOfPrims()]
    for (; i < x; ++i)
    {
         linknumberList = linknumberList + llGetLinkName(i) + i;
    }
    return linknumberList;
}

integer getLinknumber(string name)
{
    integer n;
    integer ptr = llListFindList(linknumberList,(list)name);
    if (ptr > -1)
        n = llList2Integer(linknumberList,ptr+1);
    return n;
}

list getLinknumbers(list names)
{
#ifdef  INWORLDZ
    integer i;
    list result;
    string name;
    integer len = llGetListLength( names);
    for (i=0; i<len;i++)
    {
        name = llList2String(names,i);
        result += iwSearchLinksByName(name,IW_MATCH_EQUAL,TRUE);
        //llOwnerSay(name);
        //llOwnerSay(llDumpList2String(result, "|"));
    }
    return result;
#else
    integer i;
    list result;
    getLinknumberList();
    integer len = llGetListLength( names);
    for (i=0; i<len;i++)
    {
        result = result + getLinknumber(llList2String(names,i));
    }
    return result;
    /*
    integer i;
    list result;
    string name;
    integer len = llGetListLength( names);
    for (i=0; i<len;i++)
    {
        name = llList2String(names,i);
        result += iwSearchLinksByName(name,IW_MATCH_EQUAL,TRUE);
        //llOwnerSay(name);
        //llOwnerSay(llDumpList2String(result, "|"));
    }
    return result;
    */
#endif
}

//use this in a touch_start event
integer touchedByOwner()
{
return (llDetectedKey(0) == llGetOwner());
}

clearHoverText()
{
   llSetText("",<0,0,0>,0.0);
}

string descOfTouchedPrim()
{
    integer prim = llDetectedLinkNumber(0);
    list l=llGetLinkPrimitiveParams(prim,[PRIM_DESC]);
    string s = llList2String(l,0);
    return s;
}

setAllPrimParams()
{
    //link numbering in linksets starts with 1
    integer link_idx;
    integer link_qty = llGetNumberOfPrims();
    if (link_qty > 1)
    {
        for (link_idx=1; link_idx <= link_qty; link_idx++)
        {
            //desc =  (string)llGetLinkPrimitiveParams(link_idx,[PRIM_DESC]);
			//updateThisPrim(link_idx);
        }
    }
}

string getTextureFromInventory(integer n)
  {
      string name = llGetInventoryName(INVENTORY_TEXTURE, n);
      if (name)
         {
            key uuid = llGetInventoryKey(name);
            if (uuid)
               return (string)uuid;
            else
               return "";
         }
      return "";
   }

/*
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
            }
			else
            {
                integer lold = (integer)d;
                if((string)lold == d)
				    out += lold;
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
*/

string XDIGITS = "0123456789abcdef"; // could be "0123456789ABCDEF"

string hexes(integer bits)
{
    string nybbles = "";
    while (bits)
    {
        integer lsn = bits & 0xF; // least significant nybble
        string nybble = llGetSubString(XDIGITS, lsn, lsn);
        nybbles = nybble + nybbles;
        bits = bits >> 4; // discard the least significant bits at right
        bits = bits & 0xfffFFFF; // discard the sign bits at left
    }
    return nybbles;
}

string hex(integer value)
{
    if (value < 0)
    {
        return "-0x" + hexes(-value);
    }
    else if (value == 0)
    {
        return "0x0"; // hexes(value) == "" when (value == 0)
    }
    else // if (0 < value)
    {
        return "0x" + hexes(value);
    }
}


