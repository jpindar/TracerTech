/*
* launch controller
* copyright Tracer Prometheus / Tracer Ping 2018
* tracerping@gmail.com
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
*rezzes and launches projectile from its inventory
*
*  //{   this allows folding in NP++
*  //}   end of folding section
*/
#define VERSION "4.7.4"

//#define CANNON_BARREL
#include "LIB\lib.lsl"
#include "LIB\readNotecardToList.h"


string texture;
string color1;
string color2;
#if defined CANNON_BARREL
   float zOffset = 1.5;
#else
   float zOffset = 0.7; //0.7 to 2.0
#endif
integer preloadFace = 0;
integer muzzleLink = -1;
key owner;
integer chatChan;
integer explodeOnCollision = 0;
integer explodeOnLowVelocity = 0;
integer access;
list colors;
float flightSpeed;
integer flightTime;
integer freezeOnBoom;
integer launchParam;
float angle = NO_VALUE;

//{   preprocessor defines
#define SPEED 15

#ifdef ENABLEWIND
   integer wind = ENABLEWIND;
#else
   integer wind = 0;
#endif

#ifndef PRELOADERPRIM
   #define PRELOADERPRIM "preloader"
#endif
string preloadPrimName = PRELOADERPRIM;

#ifndef MUZZLEPRIM
   #define MUZZLEPRIM "muzzle"
#endif
string muzzlePrimName = MUZZLEPRIM;

#if defined BALLS
  integer numOfBalls = BALLS;
#else
  integer numOfBalls = 0;
#endif

#if defined LAUNCHDELAY
  float launchDelay = LAUNCHDELAY;
#else
  float launchDelay = 0.5;
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

#ifdef STARTSCALE
  vector startScale = STARTSCALE;
#else
  vector startScale = <1.0,1.0,0.0>;
#endif

#ifdef ENDSCALE
  vector  endScale = ENDSCALE;
#else
  vector  endScale = <1.0,1.0,0.0>;
#endif

#ifdef PARTCOUNT
  integer partCount = PARTCOUNT;
#else
  integer partCount = 2;
#endif

#ifdef MAXPARTSPEED
   float maxPartSpeed = MAXPARTSPEED;
#else
   float maxPartSpeed = 1.0;
#endif

#ifdef MINPARTSPEED
   float minPartSpeed = MINPARTSPEED;
#else
   float minPartSpeed = 1.0;
#endif

#ifdef PARTACCEL
   vector partAccel = PARTACCEL;
#else
   vector partAccel = <0,0,0>;
#endif

#define NOTECARD_IN_THIS_PRIM
//}

msgHandler(string sender, string msg)
{
   //{
   llResetTime();
   debugSay(3,"got message '" + msg + "' from "+ (string)sender);
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
      fire(systemAge);
   }
   if (msg == "on")
   {
      fire(MAX_INT);
   }
   if (msg == "off")
   {
      fire(0);
   }
   else if (msg == "hide")
   {
      llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
   }
   else if (msg == "show")
   {
      llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
   }
   else if (msg == "mute")
   {
      volume = 0.0;
   }
   else if (msg == "unmute")
   {
      volume = 1.0;
   }
   //}
}

rotation chooseRotation(rotation rot)
{
   debugSay(2,"in chooseRotation");
   //{
   if (angle != NO_VALUE)   // notecard overrides everything else
   {
      debugSay(2,"got relative angle from notecard");
      return llEuler2Rot(<0,angle,0>) * rot; //putting the constant first means local rotation
   }
   else
   {
   #if defined LAUNCH_ROT
      debugSay(2,"LAUNCH_ROT");
      rotation rot2 = rot;
   #elif defined LAUNCH_ROT_ZERO
      debugSay(2,"LAUNCH_ROT_ZERO");
      rotation rot2 = <0.0,0.0,0.0,0.0>;
   #elif defined LAUNCH_ROT_ABSOLUTE4
      debugSay(2,"LAUNCH_ROT_ABSOLUTE4");
      rotation rot2 = LAUNCH_ROT_ABSOLUTE4;
   #elif defined LAUNCH_ROT_ABSOLUTE
      debugSay(2,"LAUNCH_ROT_ABSOLUTE");
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_ABSOLUTE);
      debugSay(2,(string)rot2);
   #elif defined LAUNCH_ROT_RELATIVE
      debugSay(2,"LAUNCH_ROT_RELATIVE");
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_RELATIVE) *rot;
   #elif defined LAUNCH_ROT_RELATIVE2
      debugSay(2,"LAUNCH_ROT_RELATIVE2");
      vector flat_rot = llRot2Euler(rot);
      flat_rot.x = 0.0;
      flat_rot.y = 0.0;
      //flat_rot.z = 0;
      rotation rot2 = llEuler2Rot(LAUNCH_ROT_RELATIVE2) *llEuler2Rot(flat_rot);
   #else
      debugSay(2,"LAUNCH_ROT not defined");
      rotation rot2 = llEuler2Rot(<0,0,0>) * rot;
   #endif
   debugSay(2,"rotation = " + (string)rot2);
   return rot2;
   }
   //}
}

vector chooseOmega(integer i)
{
   rotation rot = llGetRot();
   #ifdef PARTOMEGA
      vector omega = PARTOMEGA;
   #elif defined PARTOMEGA_REL
      vector omega = PARTOMEGA_REL;
   #elif defined PARTOMEGA_ABS
      vector omega = PARTOMEGA_ABS;
   #else
      vector omega = <0.0,0.0,0.0>;
   #endif
   vector omega2 = omega;
   #if defined PARTOMEGA_REL
       //this is probably not right, should probably be only 2 dimensional
       omega2 = omega * rot;
       //omega2 = omega * (<rot.x,rot.y,rot.z>);
       debugList(2,["partOmega1",omega,"rot",rot,"partOmega2",omega2]);
   #elif defined PARTOMEGA_REL2
       // still not right
       //omega2 = omega * (<rot.x,rot.y,rot.z>);
       omega2 = llRot2Euler(llEuler2Rot(omega) * rot);
       //omega2 = omega * rot;
       //omega2.z = 0.0;
       debugList(2,["partOmega1",omega,"rot",rot,"partOmega2",omega2]);
   #endif
   #if defined MIRROR
         if ((i%2) == 1)
            omega2 = -1 * omega2;
   #endif
   return omega2;
}

string generateLaunchMsg(integer i)
{
   //{
   /* this uses texture,numOfBalls,colors etc., too many to pass as individual
      parameters, but extracting from a list is, I think, very slow in LSL.  So, globals.
      TODO: test speed with parameters in a list
   */

   /*
   LAUNCH MESSAGE FORMAT  (all as strings)
   texture
   3 colors
   systemAge  a float
   volume
   startGlow, endGlow
   BOOMSOUND
   burstRadius
   partAge
   startAlpha,endAlpha
   burstRate
   startScale,endScale
   partCount
   partOmega
   maxPartSpeed,minPartSpeed
   beginAngle,endAngle
   partAccel
   rezPos
   */
   #ifdef REZPOSREL
      vector rezPos = llGetPos()+ ((vector)REZPOSREL * llGetRot());
      debugSay(2,"rezpos " + (string)rezPos);
   #elif defined REZPOSABS
      vector rezPos = (vector)REZPOSABS;
      debugSay(2,"rezpos " + (string)rezPos);
   #elif define REZPOSTEST
      vector rezPos = (vector)TARGET_POS_TEST;
      debugSay(2,"rezpos " + (string)rezPos);
   #else
      vector rezPos = <0.0,0.0,0.0>;  // ignored by projectile
      debugSay(2,"rezpos null");
   #endif

   //have to put this here because SL can't do math in declarations
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

   string msg=texture;
   if (numOfBalls > 1)   //multiple monochrome balls aka rainbow?
   {
      string colorA = llList2String(colors,(i));
      msg += ","+colorA+","+colorA+","+colorA;
   }else{  // i = 0
      string colorA = llList2String(colors,(i*3));
      string colorB = llList2String(colors,(i*3)+1);
      string colorC = llList2String(colors,(i*3)+2);
      msg += ","+colorA+","+colorB+","+colorC;
   }
   msg += ","+(string)systemAge+","+(string)volume;
   msg += ","+(string)startGlow+","+(string)endGlow;
   msg += "," + BOOMSOUND;
   msg += "," + (string)burstRadius;
   msg += "," + (string)partAge;
   msg += "," + (string)startAlpha + "," + (string)endAlpha;
   msg += "," + (string)burstRate;
   msg += "," + (string)startScale + "," + (string)endScale;
   msg += "," + (string)partCount;
   msg += "," + (string)chooseOmega(i);   //partOmega
   #if defined BURSTOUT
   if (i==0)
      msg += "," + (string)maxPartSpeed+","+(string)minPartSpeed;
   else
      msg += "," + (string)(maxPartSpeed*BURSTOUT)+","+(string)(minPartSpeed*BURSTOUT);
   #else
      msg += "," + (string)maxPartSpeed+","+(string)minPartSpeed;
   #endif
   msg += "," + (string)beginAngle+","+(string)endAngle;
   msg += "," + (string)partAccel;
   msg += "," + (string)rezPos;
   return msg;
   //}
}

integer generateLaunchParams()
{
   //{
   /* format of launch parameter
       max int 0x80000000  (32 bits)

      integer(<127) + integer (<=100, typically 50)
      follow vel   1----- -------- -------- --------  = 0x2000 0000
      low vel       1---- -------- -------- --------  = 0x1000 0000
      wind           1--- -------- -------- --------  = 0x0800 0000
      freeze          1-- -------- -------- --------  = 0x0400 0000
      collision        1- -------- -------- --------  = 0x0200 0000
      debug             1 -------- -------- --------  = 0x0100 0000
      launchalpha       - 1------- -------- --------  = 0x0080 0000
      unused              -1------ -------- --------  = 0x0040 0000
      rezchan               111111 11------ --------  = 0x003F C000 (llFrand(255) * 0x4000)
      unused                       --11---- --------  = 0x0000 3000
      smoke                        ----1--- -------- =  0x0000 0800
      multimode                    -----111 1-------  = 0x0000 0780
      flighttime                            -1111111  =      0x007F
   */
   vector v = llGetScale();
   zOffset = zOffset + ((float)v.z)/2 + 0.2;  //assuming ball diameter is 0.4
   if (zOffset > 10.0) //can't rez more than 10 m away
      zOffset = 9.0;

   #if defined MULTIBURST
      integer mode = MODE_MULTIBURST;
   #else
      integer mode = 0;
   #endif

   #if defined RINGBALL
      mode = mode | MODE_ANGLE;
   #elif defined SPIRALBALL
      mode = mode | MODE_ANGLE;
   #elif defined MODEANGLE
      mode = mode | MODE_ANGLE;
   #elif defined MODEANGLECONE
      mode = mode | MODE_ANGLECONE;
   #else
      llOwnerSay("NO PATTERN DEFINE");
   #endif
   debugList(2,["mode is ", hex(mode)]);

   integer p = flightTime;  //up to 0x007F

   p = p | (mode << MULTIMODE_OFFSET);
   debugList(2,["parameter is ", p, " or ", hex(p)]);

   #if defined LAUNCHALPHA
      #if LAUNCHALPHA == 1
          p = p | LAUNCH_ALPHA_MASK;
      #endif
   #endif
   #if defined SMOKE
      p = p | SMOKE_MASK;
   #endif
   #if defined RIBBON
      p = p | RIBBON_MASK;
   #endif
   #if defined NOFLASH
      debugSay(2,"no flash");
   #else
      debugSay(2,"flash");
      p = p | FLASH_MASK;
   #endif

   if (debug > 1)
      p = p | DEBUG_MASK;
   if (explodeOnCollision >0)
      p = p | COLLISION_MASK;
   if (freezeOnBoom >0)
      p = p | FREEZE_MASK;
   if (wind >0)
      p = p | WIND_MASK;
   if (explodeOnLowVelocity >0)
      p = p | LOW_VELOCITY_MASK;
   #if defined STATIC
      p = p | FREEZE_ON_LAUNCH_MASK;
   #endif
   #ifndef NO_FOLLOW_VELOCITY
      p = p | FOLLOW_VELOCITY_MASK;
   #endif
   return p;
   //}
}


fire(float systemAge)
{
   //{
   vector muzzleColor = (vector)COLOR_GOLD;
   float muzzleGlow = 1.0;
   integer muzzleFace = ALL_SIDES;
   string rocket;
   integer i;
   debugSay(3,"firing at "+ (string)llGetTime() + " seconds");
   for (i = 0; i<numOfBalls; i++)
   {
      debugSay(3,"fire "+(string)i);
      if (muzzleLink > -1)
      {
         setParamsFast(muzzleLink,[PRIM_COLOR,muzzleFace,muzzleColor,1.0]);
         setParamsFast(muzzleLink,[PRIM_GLOW,muzzleFace,1.0]);
      }
      if (numOfBalls > 1)   //multiple monochrome balls aka rainbow?
      {
         rocket = llGetInventoryName(INVENTORY_OBJECT,0);
      }else{  // i = 0
         rocket = llGetInventoryName(INVENTORY_OBJECT,i);
      }

      string launchMsg=generateLaunchMsg(i);
      integer rezChan = (integer) llFrand(255);
      integer p2 = launchParam + (rezChan*0x4000);
      rezChan = -42000 -rezChan;  // the -42000 is arbitrary
      #ifndef STATIC
         llPlaySound(LAUNCHSOUND,volume);
         repeatSound(LAUNCHSOUND,volume);
      #endif

      rotation rot = llGetRot();
      //rez a distance along the the barrel axis
      vector pos = llGetPos()+ (<0.0,0.0,zOffset> * rot);
      vector vel = <0,0,flightSpeed>*rot; //along the axis of the launcher
      rotation rot2 =  chooseRotation(rot);
      debugSay(2,"rotation = " + (string)rot2);
      llRezAtRoot(rocket,pos,vel, rot2, p2);

      debugSay(3,"rezzing at "+ (string)llGetTime() + " seconds");
      if (muzzleLink >-1)
      {
         setGlow(muzzleLink,0.0);
         setParamsFast(muzzleLink,[PRIM_COLOR,ALL_SIDES,<0.0,0.0,0.0>,0.0]);
      }
      llSleep(0.2);
      debugSay(2,"launch vel " + (string)vel);
      debugSay(2,"launcher rot   " + (string)rot  + " or " + (string)llRot2Euler(rot));
      debugSay(2,"projectile rot " + (string)rot2 + " or " + (string)llRot2Euler(rot2));
      debugSay(2,"sending launchMsg at "+(string)llGetTime()+" seconds *********\n" + launchMsg+ "\n*********");
      llRegionSay(rezChan, launchMsg);
      if (launchDelay > 0.0)
         llSleep(launchDelay);
   }
   //}
}


parseNotecardList()
{
   //{
   volume = getVolume(notecardList);
   explodeOnCollision = getexplodeOnCollision(notecardList);
   explodeOnLowVelocity = getInteger(notecardList, "peak", 0);
   access = getAccess(notecardList);
   chatChan = getChatChan(notecardList);
   #ifdef STATIC
      flightSpeed = 0;
      flightTime = 1;
   #else
      flightSpeed = getFloat(notecardList,"speed",SPEED);
      flightTime = getInteger(notecardList,"flighttime", 99);
   #endif
   if (flightTime > 126)
      flightTime =  127;

   #if defined FREEZE
      freezeOnBoom = FREEZE
   #else
   freezeOnBoom = getInteger(notecardList,"freeze", 0);
   #endif
   integer w = getInteger(notecardList,"wind", NO_VALUE);
   if (w != NO_VALUE)
      wind = w;
   angle = getAngle(notecardList, "angle",NO_VALUE);
   debugSay(4,"notecard angle says "+ (string) angle);
   colors = colors + parseColor(notecardList,"color1")
                   + parseColor(notecardList,"color2")
                   + parseColor(notecardList,"color3")
                   + parseColor(notecardList,"color4")
                   + parseColor(notecardList,"color5")
                   + parseColor(notecardList,"color6");
   debugSay(2,"notecard color list is [" + (string)colors + "]");
   //}
}


default
{
   //{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change &( CHANGED_INVENTORY|CHANGED_SCALE)) llResetScript();}

   state_entry()
   {
      if (debug > 0) debugSound(SOUND_BEEP1,1.0);
      debugSay(1,"\n STATE_ENTRY" + " debug level = " + (string)debug);
      owner=llGetOwner();

      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;
      #endif

      // code before this point can be executed more than once!
      debugSay(5,"Done reading notecard at "+(string)llGetTime() + "seconds");

      #if defined TEXTURE1
         texture = TEXTURE1;
      #else
         texture = getTextureFromInventory(0);
      #endif

      if (numOfBalls < 1)  //if not specified by notecard or #define
         numOfBalls =  llGetInventoryNumber(INVENTORY_OBJECT);
      debugSay(5,"1: "+(string)llGetTime() + "seconds");

      parseNotecardList();
      debugSay(5,"1.1: "+(string)llGetTime() + "seconds");
      #if defined DESCRIPTION
         // Note that this sets the prim's description, not the object's so it is OK to leave in launcher that is being linked to another object
         llSetObjectDesc((string)chatChan+" "+llGetInventoryName(INVENTORY_OBJECT,0));
         string name = PREFIX + " Launcher " +VERSION+" "+DESCRIPTION;
         llSetObjectName(name);
      #endif
      debugSay(5,"1.2: "+(string)llGetTime() + "seconds");

      launchParam = generateLaunchParams();
      debugSay(5,"1.3: "+(string)llGetTime() + "seconds");

      #ifndef STATIC
         llPreloadSound(LAUNCHSOUND);
      #endif
      llPreloadSound(BOOMSOUND);
      debugSay(5,"2: "+ (string)llGetTime() + "seconds");

      integer preloadLink = getLinkWithName(preloadPrimName);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER"))
         {
         if (texture != "")
            llSetLinkTexture(preloadLink,texture,preloadFace);
         }
      #ifdef STATIC
         muzzleLink = -1;
      #else
         muzzleLink = getLinkWithName(muzzlePrimName);
         assert((muzzleLink>0),"CAN'T FIND THE MUZZLE PRIM");
      #endif

      string id = "";
      llListen(chatChan, "",id, "" );
      llListen(GLOBAL_CHAN,"",id,"");
      llOwnerSay("listening on channel "+(string)chatChan);
      llOwnerSay("listening on channel "+(string)GLOBAL_CHAN);
      debugSay(1,"READY at "+ (string)llGetAndResetTime() + "seconds");
      if (debug > 0) debugSound(SOUND_BEEP2,1.0);
      }

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
   //}
}

//this has to be after the default state
#include "LIB\readNotecardToList.lsl"

