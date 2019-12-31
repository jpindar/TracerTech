/*
* rocketball 4.x
* copyright Tracer Ping / Tracer Prometheus 2018
* tracerping@gmail.com
*
*/
#define Version "4.11"

#include "LIB\lib.lsl"
#include "LIB\effects\effect.h"

string sound1;
vector launchColor = <1.0,1.0,1.0>;    //OK for now
float launchAlpha;                     // determined by rez param
string primColor;
float primGlow = 0.0;
vector primSize = <0.1,0.1,0.1>;
vector lightColor = <1.0,1.0,1.0>;
float intensity = 1.0;
float lightRadius = 20;  // 5 to 20
float falloff = 0.1; //0.02 to 0.75
integer wind;
integer explodeOnCollision = 0;        //overridden by notecard via rez param
integer explodeOnLowVelocity = 0;      //overridden by notecard via rez param
integer freezeOnBoom = FALSE;          //overridden by notecard via rez param
float flightTime = 99;                 //overridden by notecard via rez param
float minimumVelocity = 0.1;        //constant
float minimumCollisionSpeed = 10;   //constant
integer rezParam;
string color1;
string color2;
string color3;
list colors;
integer numOfIterations = 1;
list params;
integer handle;
integer armed = FALSE;
vector partAccel;
integer mode;
vector boomRotation = <0.0,0.0,0.0>;
integer pointForward = FALSE;
integer primRotation = FALSE;
integer trailball = FALSE;
vector rezPos = <0.0,0.0,0.0>;
integer ribbon = FALSE;
integer smoke = FALSE;

#include "LIB\effects\effect_standard_burst.lsl"

subBoom1(integer i)
{
   //{
   float flashTime = 0.2;
   float interEmitterDelay = systemAge;
   if (sound1 != "")
   {
      llPlaySound(sound1, volume);
      repeatSound(sound1,volume);
   }
   string startColor = llList2String(colors,i*2);
   string endColor = llList2String(colors,(i*2)+1);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,TRUE,(vector)startColor,intensity,lightRadius,falloff]);
   //if (i < numOfEmitters)
   //   e = llList2Integer(emitters,i);
   //else
   //   e = llList2Integer(emitters,0);
   //setGlow(e,primGlow);
   //makeParticles(e,mode,color1,color2);
   setGlow(LINK_SET,primGlow);
   makeParticles(LINK_SET,mode,startColor,endColor);
   llSleep(flashTime);
   setGlow(LINK_SET,0.0);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,intensity,lightRadius,falloff]);
   if (interEmitterDelay>0) llSleep(interEmitterDelay);
   //}
}

subBoom0()
{
   //{
   string startColor = llList2String(colors,0);
   string endColor = llList2String(colors,1);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)startColor,intensity,lightRadius,falloff]);
   setGlow(LINK_SET,primGlow);
   makeParticles(LINK_SET,mode,startColor,endColor);
   //llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,<0.0,0.0,0.0>,intensity,lightRadius,falloff]);
   setGlow(LINK_SET,0.0);
   if (sound1 != "")
   {
      llPlaySound(sound1,volume);
      repeatSound(sound1,volume);
   }
   //}
}


boom()
{
   //{
   float arbitraryDelay = 1.0;
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   if (!armed)
     return;
   debugSay(2,"boom at " + (string)llGetPos() + (string)llGetVel());
   llMessageLinked(LINK_THIS, 0, "off", ""); 
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,<0.0,0.0,0.0>,0.0]);

   if (freezeOnBoom)
   {
      debugSay(2,"freezing");
      llSetStatus(STATUS_PHYSICS,FALSE);
      llSetStatus(STATUS_PHANTOM,TRUE);
   }
   setRot(llEuler2Rot(boomRotation) * llGetRot());
   if (smoke)
      llSleep(arbitraryDelay);

   if ((mode & MODE_MULTIBURST) == MODE_MULTIBURST)
   {
      integer i;
      float interEmitterDelay = systemAge;
      float flashTime = 0.2;
      for(i=0;i<numOfIterations;i++)
      {
         subBoom1(i);
      }
      llParticleSystem([]);
      //just doing llParticleSystem([]) didn't work if interEmitterDelay < systemAge
      //if you don't want interEmitterDelay >= systemAge, use this:
      float temp = systemAge;
      systemAge = 0.01;
      makeParticles(LINK_SET,mode,"<0.0,0.0,0.0>","<0.0,0.0,0.0>");
      systemAge = temp;
   }
   else
   {
      subBoom0();
   }
   if (systemAge>0)
      llSleep(systemAge);
   AllOff(FALSE);
   llSetTimerEvent(0);
   if (rezParam !=0)
   {
      llSleep(2); // allow time for sound to finish
      llSetStatus(STATUS_PHYSICS, FALSE);
      llDie();
   }
   llSleep(5); //dunno why this is needed - but without it, no boom
   //}
}


AllOff(integer blacken)
{
   //{
   llParticleSystem([]);
   setGlow(LINK_SET,0.0);
   if (blacken)
      setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,1.0]);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
   llLinkParticleSystem(LINK_SET,[]);
   //}
}


parseRezParam(integer p)
{
   //{
      /* max int 0x80 00 00 00  (32 bits)
                  ------- -------- -------- --------
      follow vel   1----- -------- -------- --------  = 0x2000 0000
      low vel       1---- -------- -------- --------  = 0x1000 0000
      wind           1--- -------- -------- --------  = 0x0800 0000
      freeze          1-- -------- -------- --------  = 0x0400 0000
      collision        1- -------- -------- --------  = 0x0200 0000
      debug             1 -------- -------- --------  = 0x0100 0000
      launchalpha       - 1------- -------- --------  = 0x0080 0000
      unused              -1------ -------- --------  = 0x0040 0000
      rezchan               111111 11------ --------  = 0x003F C000
      flash                        --1----- --------  = 0x0000 2000
      ribbon                       ---1---- --------  = 0x0000 1000
      smoke                        ----1--- -------- =  0x0000 0800
      multimode                    -----111 1-------  = 0x0000 0780
      flighttime                            -1111111  =      0x007F
   */
   debug = (p & DEBUG_MASK);
   if (p > 0)
   {
      if (p & LAUNCH_ALPHA_MASK)
         launchAlpha = 1.0;
      else
         launchAlpha = 0.0;
      setColor(LINK_SET,launchColor,launchAlpha);
      if (p & FREEZE_ON_LAUNCH_MASK)
      {
         llSetStatus(STATUS_PHYSICS, FALSE);
      }
      else
      {
         if (p & FLASH_MASK)
         {
            setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,lightRadius,falloff]);
            setParamsFast(LINK_SET,[PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
         }
      }
   }
   else
   {
      AllOff(FALSE);
   }
   integer chan = (-42000) -((p & CHANNEL_MASK) >>CHANNEL_OFFSET);
   handle=llListen(chan,"","","");
   // why is flighttime a float?
   // because I going to divide recieved flighttime by 10?
   flightTime = (float)(p & FLIGHTTIME_MASK);
   mode = (p & MULTIMODE_MASK) >>MULTIMODE_OFFSET;
   debugList(2,["rezparam ",hex(p),"chan ",chan," mode ", hex(mode)]);
   if  (p & LOW_VELOCITY_MASK)
      explodeOnLowVelocity = TRUE;
   if (p & COLLISION_MASK)
      explodeOnCollision = TRUE;
   if (p & FREEZE_MASK)
      freezeOnBoom = TRUE;
   if (p & FOLLOW_VELOCITY_MASK)
      followVelocity = TRUE;
   if (p & SMOKE_MASK)
      smoke = TRUE;
   if (p & RIBBON_MASK)
      ribbon = TRUE;
   //}
}

default
{
   //{
   state_entry()
   {
      #if defined DESCRIPTION
         llSetObjectName(DESCRIPTION + " v" + (string)Version);
      #endif
      #if !defined HOTLAUNCH
         AllOff(FALSE);
      #endif
      #if defined POINTFORWARD
         pointForward = TRUE;
      #endif
      #if defined PRIMROTATION
         primRotation = TRUE;
      #endif
      llSetBuoyancy(0.5);
      llCollisionSound("", 0.0);
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,lightRadius,falloff]);
      setParamsFast(LINK_SET,[PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]);
      setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
   }

   //having touch_start makes some effects easier to debug
   touch_start(integer n)
   {
      //systemAge = 1;
      //partAge = 4;
      //startGlow = 0.0;
      //endGlow = 0.0;
      //texture = TEXTURE_SPIKESTAR;
      boom();
   }

   on_rez(integer p)
   {
      //{
      llResetTime();
      setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      debugSay(2,"initial velocity "+(string)llGetVel());
      rezParam = p;
      parseRezParam(p);

      if (smoke)
         llMessageLinked(LINK_SET, 0, "on", "");
      else
         llMessageLinked(LINK_SET, 0, "off", "");

      llCollisionSound("", 1.0);  //  Disable collision sounds
      //setting prim size sets velocity to zero
      //this should have fixed it, but doesn't. Did it work in InWorldz?
      //vector v = llGetVel();
      //setParamsFast(LINK_SET,[PRIM_SIZE,primSize]);
      //llSetVelocity(v,FALSE);  //because setting the prim size sets velocity to zero

      // Are these mutually exclusive?
      if (pointForward)
      {
         vector v = llGetVel();
         llLookAt(v+llGetPos(), 0.5, 0.1);
      }
      if (primRotation)
      {
         rotation r = llGetRot();
         //r.z = -r.z;
         //r.x = -r.x;
         //r.y = -r.y;
         setRot(r);
      }
      if (p>0)
      {  //use timer instead of sleeping to allow other events
         llSetTimerEvent(0.01);
      }
      debugSay(2,"end of on_rez at " + (string)llGetTime()+" velocity: "+(string)llGetVel());
      //}
   }

   listen( integer chan, string name, key id, string msg )
   {
      //{
      debugList(2,["    got msg at ",llGetAndResetTime()," velocity: ",llGetVel()]);
      debugSay(2,"**** msg = "+msg + "/n****");
      llListenRemove(handle);
      params = llCSV2List(msg);
      color1 = llList2String(params,1);
      color2 = llList2String(params,2);
      color3 = llList2String(params,3);
      if ((mode & 1) == MODE_MULTIBURST)
      {
         debugSay(2,"getting multiburst colors");
         if (color1 == "!pride")
         {
            colors = [COLOR_PRIDE_RED,COLOR_PRIDE_RED,COLOR_PRIDE_ORANGE,COLOR_PRIDE_ORANGE,COLOR_PRIDE_YELLOW,COLOR_PRIDE_YELLOW,COLOR_PRIDE_GREEN,COLOR_PRIDE_GREEN,COLOR_PRIDE_BLUE,COLOR_PRIDE_BLUE,COLOR_PRIDE_PURPLE,COLOR_PRIDE_PURPLE];
            color1 = COLOR_PRIDE_RED;
            numOfIterations = 6;
         }
         else if ((color1 == "!rwb") || (color1 == "!usa"))
         {
            colors = [COLOR_PRIDE_RED,COLOR_PRIDE_RED,COLOR_WHITE,COLOR_WHITE,COLOR_PRIDE_BLUE,COLOR_PRIDE_BLUE];
            color1 = COLOR_PRIDE_RED;
            numOfIterations = 3;
         }
         else if ((color1 == "!hot"))
         {
            colors = [COLOR_WHITE,COLOR_GOLD,COLOR_GOLD,COLOR_ORANGE,COLOR_ORANGE,COLOR_RED];
            color1 = COLOR_WHITE;
            numOfIterations = 3;
         }
         else if ((color1 == "!fire"))
         {
            colors = [COLOR_GOLD,COLOR_GOLD,COLOR_ORANGE,COLOR_ORANGE,COLOR_RED,COLOR_RED];
            color1 = COLOR_GOLD;
            numOfIterations = 3;
         }
         else
         {
            colors = [color1,color1,color2,color2,color3,color3];
            numOfIterations = 3;
         }
      }
      else
      {
         colors = [color1,color2,color3];
      }
      debugSay(2,"colors " + llList2CSV(colors));
      texture = llList2String(params,0);
      systemAge = llList2Float(params,4);
      volume = llList2Float(params,5);
      startGlow =  llList2Float(params,6);
      endGlow =  llList2Float(params,7);
      sound1 =  llList2String(params,8);
      burstRadius = llList2Float(params,9);
      partAge = llList2Float(params,10);
      startAlpha =  llList2Float(params,11);
      endAlpha =  llList2Float(params,12);
      burstRate =  llList2Float(params,13);
      startScale = (vector)llList2String(params,14);
      endScale =  (vector)llList2String(params,15);
      partCount = llList2Integer(params,16);
      partOmega = (vector)llList2String(params,17);
      maxPartSpeed = llList2Float(params,18);
      minPartSpeed = llList2Float(params,19);
      beginAngle = llList2Float(params,20);
      endAngle = llList2Float(params,21);
      partAccel = (vector)llList2String(params,22);
      rezPos =  (vector)llList2String(params,23);
      if (rezPos != <0.0,0.0,0.0>) //TODO is != comparison w floats a good idea?
      {
         debugSay(2,"moving to " + (string)rezPos);
         llSetRegionPos(rezPos);
      }
      armed = TRUE;
      debugSay(2,"arming at " + (string)llGetTime() + " seconds");
      //}
   }

   timer()
   {
      //{
      vector v = llGetVel();
      float tim = llGetTime();
      debugList(2,["time: ",tim," velocity: ",v]);
      if (pointForward)
      {
      llLookAt(v+llGetPos(), 0.5, 0.1);
      //or
      //llLookAt(v+llGetPos(), 1.0, 0.5);
      }

      if (tim>flightTime)
      {
         debugSay(2,"timed out");
         llSetTimerEvent(0);
         if (armed)
            boom();
      }
      else
      {
         if (v.z< minimumVelocity)
         {
            debugSay(2,"at low velocity" + (string)v.z);
            if (armed && explodeOnLowVelocity)
            {
               llSetTimerEvent(0);
               boom();
            }
         }
      }
      //}
   }

   collision_start(integer n)
   {
      //{
      integer f = 0;
      key id;
      vector spd;
      debugSay(2,llGetScriptName() + ": collision ");
      if ((explodeOnCollision==0) || (!armed))
         return;
      debugSay(2,llGetScriptName() + ": acting on collision ");
      debugSay(2, "me @ " +(string)llVecMag(llGetVel())+"m/s");
      debugList(2,["time ",llGetAndResetTime()]);
      for (f=0; f<n; f++)
      {
         debugSay(2,llDetectedName(f) + " @ " + (string)llRound(llVecMag(llDetectedVel(f))) + "m/s");
      }
      f = 0;
      do
      {
         // if (llVecMag(llDetectedVel(f)) >= minimumCollisionSpeed)
         {
            if (rezParam!=0)
            {
               if (trailball)
               {
                  AllOff(TRUE);
                  llSetStatus(STATUS_PHYSICS, FALSE);
                  llDie();
               } else {
                  //debugList(2,["booming at ",llGetAndResetTime()]);
                  boom();
               }
            }
         }
      } while (++f < n);
      //}
   }

   land_collision_start(vector pos)
   {
      //{
      debugSay(2,"collision with land");
      if ((explodeOnCollision==0) || (!armed))
         return;

      if (rezParam !=0)
      {
         if (trailball)
         {
            AllOff(TRUE);
            llSetStatus(STATUS_PHYSICS, FALSE);
            llDie();
         } else {
            boom();
         }
      }
      //}
   }

   //}
}

