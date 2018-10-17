/*
* launch controller
* copyright Tracer Ping 2017
* this goes in the main prim
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
*rezzes and launches projectile from its inventory
*
*
*/
#define Version "3.1"
//#define DEBUG
#define TRACERGRID

//#define RAINBOW
//#define TRICOLOR
#define NOTECARD_IN_THIS_PRIM
//#define LAUNCH_ROT
//#define LAUNCH_ROT_90Y  // makes ring perp to flight axis
//#define SPINTRAILS
//#define SPARKBALL
//#define CANNON_BARREL

#include "LIB\lib.lsl"
#include "LIB\readNotecardToList.h"

//string texture = TEXTURE_NAUTICAL_STAR;
//string texture = TEXTURE_RAINBOWBURST;
//string texture = TEXTURE_CLASSIC;
//string texture = TEXTURE_SPIKESTAR;
string texture = TEXTURE1;


#if defined SPARKBALL
   string sound = SOUND_CRACKLE2; //3sec crackle
#else
  /// string sound = SOUND_ROCKETLAUNCH1;
  string sound = SOUND_WHOOSH001;
#endif

string color1;
string color2;
integer payloadIndex = 0;
#if defined CANNON_BARREL
   float zOffset = 1.5;
#else
float zOffset = 0.7; //0.7 to 2.0
#endif
float glowOnAmount = 0.0; //or 0.05
string preloadPrimName = "preloader";
integer preloadFace = 0;
integer firingFace = 2; //interior of tube
key owner;
integer handle;
integer chatChan;
integer rezChan;
key id = "";
integer explodeOnCollision = 0;
integer explodeOnLowVelocity = 0;
integer access;
string launchMsg;
list colors;
integer numOfBalls;
float speed;
integer flightTime;
float particleTime;
integer freezeOnBoom;
integer packedParam;
float angle = 0;
float launchDelay = 0.5;
integer code = 0;

#if defined STARTGLOW
float startGlow = STARTGLOW;
#else
float startGlow = 0.0;
#endif

#if defined ENDGLOW
float endGlow = ENDGLOW;
#else
float endGlow = 0.0;
#endif

#define bouyancy 50


msgHandler(string sender, string msg)
{
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
      return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      return;
      
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
   // launch message CSV format:
   //texture, color, color, color, particleTime , volume, startGlow, endGlow
   string rocket;
   integer i;

   rotation rot = llGetRot();
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot; //along the axis of the launcher

   #if defined LAUNCH_ROT
      rotation rot2 = rot;
      //rotation rot2 = llEuler2Rot(<0, 0, 0>) * rot; //putting the constant first means local rotation
   #elif defined LAUNCH_ROT_90Y
      rotation rot2 = llEuler2Rot(<0, PI_BY_TWO, 0>) * rot; //putting the constant first means local rotation
   #elif defined LAUNCH_ROT_ZERO
      rotation rot2 = <0.0,0.0,0.0,0.0>;
   #else // angle is in radians, either as initialized or read from notecard
      rotation rot2 = llEuler2Rot(<0,angle,0>) * rot;
   #endif

   for (i = 0; i<numOfBalls; i++)
   {
      llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,firingFace,1.0]);
      if (numOfBalls > 1)   //multiple monochrome balls aka rainbow?
      {
         string colorA = llList2String(colors,(i));
         launchMsg=texture+","+colorA+","+colorA+","+colorA;
         rocket = llGetInventoryName(INVENTORY_OBJECT,0);
      }else{  // i = 0
         string colorA = llList2String(colors,(i*3));
         string colorB = llList2String(colors,(i*3)+1);
         string colorC = llList2String(colors,(i*3)+2);
         launchMsg=texture+","+colorA+","+colorB+","+colorC;
         rocket = llGetInventoryName(INVENTORY_OBJECT,i);
      }
      launchMsg = launchMsg+","+(string)particleTime+","+(string)volume;
      launchMsg = launchMsg+","+(string)startGlow+","+(string)endGlow;

      rezChan = (integer) llFrand(255);
      integer packedParam2 = packedParam + (rezChan*0x4000);
      rezChan = -42000 -rezChan;  // the -42000 is arbitrary
      llPlaySound(sound,volume);
      repeatSound(sound,volume);
      llRezAtRoot(rocket,pos,vel, rot2, packedParam2);
      setGlow(LINK_THIS,0.0);
      llSleep(0.2);
      debugSay("launchMsg " + launchMsg);
      llRegionSay(rezChan, launchMsg);
      llSleep(launchDelay);
   }
}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change &( CHANGED_INVENTORY|CHANGED_SCALE)) llResetScript();}

   state_entry()
   {
      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;
      #endif
      chatChan = getChatChan(notecardList);
      owner = llGetOwner();
      volume = getVolume(notecardList);
      explodeOnCollision = getexplodeOnCollision(notecardList);
      explodeOnLowVelocity = getInteger(notecardList, "lowvelocity");
      access = getAccess(notecardList);
      //id  = owner;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
      #if defined DESCRIPTION
         llSetObjectDesc((string)chatChan+" "+Version+" "+DESCRIPTION);
      #endif
      //code = getInteger(notecardList,"code");

      numOfBalls = getInteger(notecardList,"balls");
      //debugSay((string)numOfBalls + " balls from notecard");
      if (numOfBalls < 1)
          numOfBalls =  llGetInventoryNumber(INVENTORY_OBJECT);
      #if defined RAINBOW
          numOfBalls = 6;
      #elif defined TRICOLOR
          numOfBalls = 3;
      #endif
      //debugSay((string)numOfBalls + " ball(s)");

      speed = getFloat(notecardList,"speed");
      flightTime = getInteger(notecardList,"flighttime");
      particleTime = getFloat(notecardList,"particletime");
      freezeOnBoom = getInteger(notecardList,"freeze");
      wind = getInteger(notecardList,"wind");
      angle = getInteger(notecardList, "angle") * DEG_TO_RAD;
      launchDelay = getFloat(notecardList, "delay");
      //startGlow = getFloat(notecardList, "startGlow");
      //endGlow = getFloat(notecardList, "endGlow");

      colors = colors + parseColor(notecardList,"color1");
      colors = colors + parseColor(notecardList,"color2");
      colors = colors + parseColor(notecardList,"color3");
      colors = colors + parseColor(notecardList,"color4");
      colors = colors + parseColor(notecardList,"color5");
      colors = colors + parseColor(notecardList,"color6");

      debugSay("[" + (string)colors + "]");
      // max int 0x80000000  (32 bits)
      //integer(<127) + integer (<=100, typically 50)
      // so     b    mmmmmmmm mmmmmmmm mmmbbbbb bfffffff
      //        h        0x10       00       00       00

      packedParam = (bouyancy<<7) + flightTime;
      #ifndef NO_FOLLOW_VELOCITY
         packedParam = packedParam | FOLLOW_VELOCITY_MASK; //0x2000 0000
         debugSay("follow velocity");
      #endif
      if (explodeOnLowVelocity >0)
         packedParam = packedParam | LOW_VELOCITY_MASK; //0x1000 0000
      if (explodeOnCollision >0)
         packedParam = packedParam | COLLISION_MASK;
      if (freezeOnBoom >0)
         packedParam = packedParam | FREEZE_MASK;
      if (wind >0)
         packedParam = packedParam | WIND_MASK;
      #if defined DEBUG
         packedParam = packedParam | DEBUG_MASK; // 0x0100 0000
      #endif

      llPreloadSound(sound);
      integer preloadLink = getLinkWithName(preloadPrimName);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER"))
         llSetLinkTexture(preloadLink,texture,preloadFace);
      vector v = llGetScale();
      zOffset = zOffset + ((float)v.z)/2 + 0.2;  //assuming ball diameter is 0.4
      if (zOffset > 10.0) //can't rez more than 10 m away
         zOffset = 9.0;
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
#include "LIB\readNotecardToList.lsl"

