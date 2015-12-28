/*
* fountain emmiter type projectile v1.2   2015/12/25
* copyright Tracer Ping 2015
*/
///#define EXPLODE_ON_COLLISION
#define PRIM_ROTATION
#include "lib.lsl"

string texture = TEXTURE_CLASSIC;
integer rezParam;
vector particleColor = (vector)COLOR_WHITE;
vector color1 = (vector)COLOR_WHITE;
vector color2 = (vector)COLOR_WHITE;
vector primColor = (vector)COLOR_WHITE;
vector lightColor = (vector)COLOR_WHITE;
float intensity = 1.0;
float radius = 5; //10 to 20
float falloff = 0.2; //0.02 to 0.75
float primGlow = 0.0;
float breakSpeed = 10;
float primSize = 0.3;
string sound1 = SOUND_PUREBOOM;
float partSpeed = 10;
vector partOmega = <0.0,0.0,10*PI>;
integer wind = 0;
float SystemSafeSet = 0.00;//prevents erroneous particle emissions
float SystemAge = 99;//life span of the particle system

default
{
   state_entry()
   {
      llParticleSystem([]);
   }
   
   //having touch_start makes these easier to debug
   touch_start(integer n)
   {
       fire();
   }
   
   on_rez(integer p)
   {
      float bouy = 5;
      rezParam = p;
      float t = p & 0xFF;
      float time = t;
      SystemAge =t*2;
      integer p2 = (p & 0xFF00) / 16; 
      if (p2 > 0)
         bouy = p2;
      llSetBuoyancy(bouy/100);
      //llCollisionSound("", 1.0);  //  Disable collision sounds
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      setParamsFast(0,[PRIM_TEMP_ON_REZ,TRUE]);
      rotation rot = llGetRot();
      //rot.z = -rot.z;
      //rot.x = -rot.x;
      rot.y = -rot.y; 
      #if defined PRIM_ROTATION
        llSetRot(rot); 
      #endif
      setParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,primGlow]);
      setParamsFast(0,[PRIM_COLOR,ALL_SIDES,(vector)primColor,1.0]);
      setParamsFast(0,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
      setParamsFast(0,[PRIM_SIZE, <primSize,primSize,primSize>]);
      integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
      float gravity = 0.8;
      float restitution = 0.3;
      float friction = 0.9;
      float density = 500;
      llSetPhysicsMaterial(mask,gravity,restitution,friction,density);

      llSleep(t);
      fire();
   }
}

fire()
{
   //llPlaySound(sound2, VOLUME );
   //repeatSound(sound2);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,primGlow]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,color1,1.0]);
   SystemSafeSet = SystemAge;
   llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,radius,falloff]);
   makeParticles(color1);
   debugSay("boom");
   llSleep(SystemAge);
   SystemSafeSet = 0.0;
   llParticleSystem([]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,1.0]);
   if (rezParam >0)
   {
      llDie();
   }
}

makeParticles(vector color)
{
   SystemSafeSet = SystemAge;
   integer flags;
   flags = 0 | PSYS_PART_EMISSIVE_MASK
     | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK
     | PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   //PSYS_PART_FOLLOW_SRC_MASK ? maybe...
   llParticleSystem([
      PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
      PSYS_SRC_BURST_RADIUS,      0.3,
      PSYS_SRC_ANGLE_BEGIN,       PI/30,
      PSYS_SRC_ANGLE_END,         0,
      PSYS_PART_START_COLOR,      color1,
      PSYS_PART_END_COLOR,        color2,
      PSYS_PART_START_ALPHA,      1.0,
      PSYS_PART_END_ALPHA,        0.3,
      PSYS_PART_START_SCALE,      <1.0,1.0,0.0>,
      PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
      PSYS_SRC_TEXTURE,           texture,
      PSYS_SRC_MAX_AGE,           SystemSafeSet,
      PSYS_PART_MAX_AGE,          5.0,
      PSYS_SRC_BURST_RATE,        0.02,
      PSYS_SRC_BURST_PART_COUNT,  10.0,
      PSYS_SRC_ACCEL,             <0.0,0.0,-2.0>,
      PSYS_SRC_OMEGA,             partOmega,
      PSYS_SRC_BURST_SPEED_MIN,   (partSpeed * 1.2),
      PSYS_SRC_BURST_SPEED_MAX,   (partSpeed * 1.4),
      PSYS_PART_FLAGS,flags
   ]);
}

