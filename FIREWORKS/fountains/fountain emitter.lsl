//Fireworks Fountain v1.14
//Tracer Ping July 2014

vector color1;
vector color2;
string texture;
string sound = "1339a082-66bb-4d4b-965a-c3f13da18492";
float SystemAge = 4.0;//life span of the particle system
float SystemSafeSet = 0.00;//prevents erroneous particle emissions
integer preloadFace = 2;

#include "lib.lsl"

makeParticles(vector color)
{
    llParticleSystem([
    PSYS_PART_FLAGS , 0
    | PSYS_PART_INTERP_COLOR_MASK
    | PSYS_PART_INTERP_SCALE_MASK
 //   | PSYS_PART_FOLLOW_SRC_MASK
    | PSYS_PART_FOLLOW_VELOCITY_MASK
    | PSYS_PART_EMISSIVE_MASK,
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_SRC_TEXTURE,           texture,
    PSYS_SRC_MAX_AGE,           SystemSafeSet,
    PSYS_PART_MAX_AGE,          5.0,
    PSYS_SRC_BURST_RATE,        0.02,
    PSYS_SRC_BURST_PART_COUNT,  10.0,
    PSYS_SRC_BURST_RADIUS,     0.3,
    PSYS_SRC_BURST_SPEED_MIN,   12.0,
    PSYS_SRC_BURST_SPEED_MAX,   14.0,
    PSYS_SRC_ACCEL,             <0.5,0.0,-2.0>,
    PSYS_PART_START_COLOR,      color1,
    PSYS_PART_END_COLOR,        color2,
    PSYS_PART_START_ALPHA,      1.0,
    PSYS_PART_END_ALPHA,        0.3,
    PSYS_PART_START_SCALE,      <1.5,1.5,0.0>,
    PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
    PSYS_SRC_ANGLE_BEGIN,       PI_BY_TWO /7,
    PSYS_SRC_ANGLE_END,         0,
    PSYS_SRC_OMEGA,             <0.0,0.0,0.0>
    ]);
}

fire()
{
   // llPlaySound(sound, VOLUME );
    llTriggerSound(sound, VOLUME);
    repeatSound(sound);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0,PRIM_FULLBRIGHT,ALL_SIDES,TRUE,PRIM_COLOR,ALL_SIDES,color1,1.0]);
    SystemSafeSet = SystemAge;
    makeParticles(color1);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llParticleSystem([]);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0,PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    }

default
{
    state_entry()
    {
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



