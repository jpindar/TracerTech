/////////////////////
// Cannon x1.1
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the barrel
//////////////////////

/////////////////////
#include "lib.lsl"
integer debug = TRUE;

key sound = SOUND_ROCKETLAUNCH1;
key burstTexture = TEXTURE_SPIKESTAR;
string lightColor = COLOR_WHITE;
//key payload = "0e86ed9c-eaf9-4f75-8b6f-1956cb5d6436";
float speed = 30;  //8 to 20
integer payloadIndex = 0; 
integer payloadParam = 3;//typically time before explosion, typically  1 to 10 
integer payloadParam2 = 12; //typically bouyancy * 100, typically 3 to 12
float heightOffset = 0.6;

string preloadPrimName = "preloader";
integer preloadFace = 2;
//469014d2-c9f9-4908-bbfd-f73ab3eee343
integer chan = UNKNOWN;
float volume = 1.0;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
       llSay(0,"rebooting");
       //llPreloadSound(sound);
       //llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
       if(doneReadingNotecard == FALSE) state readNotecardToList;
       chan = getChatChan();
       volume = getVolume();
       speed = getSpeed();
       llOwnerSay((string)chan);
       llOwnerSay((string)volume);
   }

   touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,chan,"fire","");
        llOwnerSay("touched");
    }

    link_message(integer sender, integer channel, string message, key id)
    {
      if(channel==chan && message=="fire")
        {
            fire();
        }

    }

    timer()
    {
        //llMessageLinked(LINK_SET,(integer)llGetObjectDesc(),"fireworkreload","");
        llSetTimerEvent(0);
    }
}

//alas, this has to be after the default state
#include "readNotecardToList.lsl"

msgHandler(string sender, string msg)
{
   //debugSay("got message <" + msg +">");
   msg = llToLower(msg);
   if (msg == "fire")
   {
       fire();
   }
}

fire()
{
    string rocket;
    integer packedParam =  payloadParam + (payloadParam2*256);
    integer i;

    llPlaySound(sound,volume);
    repeatSound(sound,volume);
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    //llSetTimerEvent(10);
    rotation rot = llGetRot();
    vector pos = llGetPos();
    vector offset = llRot2Up(rot);
    pos = pos + offset;
    //    vector pos = llGetPos()+ (<0.0,0.0,heightOffset> * rot);
    vector vel = <0,0,speed>*rot;
    for (i = 0; i<n; i++)
    {
        rocket = llGetInventoryName(INVENTORY_OBJECT,i);
        llRezObject(rocket,pos,vel,rot, packedParam);
    }
}
