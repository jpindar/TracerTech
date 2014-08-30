/////////////////////
// Cannon x1.1
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the barrel
//////////////////////
#define NOTECARD_IN_THIS_PRIM
/////////////////////
#include "lib.lsl"
integer debug = TRUE;

key sound = SOUND_ROCKETLAUNCH1;
key burstTexture = TEXTURE_SPIKESTAR;
string lightColor = COLOR_WHITE;
//key payload = "0e86ed9c-eaf9-4f75-8b6f-1956cb5d6436";
float speed = 30;  //8 to 20
integer payloadIndex = 0; 
integer payloadParam1 = 3;//typically time before explosion, typically  1 to 10 
integer payloadParam2 = 5; //typically bouyancy * 100, typically 3 to 12
float zOffset = 0.6;

string preloadPrimName = "preloader";
integer preloadFace = 2;
//469014d2-c9f9-4908-bbfd-f73ab3eee343
integer chan = UNKNOWN;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
       //llPreloadSound(sound);
       //llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
       #ifdef NOTECARD_IN_THIS_PRIM
           if(doneReadingNotecard == FALSE) state readNotecardToList;
           //chan = getChatChan();
           volume = getVolume();
           speed = getSpeed();
           payloadParam2 = getBouyancy();
           llOwnerSay("speed " + (string)speed);
           llOwnerSay("volume " + (string)volume);
       #endif
   }

   // touch_start(integer total_number)
   // {
   //     llMessageLinked(LINK_SET,FIRE_CMD,"whatever","");
   //     llOwnerSay("touched");
   // }

    link_message(integer sender, integer num, string msg, key id)
    {
        if (num & RETURNING_NOTECARD_DATA)
        {
            notecardList = llCSV2List(msg);
            //chan = getChatChan();
            volume = getVolume();
            speed = getSpeed();
            payloadParam2 = getBouyancy();
            llOwnerSay((string)speed);
            llOwnerSay((string)volume);
       }
        if ( num & FIRE_CMD ) //to allow for packing more data into num
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
    integer packedParam =  payloadParam1 + (payloadParam2*256);
    integer i;
    float pitch = 0;

    llPlaySound(sound,volume);
    repeatSound(sound,volume);
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    //llSetTimerEvent(10);
    rotation rot = llGetRot();
    vector pos = llGetPos();
    //rez a distance along the the barrel axis
    //pos = pos + llRot2Up(rot);// postion + unit? vector offset
    pos = pos + (<0.0,0.0,zOffset> * rot); //postion = position + (vector * rotation)

    //rotate projectile and launch velocity away from barrel axis
    rot = (rot* llEuler2Rot( <0,pitch,0> * DEG_TO_RAD));
    vector vel = <0,0,speed>*rot;
    for (i = 0; i<n; i++)
    {
        rocket = llGetInventoryName(INVENTORY_OBJECT,i);
        llRezObject(rocket,pos,vel,rot, packedParam);
    }
}
