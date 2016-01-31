/*
* launch controller v2.4   2015/12/25
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
//#define LAUNCH_ROT
//#define SPINTRAILS
#include "lib.lsl"
string texture = TEXTURE_CLASSIC;
string color1 = COLOR_GOLD;
string color2 = COLOR_BLUE;

#if defined SPARKBALL
   list parameters = [24,1,0];//speed, flight time, bouyancy
#elif defined SPINTRAILS
   //list parameters = [20,2,3];//speed, flight time, bouyancy
   list parameters = [14,2,4];//speed, flight time, bouyancy
#else
   list parameters = [17,19,12];//speed, flight time, bouyancy
#endif
//list parameters = [15,10,60];//speed, flight time, bouyancy
//list parameters = [12,14,75];//speed, flight time, bouyancy
//list parameters = [30,30,12];//speed, flight time, bouyancy
//list parameters = [20,2,3];//speed, flight time, bouyancy
//speed typically 8 to 25 //15, 20
//payloadParam1, typ. flight time*10,  typically  10 to 20
//payloadParam2 typically bouyancy * 100, typically 3 to 12

integer payloadIndex = 0;
float zOffset = 0.7;
float glowOnAmount = 0.0; //or 0.05
#if defined SPARKBALL
   string sound = SOUND_CRACKLE2; //3sec crackle
#else
   string sound = SOUND_ROCKETLAUNCH1;
#endif
string preloadPrimName = "preloader";
integer preloadFace = 2;
key owner;
integer handle;
integer chatChan;
integer rezChan;
key id = "";
integer explodeOnCollision = 0;
integer access;
string launchMsg; 
integer numOfBalls;
float speed;
integer flightTime;
integer bouyancy; 
integer packedParam;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change &( CHANGED_INVENTORY|CHANGED_SCALE)) llResetScript();}

   state_entry()
   {
      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;
         chatChan = getChatChan(notecardList);
         owner = llGetOwner();
         volume = getVolume(notecardList);
         explodeOnCollision = getexplodeOnCollision(notecardList);
         access = getAccess(notecardList);
         //id  = owner;
         handle = llListen( chatChan, "",id, "" );
         llOwnerSay("listening on channel "+(string)chatChan);
         launchMsg = texture + "," + color1 + "," + color2; 
      #endif
      numOfBalls = llGetInventoryNumber(INVENTORY_OBJECT);
      speed = llList2Float(parameters,0);
      flightTime = llList2Integer(parameters, 1)
      bouyancy = llList2Integer(parameters,2)
       packedParam = flightTime+(bouyancy<<8);
      //uncomment next line to make payload say debug messages
      //packedParam = packedParam | DEBUG_MASK;
      #if defined EXPLODE_ON_COLLISION
      if (explodeOnCollision >0)
         packedParam = packedParam | COLLISION_MASK;
     #endif

      //llPreloadSound(sound);
      //llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
      vector v = llGetScale();
      zOffset = ((float)v.z)/2 + 0.2;  //assuming ball diameter is 0.4
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
   integer i;
   llPlaySound(sound,volume);
   repeatSound(sound,volume);
   rotation rot = llGetRot();
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot;
   #if defined LAUNCH_ROT
     rotation rot2 = rot;
   #else
      rotation rot2 = <0.0,0.0,0.0,0.0>;
   #endif
   for (i = 0; i<numOfBalls; i++)
   {
      rezChan = (integer) llFrand(255);
      integer packedParam2 = packedParam + (rezChan*0x4000);
      rezChan = -42000 -rezChan;
      rocket = llGetInventoryName(INVENTORY_OBJECT,i);
      llRezAtRoot(rocket,pos,vel, rot2, packedParam2);
       llSay(rezChan, launchMsg);
   }
}

