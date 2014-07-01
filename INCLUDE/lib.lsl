

integer MY_DEBUG_CHAN = 557;

integer PUBLIC = 0;
integer GROUP = 1;
integer OWNER = 2;

string TEXTURE_CLASSIC = "6189b78f-c7e2-4508-9aa2-0881772c7e27";//"classic", also standard fountain texture

vector COLOR_RED = <1.0, 0.0, 0.0>;
vector COLOR_GOLD = <1.0, 0.8, 0.2>;
vector COLOR_3 = <0.0, 0.8, 0.2>;
vector COLOR_BLUE = <0.0, 0.0, 1.0>;

float VOLUME = 1.0;  // 0.0 = silent to 1.0 = full volume
integer FIRE_CMD = 1;


integer randomChan()
{
   return (integer)(llFrand(-1000000000.0) - 1000000000.0);
}

repeatSound(key soundKey)
{
    integer soundChan = 556;
    llRegionSay(soundChan, soundKey);
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


