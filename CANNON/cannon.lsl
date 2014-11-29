/////////////////////
// Cannon x1.1
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the barrel
//////////////////////
#define NOTECARD_IN_THIS_PRIM
/////////////////////
#include "lib.lsl"
integer debug = TRUE;
string sound = SOUND_PUREBOOM;
string smokeTexture;
string lightColor = COLOR_WHITE;
float speed = 30;  //8 to 20
integer flightTime = 3;//typically time before explosion, typically  1 to 10 
integer bouyancy = 5; //typically bouyancy * 100, typically 3 to 12
float pitch = 0;
integer payloadIndex = 0; 
float zOffset = 2.5;
string preloadPrimName = "preloader";
integer preloadFace = 2;
integer chatChan = UNKNOWN;

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
         volume = getVolume();
         speed = getSpeed();
         flightTime = getFlightTime();
         bouyancy = getBouyancy();
         pitch = getPitch();
         llOwnerSay("speed " + (string)speed);
         llOwnerSay("volume " + (string)volume);
         //chatChan = getChatChan();
         //handle = llListen( chatChan, "",id, "" );
         //llOwnerSay("listening on channel "+(string)chatChan);
      #endif
   }

   // touch_start(integer total_number)
   // {
   //     llMessageLinked(LINK_SET,FIRE_CMD,"whatever","");
   //     llOwnerSay("touched");
   // }

   link_message(integer sender, integer num, string msg, key id)
   {
      #if ndef NOTECARD_IN_THIS_PRIM
      if (num & RETURNING_NOTECARD_DATA)
      {
         notecardList = llCSV2List(msg);
         //chan = getChatChan();
         volume = getVolume();
         speed = getSpeed();
         bouyancy = getBouyancy();
         llOwnerSay((string)speed);
         llOwnerSay((string)volume);
      }
      #endif
      if ( num & FIRE_CMD ) //to allow for packing more data into num
      {
         fire();
      }
      else
      {
         msgHandler(llGetOwner(), msg);
      }
   }

    timer()
    {
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
   integer packedParam =  flightTime + (bouyancy*256);
   integer i;

   llPlaySound(sound,volume);
   repeatSound(sound,volume);
   integer n = llGetInventoryNumber(INVENTORY_OBJECT);
   rotation rot = llGetRot();
   //rez a distance along the the barrel axis
   vector pos = llGetPos() + (<0.0,0.0,zOffset> * rot); //postion = position + (vector * rotation)
   //rotate projectile and launch velocity away from barrel axis
   rot = (rot* llEuler2Rot( <0,pitch,0> * DEG_TO_RAD));
   vector vel = <0,0,speed>*rot;
   for (i = 0; i<n; i++)
   {
       rocket = llGetInventoryName(INVENTORY_OBJECT,i);
       llRezObject(rocket,pos,vel,rot, packedParam);
   }
}
