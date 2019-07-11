/*
* rocketball 3.x
* copyright Tracer Ping / Tracer Prometheus 2018
* tracerping@gmail.com
*
*/
#define Version "3.6"

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
integer tricolor = FALSE;     //overridden by #define?
integer rezParam;
string color1;
string color2;
string color3;
list params;
integer handle;
integer armed = FALSE;
vector partAccel;

#if defined RINGBALL
   #include "LIB\effects\effect_ringball1.lsl"
   #define DESCRIPTION " ringball "
#elif defined SPIRALBALL
   #include "LIB\effects\effect_spiral_1.lsl"
   #define DESCRIPTION " spiralball "
#else
   //#include "LIB\effects\effect_standard_rocketball.lsl"
   #include "LIB\effects\effect_standard_burst.lsl"
   #define DESCRIPTION " roundball "
#endif


boom()
{
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   //if (!armed)
   //  return;
   debugSay(2,"boom at " + (string)llGetPos() + (string)llGetVel());
   setColor(LINK_THIS,(vector)primColor,0.0);
   setGlow(LINK_THIS,primGlow);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,lightRadius,falloff]);
   if (freezeOnBoom)
   {
      debugSay(2,"freezing");
      llSetStatus(STATUS_PHYSICS,FALSE);
      llSetStatus(STATUS_PHANTOM,TRUE);
   }
   #if defined ROT_90
      setRot(llEuler2Rot(<0,PI_BY_TWO,0>) * llGetRot());
   #endif

   if (tricolor)
   {
      makeParticles(LINK_THIS,color1,color1);
      //llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
      llPlaySound(sound1,boomVolume);
      repeatSound(sound1,boomVolume);
      llSleep(systemAge);
      makeParticles(LINK_THIS,color2,color2);
      llSleep(systemAge);
      makeParticles(LINK_THIS,color3,color3);
   }else{
      makeParticles(LINK_THIS,color1,color2);
      //llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
      llPlaySound(sound1,boomVolume);
      repeatSound(sound1,boomVolume);
   }
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,lightRadius,falloff]);
   setGlow(LINK_THIS,0.0);
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
      #if defined TRICOLOR
         tricolor = TRUE;
      #endif
   }

   //having touch_start makes some effects easier to debug
   touch_start(integer n)
   {
      systemAge = 1;
      partAge = 4;
      startGlow = 0.0;
      endGlow = 0.0;
      boom();
   }

   on_rez(integer p)
   {
      llResetTime();
      debug = (p & DEBUG_MASK);
      debugSay(2,"initial velocity "+(string)llGetVel());
      if (p > 0)
      {
         if (p & LAUNCH_ALPHA_MASK)
            launchAlpha = 1.0;
         else
            launchAlpha = 0.0;
         setColor(LINK_SET,launchColor,launchAlpha);
         setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,lightRadius,falloff]);
         setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
         //llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
         //setParamsFast(LINK_SET,[PRIM_SIZE,primSize]);
      }
      else
      {
         AllOff(FALSE);
      }
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      rezParam = p; //save this
      //debugSay(2,"rezzed("+hex(p)+")");
      flightTime = (float)(p & 0x7F);
      llSetBuoyancy(0.5);
      integer chan = (-42000) -((p & 0x3FC000) >>14);
      debugList(2,["p =",p,"=",hex(p),"chan = ",chan,"flightTime =",flightTime]);
      handle=llListen(chan,"","","");
      if  (p & LOW_VELOCITY_MASK)
         explodeOnLowVelocity = TRUE;
      if (p & COLLISION_MASK)
         explodeOnCollision = TRUE;
      if (p & FREEZE_MASK)
         freezeOnBoom = TRUE;
      if (p & FOLLOW_VELOCITY_MASK)
         followVelocity = TRUE;
      llCollisionSound("", 1.0);  //  Disable collision sounds

      //setting prim size sets velocity to zero
      //this should have fixed it, but doesn't. Did it work in InWorldz?
      //vector v = llGetVel();
      //setParamsFast(LINK_SET,[PRIM_SIZE,primSize]);
      //llSetVelocity(v,FALSE);  //because setting the prim size sets velocity to zero

      #if defined POINTFORWARD
         vector v = llGetVel();
         llLookAt(v+llGetPos(), 0.5, 0.1);
      #elif defined PRIM_ROTATION
         rotation r = llGetRot();
         //r.z = -r.z;
         //r.x = -r.x;
         //r.y = -r.y;
         setRot(r);
      #endif

      if (rezParam>0)
      {  //use timer instead of sleeping to allow other events
         llSetTimerEvent(0.01);
      }
      debugSay(2,"end of on_rez at " + (string)llGetTime()+" velocity: "+(string)llGetVel());
   }

   listen( integer chan, string name, key id, string msg )
   {
      // we want to set the prim color ASAP
      params = llCSV2List(msg);
      color1 = llList2String(params,1);
      setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)color1,launchAlpha]);
      llListenRemove(handle);
      debugSay(2,"msg = "+msg);
      debugSay(2,"got msg at " + (string)llGetTime()+" velocity: "+(string)llGetVel());
      texture = llList2String(params,0);
      color2 = llList2String(params,2);
      color3 = llList2String(params,3);
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
      startScale =  llList2Vector(params,14);
      endScale =  llList2Vector(params,15);
      partCount = llList2Integer(params,16);
      partOmega = llList2Vector(params,17);
      maxPartSpeed = llList2Float(params,18);
      minPartSpeed = llList2Float(params,19);
      beginAngle = llList2Float(params,20);
      endAngle = llList2Float(params,21);
      partAccel = llList2Vector(params,22);
      lightColor = color1;
      //e = llList2Integer(emitters,i);
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,lightRadius,falloff]);
      armed = TRUE;
   }

   timer()
   {
      float tim = llGetTime();
      vector v = llGetVel();
      debugSay(2,"llGetTime "+(string)tim+", velocity: "+(string)v);
      #if defined POINTFORWARD
      llLookAt(v+llGetPos(), 0.5, 0.1);
      //or
      //llLookAt(v+llGetPos(), 1.0, 0.5);
      #endif

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

   #define EXPLODE_ON_COLLISION
   #ifdef EXPLODE_ON_COLLISION
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
               #if defined TRAILBALL
                  AllOff(TRUE);
                  llSetStatus(STATUS_PHYSICS, FALSE);
                  llDie();
               #else
                  boom();
               #endif
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
         #if defined TRAILBALL
            AllOff(TRUE);
            llSetStatus(STATUS_PHYSICS, FALSE);
            llDie();
         #else
         boom();
         #endif
      }
   }
   #endif
}

