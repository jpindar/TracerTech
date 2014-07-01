/////////////////////////
// fireworks burst v1.14
//Tracer Ping  July 2014
///////////////////////////
#include "lib.lsl"

vector color1;
vector color2;
string texture = "6189b78f-c7e2-4508-9aa2-0881772c7e27";
string sound ="a2b1025e-1c8a-4dfb-8868-c14a8bed8116";
vector lightColor;
float intensity = 1.0;
float radius = 20;
float falloff = 0.02;
integer preloadFace = 2;
float SystemSafeSet = 0.00;
float SystemAge = 1.75;

makeParticles(vector color1, vector color2)
{
   llParticleSystem([
   PSYS_PART_FLAGS,0
      | PSYS_PART_INTERP_COLOR_MASK
      | PSYS_PART_INTERP_SCALE_MASK
      | PSYS_PART_EMISSIVE_MASK
      | PSYS_PART_FOLLOW_VELOCITY_MASK,
    PSYS_SRC_PATTERN, 2,
    PSYS_SRC_TEXTURE, texture,
    PSYS_SRC_MAX_AGE, SystemSafeSet,
    PSYS_PART_MAX_AGE, 5.0,
    PSYS_PART_START_SCALE, <0.5, 0.5, 0.0>,
    PSYS_PART_END_SCALE,   <0.5, 0.5, 0.0>,
    PSYS_PART_START_COLOR, color1,
    PSYS_PART_END_COLOR, color2,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 500,
    PSYS_SRC_BURST_RATE, 0.2,
    PSYS_SRC_BURST_SPEED_MIN, 1.5,
    PSYS_SRC_BURST_SPEED_MAX, 1.5,
    // PSYS_SRC_BURST_RADIUS, 0.0,
    PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >
    ]);
}

fire()
{
   // llPlaySound(sound, VOLUME );
   llTriggerSound(sound, VOLUME);
   repeatSound(sound);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,radius,falloff]);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0,PRIM_FULLBRIGHT,ALL_SIDES,TRUE,PRIM_COLOR,ALL_SIDES,color1,1.0]);
   SystemSafeSet = SystemAge;
   makeParticles(color1,color2);
   llSleep(1);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,lightColor,intensity,radius,falloff]);
   llSleep(SystemAge);
   SystemSafeSet = 0.0;
   llParticleSystem([]);
   //llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0,PRIM_FULLBRIGHT,ALL_SIDES,FALSE,PRIM_COLOR,ALL_SIDES,<1.0,1.0,1.0>,1.0]);
}

default
{
    changed(integer change){if(change & CHANGED_INVENTORY){llResetScript();}}

    state_entry()
    {
       llSetTexture(texture,preloadFace);
       llParticleSystem([]);
    }

    link_message( integer sender, integer num, string msg, key id )
    {
        if (num & FIRE_CMD) //to allow for future packing more data into num
        {
           color1 = (vector)llGetSubString(msg, 0, 15); //<0.00,0.00,0.00> = 16 chars
           color2 = (vector)llGetSubString(msg, 16, 31); //<0.00,0.00,0.00> = 16 chars
           lightColor = color1;
           texture = id;
           fire();
        }
    }

}


