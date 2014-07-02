

#define MY_DEBUG_CHAN 557
#define SOUND_REPEAT_CHAN 556

#define PUBLIC 0
#define GROUP 1
#define OWNER 2

#define TEXTURE_CLASSIC "6189b78f-c7e2-4508-9aa2-0881772c7e27"
//string TEXTURE_CLASSIC = "6189b78f-c7e2-4508-9aa2-0881772c7e27";//"classic", also standard fountain texture

//these colors must be strings in thi exact format 
//because I don't want to bother writing a message parser
#define COLOR_WHITE "<1.00,1.00,1.00>"
#define COLOR_BLACK "<0.00,0.00,0.00>"
#define COLOR_RED "<1.00,0.00,0.00>"
#define COLOR_GREEN "<0.00,1.00,0.00>"
#define COLOR_BLUE "<0.00,0.00,1.00>"
#define COLOR_GOLD "<1.00,0.80,0.20>"
#define COLOR_3 "<0.00,0.80,0.20>"

#define SOUND_ROCKETLAUNCH1 "0718a9e6-4632-48f2-af66-664196d7597d"
#define SOUND_FOUNTAIN1 "1339a082-66bb-4d4b-965a-c3f13da18492"
#define SOUND_CLICK1 "0f76aca8-101c-48db-998c-6018faf14b62"
#define SOUND_BURST1 "a2b1025e-1c8a-4dfb-8868-c14a8bed8116"

float VOLUME = 1.0;  // 0.0 = silent to 1.0 = full volume
integer FIRE_CMD = 1;


integer randomChan()
{
   return (integer)(llFrand(-1000000000.0) - 1000000000.0);
}

repeatSound(key soundKey)
{
    //integer soundChan = 556;
    llRegionSay(SOUND_REPEAT_CHAN, soundKey);
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


