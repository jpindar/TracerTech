/*
* launch controller v2.7.6
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
#define DEBUG
#define TRACERGRID
//#define RAINBOW
//#define TRICOLOR
#define NOTECARD_IN_THIS_PRIM
//#define LAUNCH_ROT
//#define LAUNCH_ROT_90Y
//#define SPINTRAILS
//#define SPARKBALL
#include "lib.lsl"
//string texture = TEXTURE_NAUTICAL_STAR;
//string texture = TEXTURE_RAINBOWBURST;
//string texture = TEXTURE_CLASSIC;
string texture = TEXTURE_SPIKESTAR;
#if defined SPARKBALL
   string sound = SOUND_CRACKLE2; //3sec crackle
#else
  /// string sound = SOUND_ROCKETLAUNCH1;
  string sound = SOUND_WHOOSH001;
#endif

string color1;
string color2;
integer payloadIndex = 0;
float zOffset = 0.7; //0.7 to 2.0
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
integer access;
string launchMsg;
list colors;
integer numOfBalls = 0;
float speed;
integer flightTime;
integer bouyancy;
float particleTime;
integer freezeOnBoom;
integer packedParam;
float angle = 0;
float launchDelay = 0.5;
integer code = 0;


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

   #if defined DEBUG
      packedParam = packedParam | DEBUG_MASK;
   #endif
   rotation rot = llGetRot();
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot; //along the axis of the launcher

   // NORMAL CASE
   //angle = 90 * DEG_TO_RAD;  //90 degrees =  PI_BY_TWO radians
   rotation rot2 = llEuler2Rot(<0,angle,0>) * rot;

   #if defined LAUNCH_ROT
      rotation rot2 = rot;
      //rotation rot2 = llEuler2Rot(<0, 0, 0>) * rot; //putting the constant first means local rotation
   #elif defined LAUNCH_ROT_90Y
      rotation rot2 = llEuler2Rot(<0, PI_BY_TWO, 0>) * rot; //putting the constant first means local rotation
   #elif defined LAUNCH_ROT_ZERO
      rotation rot2 = <0.0,0.0,0.0,0.0>;
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
      rezChan = (integer) llFrand(255);
      integer packedParam2 = packedParam + (rezChan*0x4000);
      rezChan = -42000 -rezChan;
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
      access = getAccess(notecardList);
      //id  = owner;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
      //code = getInteger(notecardList,"code");

      numOfBalls = getInteger(notecardList,"balls");
      debugSay((string)numOfBalls + " balls from notecard");
      if (numOfBalls < 1)
          numOfBalls =  llGetInventoryNumber(INVENTORY_OBJECT);
      #if defined RAINBOW
          numOfBalls = 6;
      #elif defined TRICOLOR
          numOfBalls = 3;
      #endif
      debugSay((string)numOfBalls + " balls");

      speed = getFloat(notecardList,"speed");
      flightTime = getInteger(notecardList,"flighttime");
      bouyancy = getInteger(notecardList,"bouyancy");
      particleTime = getFloat(notecardList,"particletime");
      freezeOnBoom = getInteger(notecardList,"freeze");
      wind = getInteger(notecardList,"wind");
      angle = getInteger(notecardList, "angle") * DEG_TO_RAD;
      launchDelay = getFloat(notecardList, "delay");
      colors = colors + parseColor(notecardList,"color1");
      colors = colors + parseColor(notecardList,"color2");
      colors = colors + parseColor(notecardList,"color3");
      colors = colors + parseColor(notecardList,"color4");
      colors = colors + parseColor(notecardList,"color5");
      colors = colors + parseColor(notecardList,"color6");
      debugSay("[" + (string)colors + "]");
      packedParam = flightTime+(bouyancy<<7);
      if (explodeOnCollision >0)
         packedParam = packedParam | COLLISION_MASK;
      if (freezeOnBoom >0)
         packedParam = packedParam | FREEZE_MASK;
      if (wind >0)
         packedParam = packedParam | WIND_MASK;
      //uncomment next line to make payload say debug messages
      //packedParam = packedParam | DEBUG_MASK;

      llPreloadSound(sound);
      integer preloadLink = getLinkWithName(preloadPrimName);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER");
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
#include "readNotecardToList.lsl"

