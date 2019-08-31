/*
* rocketball 4.x
* copyright Tracer Ping / Tracer Prometheus 2018
* tracerping@gmail.com
*
*/
#define Version "4.03"

#include "LIB\lib.lsl"
#include "LIB\effects\effect.h"

string sound1;
float boomVolume = 1.0;                // overridden by notecard via chat

vector launchColor = <1.0,1.0,1.0>;    //OK for now
float launchAlpha;                     // determined by rez param
string primColor;
float primGlow = 0.0;
vector primSize = <0.1,0.1,0.1>;
string lightColor = COLOR_WHITE;
float intensity = 1.0;
float lightRadius = 20;  // 5 to 20
float falloff = 0.1; //0.02 to 0.75

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


#include "LIB\effects\effect_standard_burst.lsl"
#define DESCRIPTION " "


subBoom1(integer i)
{
   float flashTime = 0.2;
   float interEmitterDelay = systemAge;
   llPlaySound(sound1, volume);
   repeatSound(sound1,volume);
   string startColor = llList2String(colors,i*2);
   string endColor = llList2String(colors,(i*2)+1);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,TRUE,(vector)startColor,intensity,lightRadius,falloff]);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)startColor,0.0]);
   //if (i < numOfEmitters)
   //   e = llList2Integer(emitters,i);
   //else
   //   e = llList2Integer(emitters,0);
   //setGlow(e,primGlow);
   //makeParticles(e,mode,color1,color2);
   setGlow(LINK_THIS,primGlow);
   makeParticles(LINK_THIS,mode,startColor,endColor);
   llSleep(flashTime);
   setGlow(LINK_SET,0.0);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
   if (interEmitterDelay>0) llSleep(interEmitterDelay);
}

subBoom0()
{
   string startColor = llList2String(colors,0);
   string endColor = llList2String(colors,1);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)startColor,intensity,lightRadius,falloff]);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)startColor,0.0]);
   setGlow(LINK_THIS,primGlow);
   makeParticles(LINK_THIS,mode,startColor,endColor);
   //llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
   setGlow(LINK_THIS,0.0);
   llPlaySound(sound1,boomVolume);
   repeatSound(sound1,boomVolume);
}


boom()
{
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   //if (!armed)
   //  return;
   debugSay(2,"boom at " + (string)llGetPos() + (string)llGetVel());
   if (freezeOnBoom)
   {
      debugSay(2,"freezing");
      llSetStatus(STATUS_PHYSICS,FALSE);
      llSetStatus(STATUS_PHANTOM,TRUE);
   }
   setRot(llEuler2Rot(boomRotation) * llGetRot());

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
      makeParticles(LINK_THIS,mode,"<0.0,0.0,0.0>","<0.0,0.0,0.0>");
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
}


AllOff(integer blacken)
{
   llParticleSystem([]);
   setGlow(LINK_THIS,0.0);
   if (blacken)
      setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,1.0]);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
   llLinkParticleSystem(LINK_THIS,[]);
}


parseRezParam(integer p)
{
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
            setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,lightRadius,falloff]);
            setParamsFast(LINK_SET,[PRIM_FULLBRIGHT, ALL_SIDES, TRUE ]); 
         }
         setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
         //llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
         //setParamsFast(LINK_SET,[PRIM_SIZE,primSize]);
      }
      else
      {
         AllOff(FALSE);
      }
      integer chan = (-42000) -((p & CHANNEL_MASK) >>CHANNEL_OFFSET);
      debugList(2,["rezparam =",p,"=",hex(p),"chan = ",chan]);
      handle=llListen(chan,"","","");
      // why is flighttime a float?   
      // because I going to divide recieved flighttime by 10?
      flightTime = (float)(p & FLIGHTTIME_MASK);
      mode = (p & MULTIMODE_MASK) >>MULTIMODE_OFFSET;
      debugList(2,["mode is ",mode, " or ", hex(mode)]);
      if  (p & LOW_VELOCITY_MASK)
         explodeOnLowVelocity = TRUE;
      if (p & COLLISION_MASK)
         explodeOnCollision = TRUE;
      if (p & FREEZE_MASK)
         freezeOnBoom = TRUE;
      if (p & FOLLOW_VELOCITY_MASK)
         followVelocity = TRUE;
}

default
{
   state_entry()
   {
      #if defined DESCRIPTION
         llSetObjectDesc(Version + " " + DESCRIPTION);
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
      llResetTime();
      llSetBuoyancy(0.5);
      debugSay(2,"initial velocity "+(string)llGetVel());
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      rezParam = p;
      parseRezParam(p);

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
   }

   listen( integer chan, string name, key id, string msg )
   {
      debugList(2,["got msg at ",llGetTime()," velocity: ",llGetVel()]);
      debugSay(2,"msg = "+msg);
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
      debugList(2,colors);
      lightColor = color1;
      setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)color1,launchAlpha]);
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,lightRadius,falloff]);
      texture = llList2String(params,0);
      systemAge = llList2Float(params,4);
      boomVolume = llList2Float(params,5);
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
      debugSay(2,"rezPos = " + (string)rezPos);
      if (rezPos != <0.0,0.0,0.0>)
         llSetRegionPos(rezPos);
      armed = TRUE;
      debugSay(2,"arming at " + (string)llGetTime());
   }

   timer()
   {
      float tim = llGetTime();
      vector v = llGetVel();
      debugSay(2,"llGetTime "+(string)tim+", velocity: "+(string)v);
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
   }

   collision_start(integer n)
   {
      integer f = 0;
      key id;
      vector spd;
      debugSay(2,llGetScriptName() + ": collision ");
      if ((explodeOnCollision==0) || (!armed))
         return;
      debugSay(2,llGetScriptName() + ": acting on collision ");
      debugSay(2, "me @ " +(string)llVecMag(llGetVel())+"m/s");
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
                  boom();
               }
            }
         }
      } while (++f < n);
   }

   land_collision_start(vector pos)
   {
      if ((explodeOnCollision==0) || (!armed))
         return;
      debugSay(2,"collision with land");
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
   }
}

