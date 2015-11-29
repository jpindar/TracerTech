///////////////////////////
// rocket launcher v2.1   2015/11/29
// copyright Tracer Tech aka Tracer Ping 2014
// listens for commands on either a chat channel
// or a link message
////////////////////////////
#define NOTECARD_IN_THIS_PRIM
/////////////////////
#include "lib.lsl"
//integer debug = TRUE;
string sound = SOUND_ROCKETLAUNCH1;
list parameters = [15,3,12];//speed, flight time, bouyancy
//list parameters = [20,2,3];//speed, flight time, bouyancy
//speed typically 8 to 25 //15, 20
//payloadParam1, typ. flight time,  typically  1 to 10 , 2
//payloadParam2 typically bouyancy * 100, typically 3 to 12
integer payloadIndex = 0; 
float zOffset = 0.6;
float glowOnAmount = 0.0; //or 0.05
integer access = ACCESS_PUBLIC;
string preloadPrimName = "preloader";
integer preloadFace = 2;
key owner = "";
integer handle;
integer chatChan = UNKNOWN;
key id = "";

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
         chatChan = getChatChan(notecardList);
         owner = llGetOwner();
         //id  = owner;
         handle = llListen( chatChan, "",id, "" );
         llOwnerSay("listening on channel "+(string)chatChan);
      #endif
   }

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
   {
       msgHandler(owner, msg); 
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
   {
       //debugSay("got message " + msg + " on channel " + (string) chan);
       msgHandler(id, msg);
   }
}

//alas, this has to be after the default state
#include "readNotecardToList.lsl"

msgHandler(string sender, string msg)
{
   //if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
   //    return;
   //if ((access == ACCESS_GROUP) && (!llSameGroup(sender)))
   //   return;
   //debugSay("got message <" + msg +">");
   msg = llToLower(msg);
   if (msg == "fire")
   {
       fire();
   }
   else if (msg == "hide")
   {
       llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
   }
   else if (msg == "show")
   {
       llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
   }
}

fire()
{
   string rocket;
   integer packedParam;
   integer i;
   float speed;
   llPlaySound(sound,volume);
   repeatSound(sound,volume);
   integer n = llGetInventoryNumber(INVENTORY_OBJECT);
   rotation rot = llGetRot();
   speed = llList2Float(parameters,0);
   packedParam = llList2Integer(parameters, 1)+(llList2Integer(parameters,2)*256);
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot;
   for (i = 0; i<n; i++)
   {
       rocket = llGetInventoryName(INVENTORY_OBJECT,i);
       llRezAtRoot(rocket,pos,vel, rot, packedParam);
   }
}

