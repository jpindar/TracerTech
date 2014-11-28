/////////////////////////
// active cannonball
// this goes in the projectile, which in turn
// goes in the launcher
////////////////////////
#include "lib.lsl"
#define EXPLODE_ON_COLLISION

integer debug = FALSE;
integer effectsType = 4; 
string texture = TEXTURE_SMOKEBALL;
integer rezParam;
string particleColor = COLOR_WHITE;
string color1 = COLOR_WHITE;
string color2 = COLOR_WHITE;
string primColor = COLOR_WHITE;
string lightColor = COLOR_WHITE;
float intensity = 1.0;
float radius = 20; //10 to 20
float falloff = 0.02; //0.02 to 0.75
float primGlow = 0.4;
float breakSpeed = 10;
float primSize = 0.3;
string sound1 = SOUND_PUREBOOM;
integer index;
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
float endAlpha = 0;
vector startSize = <1.9,1.9,1.9>;
vector endSize = <1.9,1.9,1.9>;
float particleSpeed = 3;
float systemSafeSet = 0.00;
float systemAge = 0.1;
float flightTime;

#define FLYING 0
integer mode=FLYING;  //mode for using timer, 0 is flying, 1 is dying
vector lastPos;    //where I was last tick

#include "effectslib.lsl"

default
{
   state_entry()
   {
      llOwnerSay("reset");
      llSetStatus(STATUS_PHYSICS,TRUE);
      llSetStatus(STATUS_PHANTOM,FALSE);
      glow(LINK_THIS,0.0);
      setParamsFast(0,[PRIM_COLOR,ALL_SIDES,<0.5,0.5,0.5>,1.0]);
      setParamsFast(0,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
      llParticleSystem([]);
    }

   on_rez(integer p)
   {
       #define DEBUG_MASK 0x01
       llSetTimerEvent(0);
       if (p == 0)
          {
              llSay(0,"not rezzed");
              return;
          }
       rezParam = p; //save for later
       integer p1 = p & 0xFF; p = p / 0x100;
       integer p2 = p & 0xFF; p = p / 0x100;
       integer p3 = p & 0xFF; p = p / 0x100;
       integer p4 = p & 0xFF;
       flightTime = ((float)p1)/10;
       float bouy = 5/100;
       if (p2 > 0)
          bouy = p2/100;
       debugSay("rezzed, param1 = " +(string)flightTime +" param2 = " + (string)p2);   
       llSetBuoyancy(bouy);
       //llCollisionSound("", 1.0);  //  Disable collision sounds
       llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
       setParamsFast(0,[PRIM_TEMP_ON_REZ,TRUE]);
       setParamsFast(0,[PRIM_COLOR,ALL_SIDES,(vector)primColor,1.0]);
       setParamsFast(0,[PRIM_SIZE, <primSize,primSize,primSize>]);
       integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
       float gravity = 0.8;
       float restitution = 0.3;
       float friction = 0.9;
       float density = 500;
       llSetPhysicsMaterial(mask,gravity,restitution,friction,density);
       if (p4 & DEBUG_MASK)
       {
          glow(LINK_THIS,primGlow);
       }
       mode=FLYING;
       lastPos=llGetPos();
       //if (t==0)  //because 0 means no timer effect
       //    t = 0.01;
       llResetTime();
       llSetTimerEvent(0.09);  //check often for water
   }

   timer()
   {
      if (llGetStartParameter()==0) return;
      if (mode!=FLYING){llDie();}
      if (llGetTime()>flightTime)
      {
         debugSay("timed out");
         llSetTimerEvent(0);
         boom();
         return;
       }
      vector pos=llGetPos(); 
      if (llVecDist(pos,lastPos)<0.010)   //if you stop for any reason (edge of world)
      {
         debugSay("stopped moving");
         llSetTimerEvent(0);
         boom();
         return;
       }
      float wat=llWater(ZERO_VECTOR); //how high the water is
      if (lastPos.z>wat && pos.z<=wat) //did I pass through the water surface?
      {
           llSetStatus(STATUS_PHYSICS,FALSE); //stop where you are
           //interpolate your position back to water's surface
           pos=lastPos+(pos-lastPos)*(lastPos.z-wat)/(lastPos.z-pos.z);
           //sit on the surface and rotate to 0 so the particle explosion goes up
           llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION,ZERO_ROTATION,PRIM_POSITION,pos]);
           //faster than setAlpha?
           llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR, 0, <0,0,0>, 0.0]);//become invisible, so they only see particles
           llSetStatus(STATUS_PHANTOM,TRUE);
           debugSay("splash");
           makeSplash();
           llSetTimerEvent(2);//give the particles and sound time to happen
           mode=!FLYING; //then die
      }
      lastPos=pos;
   }//end timer

#ifdef EXPLODE_ON_COLLISION
   collision_start(integer n)
   {
       integer f = 0;
       key id;
       vector spd;
       debugSay(llGetScriptName() + ": collision ");
       debugSay( "me @ " +(string)llVecMag(spd = llGetVel())+"m/s");
       for (f=0; f<n; f++)
       {
           debugSay(llDetectedName(f) + " @ " + (string)llRound(llVecMag(llDetectedVel(f))) + "m/s");
       }
       f = 0;
       do
       {
          // if (llVecMag(llDetectedVel(f)) >= breakSpeed)
           {
               boom();
           }
       } while (++f < n);
   }

   land_collision_start(vector pos)
   {
      debugSay("collision with land");
      boom();
   }
#endif
}

boom()
{
   if (rezParam == 0)
   {
      debugSay("I would boom, but I wasn't shot");
      return;
   }
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   //debugSay("boom");
   systemSafeSet = systemAge;
   setParamsFast(0,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, 0.0]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)primColor,0.0]);
   makeParticles(effectsType,(vector)color1,(vector)color2,texture);
   llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   llPlaySound(sound1,volume);
   llSleep(systemAge);
   systemSafeSet = 0.0;
   llParticleSystem([]);
   llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0.0]);
   llSleep(systemAge);
   llSetTimerEvent(0);
   mode=!FLYING; //then die
   if (rezParam !=0)
   {
       llSetStatus(STATUS_PHYSICS, FALSE);
       llSetStatus(STATUS_PHANTOM, TRUE);
       llDie();
   }
   llSleep(5); //dunno why this is needed - but without it, no boom
}

makeSplash()
{
           llParticleSystem([
               PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_WIND_MASK|PSYS_PART_EMISSIVE_MASK ,
               PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
               PSYS_SRC_BURST_RADIUS, 0.2,
               PSYS_SRC_ANGLE_BEGIN, 0.0,
               PSYS_SRC_ANGLE_END, 0.4,
               PSYS_PART_START_COLOR, <0.125,.25,.35>,    //start aquamarine
               PSYS_PART_END_COLOR, <1,1,1>,            //fade to white
               PSYS_PART_START_ALPHA, 1.0,                //start opaque
               PSYS_PART_END_ALPHA, 0.0,                //fade to transparent
               PSYS_PART_START_SCALE, <0.5,0.5,1>,     //start small
               PSYS_PART_END_SCALE, <4.0,4.0,1>,       //end big
               PSYS_SRC_TEXTURE,"",                    //default texture
               PSYS_SRC_MAX_AGE, 0.3,                    //explosion emits for only this long
               PSYS_PART_MAX_AGE, 5.0,                    //each particle lives this long
               PSYS_SRC_BURST_RATE, 0.02,                //a value of 0 here "starves" other emitters
               PSYS_SRC_BURST_PART_COUNT, 20,            //how many per burst
               PSYS_SRC_ACCEL, <0,0,-4.0>,                //make them fall back down
               PSYS_SRC_BURST_SPEED_MIN, 6.0,            //how fast they jump
               PSYS_SRC_BURST_SPEED_MAX, 8.0
           ]);
}