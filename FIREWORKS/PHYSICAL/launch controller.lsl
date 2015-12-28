/*
* launch controller v2.2   2015/12/05
* copyright Tracer Ping 2015
* this goes in the main prim
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
*rezzes and launches projectile from its inventory
*
*
*/
#define NOTECARD_IN_THIS_PRIM
#include "lib.lsl"

list parameters = [17,19,12];//speed, flight time, bouyancy
//list parameters = [30,30,12];//speed, flight time, bouyancy
//list parameters = [20,2,3];//speed, flight time, bouyancy
//speed typically 8 to 25 //15, 20
//payloadParam1, typ. flight time*10,  typically  10 to 20
//payloadParam2 typically bouyancy * 100, typically 3 to 12
integer payloadIndex = 0; 
float zOffset = 0.6;
string sound = SOUND_ROCKETLAUNCH1;
string preloadPrimName = "preloader";
integer preloadFace = 2;
key owner;
integer handle;
integer chatChan = UNKNOWN;
key id = "";
integer explodeOnCollision = 0;
integer access;

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
         volume = getVolume();
         explodeOnCollision = getexplodeOnCollision(notecardList);
         access = getAccess(notecardList);
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

//this has to be after the default state
#include "readNotecardToList.lsl"

msgHandler(string sender, string msg)
{
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
      return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      return;
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
   //uncomment next line to make payload say debug messages
   //packedParam = packedParam | DEBUG_MASK;
   #if defined EXPLODE_ON_COLLISION
   if (explodeOnCollision >0)
      packedParam = packedParam | COLLISION_MASK;
   #endif
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot;
   for (i = 0; i<n; i++)
   {
       rocket = llGetInventoryName(INVENTORY_OBJECT,i);
       llRezAtRoot(rocket,pos,vel, rot, packedParam);
   }
}
