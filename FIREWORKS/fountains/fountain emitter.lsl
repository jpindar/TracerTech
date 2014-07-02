/////////////////////////
//Fireworks Fountain emitter v1.20
//Tracer Ping July 2014
///////////////////////////
#include "lib.lsl"

vector color1;
vector color2;
string texture;
string sound = SOUND_FOUNTAIN1;
integer preloadFace = 2;
float SystemAge = 4.0;//life span of the particle system
float SystemSafeSet = 0.00;//prevents erroneous particle emissions
float speed = 10;

makeParticles(vector color)
{
    llParticleSystem([
       PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
       PSYS_SRC_BURST_RADIUS,      0.3,
       PSYS_SRC_ANGLE_BEGIN,       PI_BY_TWO /7,
       PSYS_SRC_ANGLE_END,         0,
       PSYS_PART_START_COLOR,      color1,
       PSYS_PART_END_COLOR,        color2,
       PSYS_PART_START_ALPHA,      1.0,
       PSYS_PART_END_ALPHA,        0.3,
       PSYS_PART_START_SCALE,      <1.5,1.5,0.0>,
       PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
       PSYS_SRC_TEXTURE,           texture,
       PSYS_SRC_MAX_AGE,           SystemSafeSet,
       PSYS_PART_MAX_AGE,          5.0,
       PSYS_SRC_BURST_RATE,        0.02,
       PSYS_SRC_BURST_PART_COUNT,  10.0,
       PSYS_SRC_ACCEL,             <0.5,0.0,-2.0>,
       PSYS_SRC_OMEGA,             <0.0,0.0,0.0>
       PSYS_SRC_BURST_SPEED_MIN,   (1.2*speed),
       PSYS_SRC_BURST_SPEED_MAX,   (1.4*speed),
       PSYS_PART_FLAGS,0|
          PSYS_PART_EMISSIVE_MASK |
          PSYS_PART_INTERP_COLOR_MASK |
          PSYS_PART_INTERP_SCALE_MASK |
          //PSYS_PART_FOLLOW_SRC_MASK |
          PSYS_PART_FOLLOW_VELOCITY_MASK,
    ]);
}

fire()
{
   // llPlaySound(sound, VOLUME );
    llTriggerSound(sound, VOLUME);
    repeatSound(sound);
    GLOW_ON;
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,color1,1.0]);
    SystemSafeSet = SystemAge;
    makeParticles(color1);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llParticleSystem([]);
    GLOW_OFF;
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,1.0]);
    }

default
{
    state_entry()
    {
      // llSetTexture(texture,preloadFace);
       llParticleSystem([]);
    }

    link_message( integer sender, integer num, string msg, key id )
    {
        if ( num & FIRE_CMD ) //to allow for future packing more data into num
        {
           color1 = (vector)llGetSubString(msg, 0, 15); //<0.00,0.00,0.00> = 16 chars
           color2 = (vector)llGetSubString(msg, 16, 31); //<0.00,0.00,0.00> = 16 chars
           texture = id;
           fire();
        }
    }

}


