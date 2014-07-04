/////////////////////////
// fountain emmiter type projectile
// this goes in the projectile, which in turn
// goes in the launcher
////////////////////////
#include "lib.lsl"

string texture = TEXTURE_CLASSIC;

integer rezParam;

vector particleColor = (vector)COLOR_GOLD;
vector color1 = (vector)COLOR_GOLD;
vector color2 = (vector)COLOR_GOLD;
vector primColor = (vector)COLOR_GOLD;
vector lightColor = (vector)COLOR_GOLD;
float intensity = 1.0;
float radius = 20; //10 to 20
float falloff = 0.02; //0.02 to 0.75
float primGlow = 0.4;
float breakSpeed = 10;
float primSize = 0.3;
string sound1 = SOUND_FOUNTAIN1;

float SystemSafeSet = 0.00;//prevents erroneous particle emissions
float SystemAge = 1;//life span of the particle system
float speed = 10;

makeParticles(vector color)
{
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
       PSYS_SRC_OMEGA,             <0,0.0,10*PI>,
       PSYS_SRC_BURST_SPEED_MIN,   (speed * 1.2),
       PSYS_SRC_BURST_SPEED_MAX,   (speed * 1.4),
       PSYS_PART_FLAGS,0|
          PSYS_PART_EMISSIVE_MASK |
          PSYS_PART_INTERP_COLOR_MASK |
          PSYS_PART_INTERP_SCALE_MASK |
          //PSYS_PART_FOLLOW_SRC_MASK |
          PSYS_PART_FOLLOW_VELOCITY_MASK
    ]);
}

fire()
{
    //llPlaySound(sound2, VOLUME );
    //repeatSound(sound2);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0]);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
    SystemSafeSet = SystemAge;
    llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,radius,falloff]);
    makeParticles(color1);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llParticleSystem([]);
    //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0]);
    //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,0.0]);
       if (rezParam >0)
       {
         llDie();
	 }
    }

default
{
    state_entry()
    {
       llParticleSystem([]);
    }

   on_rez(integer p)
   {
        rezParam = p;
        integer t = p & 0xFF;
        float bouy = (p & 0xFF00) / 16; 
        llSetBuoyancy(bouy/10);
        //llCollisionSound("", 1.0);  //  Disable collision sounds
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        llSetLinkPrimitiveParamsFast(0,[PRIM_TEMP_ON_REZ,TRUE]);
        rotation rot = llGetRot();
        //   rot.z = -rot.z;
        //rot.x = -rot.x;  
        rot.y = -rot.y; 
        llSetRot(rot); 
        
        //fullbright?
        //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0]);
        llSetLinkPrimitiveParamsFast(0,[PRIM_COLOR,ALL_SIDES,primColor,1.0]);

        llSetLinkPrimitiveParamsFast(0,[PRIM_SIZE, <primSize,primSize,primSize>]);
        integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
        float gravity = 0.8;
        float restitution = 0.3;
        float friction = 0.9;
        float density = 500;
        llSetPhysicsMaterial(mask,gravity,restitution,friction,density);

       llSleep(param);
       fire();

   }   


}


