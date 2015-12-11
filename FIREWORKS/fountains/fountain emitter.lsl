/////////////////////////
//Fireworks Fountain emitter v1.20
//Tracer Ping July 2014
///////////////////////////
#include "lib.lsl"

string color1; 
string color2;
string color3;
string lightColor = COLOR_WHITE;
string texture = TEXTURE_CLASSIC;
string sound = SOUND_FOUNTAIN1;
integer emitter;
string emitterName = "e1";
float speed = 10; //5 to 10
float omega = 0; //10*PI;  //0 to 10*PI
float SystemAge = 4.5; //4 to 4.5
float SystemSafeSet = 0.00;

default
{
    on_rez(integer n){llResetScript();}

    state_entry()
    {
       emitter = getLinkWithName(emitterName);
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
           }
           texture = id;
           fire();
        }
    }
}

fire()
{
    float oldAlpha = llGetAlpha(ALL_SIDES);
    integer numOfEmitters = 1;
    //llPlaySound(sound, volume/numOfEmitters);
    llTriggerSound(sound, volume/numOfEmitters);
    repeatSound(sound,volume/numOfEmitters);
    llSetLinkPrimitiveParamsFast(emitter,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
    llSetLinkPrimitiveParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)color1,1.0]);
    glow(emitter,1.0);
    SystemSafeSet = SystemAge;
    makeParticles(emitter,color1,color2);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llLinkParticleSystem(emitter,[]);
    glow(emitter,0.0);
    llSetLinkPrimitiveParamsFast(emitter,[PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    llSetLinkPrimitiveParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,oldAlpha]);
}

makeParticles(integer link, string color1, string color2)
{
    llLinkParticleSystem(link,[
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_SRC_BURST_RADIUS,      0.35, // 0.3 to 0.4
    PSYS_SRC_ANGLE_BEGIN,       PI/14, // PI/30 to PI/14
    PSYS_SRC_ANGLE_END,         0,
    PSYS_PART_START_COLOR,      (vector)color1,
    PSYS_PART_END_COLOR,        (vector)color2,
    PSYS_PART_START_ALPHA,      1.0,
    PSYS_PART_END_ALPHA,        0.3,
    PSYS_PART_START_SCALE,      <1.0,1.0,0.0>, //0.3 to 1.0
    PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
    PSYS_SRC_TEXTURE,           texture,
    PSYS_SRC_MAX_AGE,           SystemSafeSet,
    PSYS_PART_MAX_AGE,          5.0, //4 to 5
    PSYS_SRC_BURST_RATE,        0.02,
    PSYS_SRC_BURST_PART_COUNT,  10.0,
    PSYS_SRC_ACCEL,             <0.5,0.0,-2.0>, //x=0 to x = 0.5
    PSYS_SRC_OMEGA,             <0.0,0.0,omega>,
    PSYS_SRC_BURST_SPEED_MIN,   (1.2*speed),
    PSYS_SRC_BURST_SPEED_MAX,   (1.4*speed),
    PSYS_PART_FLAGS,0|
       PSYS_PART_EMISSIVE_MASK |
       PSYS_PART_INTERP_COLOR_MASK |
       PSYS_PART_INTERP_SCALE_MASK |
       //PSYS_PART_FOLLOW_SRC_MASK |
       PSYS_PART_FOLLOW_VELOCITY_MASK
    ]);
}

