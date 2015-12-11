/////////////////////////
// fireworks burst v2.0
// by Tracer Ping
// copyright July 2014
///////////////////////////
#include "lib.lsl"

string color1; 
string color2;
string color3;
string lightColor = COLOR_WHITE;
string texture;
string sound = SOUND_BURST1;
float glowAmount = 1.0; // or 0.2
integer emitter = LINK_THIS;
float intensity = 1.0;
float radius = 20;
float falloff = 0.02;
float speed = 1;
float SystemAge = 1.75; //1.75 for normal, 1.0 or even 0.5 for multiple bursts
float SystemSafeSet = 0.00;

default
{
    on_rez(integer n){llResetScript();}

    state_entry()
    {
       //llPreloadSound(sound);
       llLinkParticleSystem(emitter,[]);
    }

    link_message( integer sender, integer num, string msg, key id )
    {
        if (num & RETURNING_NOTECARD_DATA)
            notecardList = llCSV2List(msg);
        volume =  getVolume();
        if ( num & FIRE_CMD ) //to allow for packing more data into num
        {
           if (llStringLength(msg) > 0)
           {
              color1 = llGetSubString(msg, 0, 15); //<0.00,0.00,0.00> = 16 chars
              color2 = llGetSubString(msg, 16, 31); //<0.00,0.00,0.00> = 16 chars
              color3 = llGetSubString(msg, 32, 47); //<0.00,0.00,0.00> = 16 chars
              lightColor = color1;
           }
           texture = id;
           fire();
        }
    }
}

fire()
{
   float oldAlpha = llGetAlpha(ALL_SIDES);
   //fast or not?
   llSetLinkPrimitiveParamsFast(emitter,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   llSetLinkPrimitiveParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)color1,1.0]);
   glow(emitter,glowAmount);
   integer numOfEmitters = 1;
   // llPlaySound(sound, volume/numOfEmitters);
   llTriggerSound(sound, volume/numOfEmitters);
   repeatSound(sound,volume/numOfEmitters);
   makeParticles(emitter,color1,color2);
   llSleep(0.5);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   glow(emitter,0.0);
   setParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,oldAlpha]);
   llSleep(SystemAge+1);// +1?
   SystemSafeSet = 0.0;
   llLinkParticleSystem(emitter,[]);
}

makeParticles(integer link, string color1, string color2)
{
    SystemSafeSet = SystemAge;
    llLinkParticleSystem(link,[
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
    PSYS_SRC_BURST_RADIUS,0.0,
    PSYS_SRC_ANGLE_BEGIN,0.0,
    PSYS_SRC_ANGLE_END,0.0,
    PSYS_PART_START_COLOR,(vector)color1,
    PSYS_PART_END_COLOR,  (vector)color2,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.1,
    PSYS_PART_START_SCALE, <0.5, 0.5, 0.0>,
    PSYS_PART_END_SCALE,   <0.5, 0.5, 0.0>,
    PSYS_SRC_TEXTURE, texture,
    PSYS_SRC_MAX_AGE, SystemSafeSet,
    PSYS_PART_MAX_AGE, 5.0,
    PSYS_SRC_BURST_RATE, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 250,
    PSYS_SRC_ACCEL,<0.0,0.0,-0.3>,
    PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
    PSYS_SRC_BURST_SPEED_MIN, (1.5*speed),
    PSYS_SRC_BURST_SPEED_MAX, (1.5*speed),
       PSYS_PART_FLAGS,0 |
       PSYS_PART_EMISSIVE_MASK |
       PSYS_PART_FOLLOW_VELOCITY_MASK |
       PSYS_PART_INTERP_COLOR_MASK |
       PSYS_PART_INTERP_SCALE_MASK |
       PSYS_PART_WIND_MASK
    ]);
   SystemSafeSet = 0.0;
}

