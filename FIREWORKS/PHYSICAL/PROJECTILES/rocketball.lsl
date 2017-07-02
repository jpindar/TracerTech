/*
* rocketball 2.8.5
* copyright Tracer Ping 2017
*/
#define EXPLODE_ON_COLLISION
//#define PRIM_ROTATION
#define FREEZE_ON_BOOM
//#define SPIRALBALL
#define RINGBALL
//#define SPHERE_BALL
//#define TRAILBALL
//#define HOTLAUNCH
// RINGBALLS SHOULD NOT POINTFORWARD
//#define POINTFORWARD
//but if they are, they probably should be ROT_90, so that the ring is perpedicular
//to the flightpath
//#define ROT_90
//#define TRICOLOR

#include "lib.lsl"
integer tricolor = FALSE;
string sound1 = SOUND_PUREBOOM;
float boomVolume = 1.0;
string texture;
integer rezParam;
string color1;
string color2;
string color3;
string primColor;
vector launchColor = <1.0,1.0,1.0>;
string lightColor = COLOR_WHITE;
float intensity = 1.0;
float radius = 5;
float falloff = 0.1; //0.02 to 0.75
float primGlow1 = 0.0;
float primGlow2 = 0.0;
vector primSize = <0.1,0.1,0.5>;
//vector primSize = <0.07,0.07,1.99>;
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
integer explodeOnCollision = 0;
float minimumCollisionSpeed = 10;
integer freezeOnBoom = FALSE;
list params;
integer handle;
integer armed = FALSE;
float totalTime = 0;
float flightTime;


#if defined RINGBALL
   //#define PRIM_ROTATION
   float endAlpha = 0;// or1
   vector startSize = <1.5,1.5,0.0>;//or1.9
   vector endSize = <0.5,0.5,0.0>;
   float rate = 2; //4.7
   float partAge = 5.0; //or 1.5
   float primGlow = 0.0; 
   //float beginAngle = PI_BY_TWO;
   float beginAngle = PI;
   float endAngle = 0;
   #if defined TRICOLOR
      float systemAge;
      float partRadius = 1.0; //or 1
      #include "effects\effect_ringball3.lsl"
   #else
      float systemAge;
      float partRadius = 1.5; //or 1
      #include "effects\effect_ringball1.lsl"
   #endif
#elif defined SPIRALBALL
   integer effectsType = 12;
   float endAlpha = 0;
   vector startSize = <1.9,1.9,1.9>;
   vector endSize = <1.9,1.9,1.9>;
   vector omega = <0.0,30.0, 0.0>;
   float systemAge = 5.0;
   float primGlow = 0.4;
#elif defined TRAILBALL
   float partSpeed = 10;
   vector partOmega = <0.0,0.0,10*PI>;
   integer wind = 0;
   float systemAge = 5;
   float primGlow = 0.4;
   #include "effects\effect_trailball.lsl"
#elif defined SPARKLERBALL
#else
   //integer effectsType = 2;
   float endAlpha = 0;
   vector startSize = <1.9,1.9,1.9>;
   vector endSize = <1.9,1.9,1.9>;
   float systemAge = 1.0;
   vector omega = <0.0,0.0,0.0>;
   float primGlow = 0.4;
   #include "effects\effect_standard_rocketball.lsl"
#endif

default
{
   state_entry()
   {
      //debug = TRUE;
      #if !defined HOTLAUNCH
         AllOff();
      #endif
      #if defined RINGBALL
         //llTargetOmega(<0,0,0.05>,4*PI,1.0);
         //llTargetOmega(<0,0,0>,PI,1.0);
         //partSpeed1 = 0.7;
         //partSpeed2 = 0.7;
      #endif
   }

   //having touch_start makes some effects easier to debug
   touch_start(integer n)
   {
       boom();
   }

   on_rez(integer p)
   {
      llResetTime();
      if (p > 0)
          setColor(LINK_SET,launchColor,0.0);
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
      rezParam = p; //save this
      flightTime = (float)(p & 0x7F)/10.0;
      float bouy = (float)((p & 0x3F80) >> 7)/100.0;
      llSetBuoyancy(bouy);
      integer chan = (-42000) -((p & 0x3FC000) >>14);
      //debugSay("p2 ="+ (string)p2);
      //debugSay("chan = "+(string)chan);
      //debugSay("flightTime ="+ (string)flightTime);
      handle=llListen(chan,"","","");
      if (p & DEBUG_MASK)
         debug = TRUE;
      else
         debug = FALSE;
      if (p & COLLISION_MASK)
         explodeOnCollision = 1; 
      if (p & FREEZE_MASK)
         freezeOnBoom = TRUE;
      //llCollisionSound("", 1.0);  //  Disable collision sounds
      rotation r = llGetRot();
      #if defined PRIM_ROTATION
         //r.z = -r.z;
         //r.x = -r.x;
         //r.y = -r.y; 
      #endif
      vector v = llGetVel();
      setParamsFast(LINK_SET,[PRIM_SIZE,primSize]);
      llSetVelocity(v,FALSE);  //because setting the prim size sets velocity to zero
      #if defined POINTFORWARD
         llLookAt(v+llGetPos(), 0.5, 0.1);
      #else
         llSetRot(r);
      #endif
      // we don't know the color yet
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
      //integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
      //float gravity = 1.0;
      //float restitution = 0.3;
      //float friction = 0.9;
      //float density = 1000; //500
      //llSetPhysicsMaterial(mask,gravity,restitution,friction,density);
      if (rezParam>0)
      {   //use timer instead of sleeping to allow other events
          llSetTimerEvent(0.1);
          //debugSay("time is " + (string)t + " param2 is " + (string) bouy);
      }
   }

   listen( integer chan, string name, key id, string msg )
   {
      llListenRemove(handle);
      //debugSay(" listener got: "+ msg);
      params = llCSV2List(msg); 
      texture = llList2String(params,0);
      color1 = llList2String(params,1);
      color2 = llList2String(params,2);
      color3 = llList2String(params,3);
      systemAge = llList2Float(params,4);
      boomVolume = llList2Float(params,5);
      primColor = color1;
      lightColor = color1;
      //e = llList2Integer(emitters,i);
      setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)primColor,1.0]);
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
      armed = TRUE;
   }

   timer()
   {
      #if defined POINTFORWARD
      llLookAt( llGetVel()+llGetPos(), 0.5, 0.1);
      #endif
      totalTime = totalTime+0.1;
      if (totalTime>flightTime)
      {
          debugSay("timed out");
          llSetTimerEvent(0);
          if (armed)
              boom();
      }
   }

   #ifdef EXPLODE_ON_COLLISION
   collision_start(integer n)
   {
      integer f = 0;
      key id;
      vector spd;
      debugSay(llGetScriptName() + ": collision ");
      if ((explodeOnCollision==0) || (!armed))
         return;
      debugSay(llGetScriptName() + ": acting on collision ");
      debugSay( "me @ " +(string)llVecMag(spd = llGetVel())+"m/s");
      for (f=0; f<n; f++)
      {
         debugSay(llDetectedName(f) + " @ " + (string)llRound(llVecMag(llDetectedVel(f))) + "m/s");
      }
      f = 0;
      do
      {
         // if (llVecMag(llDetectedVel(f)) >= minimumCollisionSpeed)
         {
            if (rezParam!=0)
            {
               #if defined TRAILBALL
                  AllOff();
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
      debugSay("collision with land");
      if (rezParam !=0)
      {
         #if defined TRAILBALL
            AllOff();
            llSetStatus(STATUS_PHYSICS, FALSE);
            llDie();
         #else
         boom();
         #endif
      }
   }
   #endif
}

boom()
{
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   debugSay("boom");
   setColor(LINK_THIS,(vector)primColor,0.0);
   setGlow(LINK_THIS,primGlow2);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_SIZE, primSize]);
   if (freezeOnBoom)
   {
      debugSay("freezing");
      llSetStatus(STATUS_PHYSICS,FALSE);
      llSetStatus(STATUS_PHANTOM,TRUE);
   }
   #if defined ROT_90
      llSetRot(llEuler2Rot(<0,PI_BY_TWO,0>) * llGetRot());
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
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   setGlow(LINK_THIS,0.0);
   llSleep(systemAge);
   AllOff();
   llSetTimerEvent(0);
   if (rezParam !=0)
   {
       llSetStatus(STATUS_PHYSICS, FALSE);
       llDie();
   }
   llSleep(5); //dunno why this is needed - but without it, no boom
}

AllOff()
{
   llParticleSystem([]);
   setGlow(LINK_THIS,0.0);
   setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,1.0]);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   llLinkParticleSystem(LINK_THIS,[]);
}

string parseColor2(string c)
{
   string color;
   //color = getString(n,c);
   if (llSubStringIndex(c,"<")== -1)
       color = (string)iwNameToColor(c);
   return color;
}
