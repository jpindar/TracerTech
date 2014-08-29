///////////////////////////
// rocket launcher v2.0   2014/8/30
//copyright Tracer Tech aka Tracer Ping 2014
// listens for commands on either a chat channel
// or a link message
////////////////////////////
#include "lib.lsl"
string sound = SOUND_ROCKETLAUNCH1;
float speed = 15;  //8 to 25 // 20
integer payloadIndex = 0; 
integer payloadParam = 3;//typically time before explosion, typically  1 to 10 
integer payloadParam2 = 12; //typically bouyancy * 100, typically 3 to 12
float heightOffset = 0.6;
float glowAmount = 0.0; //or 0.05
string preloadPrimName = "preloader";
integer preloadFace = 2;
key owner;
integer handle;
integer chatChan = UNKNOWN;
key id = "";
integer delay = 1;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
      if(doneReadingNotecard == FALSE) state readNotecardToList;
      chatChan = getChatChan();
      owner = llGetOwner();
      //id  = owner;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   //link mmessages come from the menu script
   link_message(integer sender, integer num, string str, key id)
   {
       //debugSay("heard link message " + (string)num + str);
       msgHandler(owner, str); 
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
   integer packedParam =  payloadParam + (payloadParam2*256);
   integer i;

   llTriggerSound(sound,volume);
   repeatSound(sound, volume);
   integer n = llGetInventoryNumber(INVENTORY_OBJECT);
   rotation rot = llGetRot();
   vector pos = llGetPos()+ (<0.0,0.0,heightOffset> * rot);
   vector vel = <0,0,speed> * rot;
   //rot.z = -rot.z;
   //rot.x = -rot.x;
   for (i = 0; i<n; i++)
   {
       rocket = llGetInventoryName(INVENTORY_OBJECT,i);
       llRezAtRoot(rocket,pos,vel, rot, packedParam);
   }
}

