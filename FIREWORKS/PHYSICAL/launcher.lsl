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
#define VERSION "3.6.1"

//#define TRICOLOR
//#define LAUNCH_ROT
//#define LAUNCH_ROT_90Y  // makes ring perp to flight axis
//#define SPINTRAILS
//#define SPARKBALL
//#define CANNON_BARREL

#include "LIB\lib.lsl"
#include "LIB\readNotecardToList.h"


string texture = TEXTURE1;



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
string muzzlePrimName = "muzzle";
integer muzzleLink;
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
float speed = 1.0;
integer flightTime;
integer freezeOnBoom;
integer packedParam;
float angle = 0;
integer code = 0;

#if defined LAUNCHDELAY
float launchDelay = LAUNCHDELAY;
#else
float launchDelay = 0.5;
#endif

#if defined BEGINANGLE
float beginAngle = BEGINANGLE;
#elif defined STARTANGLE
float beginAngle = STARTANGLE;
#else
float beginAngle = 0;
#endif

#if defined ENDANGLE
float endAngle = ENDANGLE;
#else
float endAngle = PI;
#endif


#if defined SYSTEMAGE
float systemAge = SYSTEMAGE;
#else
float systemAge = 1.0;
#endif

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

#if defined STARTALPHA
float startAlpha = STARTALPHA;
#else
float startAlpha = 1.0;
#endif

#if defined ENDALPHA
float endAlpha = ENDALPHA;
#else
float endAlpha = 1.0;
#endif

#ifdef PARTAGE
  float partAge = PARTAGE;
#else
  float partAge = 1;
#endif

#ifdef BURSTRATE
  float burstRate = BURSTRATE;
#else
  float burstRate = 0.1;
#endif


#ifdef BURSTRADIUS
  float burstRadius = BURSTRADIUS;
#else
  float burstRadius = 1;
#endif

#if defined STARTSCALE
vector startScale = STARTSCALE;
#else
vector startScale = <1.0,1.0,0.0>;
#endif

#if defined ENDSCALE
vector  endScale = ENDSCALE;
#else
vector  endScale = <1.0,1.0,0.0>;
#endif

#ifdef PARTCOUNT
  integer partCount = PARTCOUNT;
#else
  integer partCount = 2;
#endif

#ifdef PARTOMEGA
   vector partOmega = PARTOMEGA;
#elif defined PARTOMEGA_REL
   vector partOmega = PARTOMEGA_REL;
#elif defined PARTOMEGA_ABS
   vector partOmega = PARTOMEGA_ABS;
#else
   vector partOmega = <0.0,0.0,0.0>;
#endif

#if defined MAXPARTSPEED
   float maxPartSpeed = MAXPARTSPEED;
#else
   float maxPartSpeed = 1.0;
#endif

#if defined MINPARTSPEED
   float minPartSpeed = MINPARTSPEED;
#else
   float minPartSpeed = 1.0;
#endif


#define NOTECARD_IN_THIS_PRIM


/*  handle messages from the menu script
 */
msgHandler(string sender, string msg)
{
   debugSay(3,"got message " + msg + " from "+ (string)sender);
   //allow sameOwner so message can be from a trigger owned by our owner
   if (!sameOwner(sender)) 
   {
      if (access == ACCESS_OWNER)
      {
         llSay(0,"sorry, access is set to owner-only");
         return;
      }
      //if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      if ((access == ACCESS_GROUP) && (!llSameGroup(sender) ))
      {
         llSay(0,"sorry, access is set to group-only");
         return;
      }
   }
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
   vector muzzleColor = (vector)COLOR_GOLD;
   float muzzleGlow = 1.0;
   integer muzzleFace = ALL_SIDES;
   string rocket;
   integer i;

   rotation rot = llGetRot();
   //rez a distance along the the barrel axis
   vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
   vector vel = <0,0,speed>*rot; //along the axis of the launcher

   #if defined LAUNCH_ROT
      rotation rot2 = rot;
   #elif defined LAUNCH_ROT_ZERO
      rotation rot2 = <0.0,0.0,0.0,0.0>;
   #elif defined LAUNCH_ROT_ABSOLUTE4
      rotation rot2 = LAUNCH_ROT_ABSOLUTE4;
   #elif defined LAUNCH_ROT_ABSOLUTE
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_ABSOLUTE);
   #elif defined LAUNCH_ROT_RELATIVE
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_RELATIVE) *rot;
   #elif defined LAUNCH_ROT_RELATIVE2
      vector flat_rot = llRot2Euler(rot);
      flat_rot.x = 0.0;
      flat_rot.y = 0.0;
      //flat_rot.z = 0;
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_RELATIVE2) *llEuler2Rot(flat_rot);

   #else // angle is in radians, either as initialized or read from notecard
      rotation rot2 = llEuler2Rot(<0,angle,0>) * rot; //putting the constant first means local rotation
   #endif

   #if defined MIRRORPAIR
       numOfBalls = 2;
   #endif 

   #if defined PAIR
       numOfBalls = 2;
   #endif

   for (i = 0; i<numOfBalls; i++)
   {
      setParamsFast(muzzleLink,[PRIM_COLOR,muzzleFace,muzzleColor,1.0]);
      setParamsFast(muzzleLink,[PRIM_GLOW,muzzleFace,1.0]);

      launchMsg=texture;
      if (numOfBalls > 1)   //multiple monochrome balls aka rainbow?
      {
         string colorA = llList2String(colors,(i));
         launchMsg += ","+colorA+","+colorA+","+colorA;
         rocket = llGetInventoryName(INVENTORY_OBJECT,0);
      }else{  // i = 0
         string colorA = llList2String(colors,(i*3));
         string colorB = llList2String(colors,(i*3)+1);
         string colorC = llList2String(colors,(i*3)+2);
         launchMsg += ","+colorA+","+colorB+","+colorC;
         rocket = llGetInventoryName(INVENTORY_OBJECT,i);
      }
      launchMsg += ","+(string)systemAge+","+(string)volume;
      launchMsg += ","+(string)startGlow+","+(string)endGlow;
      launchMsg += "," + BOOMSOUND;
      launchMsg += "," + (string)burstRadius;
      launchMsg += "," + (string)partAge;
      launchMsg += "," + (string)startAlpha + "," + (string)endAlpha;
      launchMsg += "," + (string)burstRate; 
      launchMsg += "," + (string)startScale + "," + (string)endScale;
      launchMsg += "," + (string)partCount; 
      vector partOmega2 = partOmega;

      #if defined PARTOMEGA_REL
         //this is probably not right, should probably be only 2 dimensional  
         partOmega2 = partOmega2 * rot;
         //partOmega2 = partOmega2 * (<rot.x,rot.y,rot.z>);
      #elif defined PARTOMEGA_REL2
         //partOmega2 = partOmega2 * (<rot.x,rot.y,rot.z>);
         partOmega2 = partOmega2 * rot;
         partOmega2.z = 0.0;
      #endif

      #if defined MIRRORPAIR
         if (i == 1)
            partOmega2 = -1 * partOmega2;
      #endif 

      launchMsg += "," + (string)partOmega2;
      #if defined BURSTOUT
      if (i==0) 
           launchMsg += "," + (string)maxPartSpeed+","+(string)minPartSpeed;
      else 
           launchMsg += "," + (string)(maxPartSpeed*BURSTOUT)+","+(string)(minPartSpeed*BURSTOUT);
      #else
      launchMsg += "," + (string)maxPartSpeed+","+(string)minPartSpeed;
      #endif
      launchMsg += "," + (string)beginAngle+","+(string)endAngle;
      rezChan = (integer) llFrand(255);
      integer packedParam2 = packedParam + (rezChan*0x4000);
      rezChan = -42000 -rezChan;  // the -42000 is arbitrary
      llPlaySound(LAUNCHSOUND,volume);
      repeatSound(LAUNCHSOUND,volume);
      llRezAtRoot(rocket,pos,vel, rot2, packedParam2);
      setGlow(muzzleLink,0.0);
      setParamsFast(muzzleLink,[PRIM_COLOR,ALL_SIDES,<0.0,0.0,0.0>,0.0]);
      llSleep(0.2);
      debugSay(1,"launch vel " + (string)vel);
      debugSay(1,"launcher rot " + (string)rot  + " or " + (string)llRot2Euler(rot));
      debugSay(1,"   launch rot " + (string)rot2 + " or " + (string)llRot2Euler(rot2));
      debugSay(1,"sending launchMsg *********\n" + launchMsg+ "\n*********");
      llRegionSay(rezChan, launchMsg);
      if (launchDelay > 0.0)
         llSleep(launchDelay);
   }
}

//{ default()    this allows folding in NP++ 
default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change &( CHANGED_INVENTORY|CHANGED_SCALE)) llResetScript();}

   state_entry()
   {
      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;
      #endif
      owner=llGetOwner();
      chatChan = getChatChan(notecardList);
      #if defined DESCRIPTION
         llSetObjectDesc((string)chatChan+" "+VERSION+" "+DESCRIPTION);
      #endif

      numOfBalls = getInteger(notecardList,"balls");
      if (numOfBalls < 1)  //if not specified by notecard
         numOfBalls =  llGetInventoryNumber(INVENTORY_OBJECT);
      volume = getVolume(notecardList);
      explodeOnCollision = getexplodeOnCollision(notecardList);
      explodeOnLowVelocity = getInteger(notecardList, "peak");
      access = getAccess(notecardList);
      speed = getFloat(notecardList,"speed");
      flightTime = getInteger(notecardList,"flighttime");
      freezeOnBoom = getInteger(notecardList,"freeze");
      wind = getInteger(notecardList,"wind");
      angle = getInteger(notecardList, "angle") * DEG_TO_RAD;
      // launchDelay = getFloat(notecardList, "delay");
      colors = colors + parseColor(notecardList,"color1");
      colors = colors + parseColor(notecardList,"color2");
      colors = colors + parseColor(notecardList,"color3");
      colors = colors + parseColor(notecardList,"color4");
      colors = colors + parseColor(notecardList,"color5");
      colors = colors + parseColor(notecardList,"color6");
      debugSay(2,"notecard color list is [" + (string)colors + "]");

      // max int 0x80000000  (32 bits)
      //integer(<127) + integer (<=100, typically 50)
      //  follow vel   1----- -------- -------- --------  = 0x2000 0000
      //  low vel       1---- -------- -------- --------  = 0x1000 0000
      //  wind           1--- -------- -------- --------  = 0x0800 0000
      //  freeze          1-- -------- -------- --------  = 0x0400 0000
      //  collision        1- -------- -------- --------  = 0x0200 0000
      //  debug             1 -------- -------- --------  = 0x0100 0000
      //  launchalpha       - 1------- -------- --------  = 0x0080 0000
      //  unused              -1------ -------- --------  = 0x0040 0000
      //  rezchan               111111 11------ --------  = 0x003F C000 (llFrand(255) * 0x4000) 
      //  unused                       --111111 1-------  =      0x3F80
      //  flighttime                            -1111111  =      0x007F
      
      packedParam = flightTime;  //up to 0x007F
      #ifndef NO_FOLLOW_VELOCITY
         packedParam = packedParam | FOLLOW_VELOCITY_MASK; //0x2000 0000
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
         packedParam = packedParam | DEBUG_MASK;         // 0x0100 0000
      #endif
      #if defined LAUNCHALPHA
         packedParam = packedParam | LAUNCH_ALPHA_MASK;  //0x0080 0000
      #endif

      llPreloadSound(LAUNCHSOUND);
      llPreloadSound(BOOMSOUND);
      integer preloadLink = getLinkWithName(preloadPrimName);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER"))
         llSetLinkTexture(preloadLink,texture,preloadFace);

      muzzleLink = getLinkWithName(muzzlePrimName);
      //debugSay(3,"muzzle is link number " + (string)muzzleLink);
      assert((muzzleLink>0),"CAN'T FIND THE MUZZLE PRIM");
      //llSetLinkTexture(muzzleLink, texture,muzzleFace);

      vector v = llGetScale();
      zOffset = zOffset + ((float)v.z)/2 + 0.2;  //assuming ball diameter is 0.4
      if (zOffset > 10.0) //can't rez more than 10 m away
         zOffset = 9.0;

      string id = "";
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }
//}

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
   {
      msgHandler(owner, msg);
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
   {
      debugSay(2,"got message " + msg + " on channel " + (string) chan);
      msgHandler(id, msg);
   }
}

//this has to be after the default state
#include "LIB\readNotecardToList.lsl"

