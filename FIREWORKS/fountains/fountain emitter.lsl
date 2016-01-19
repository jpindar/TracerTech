/////////////////////////
//Fireworks Fountain emitter v2.0
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
float omega = 0;
float systemAge = 4.5; //4 to 4.5
  #include "effects\effect_fountain1.lsl"

default
{
    on_rez(integer n){llResetScript();}

    state_entry()
    {
       llPreloadSound(sound);
       emitter = getLinkWithName(emitterName);
       llLinkParticleSystem(emitter,[]);
       setParamsFast(emitter,[PRIM_FULLBRIGHT,ALL_SIDES,TRUE]);
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
              //lightColor = color1;
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
    setParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)color1,1.0]);
    glow(emitter,1.0);
    makeParticles(emitter,color1,color2);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llLinkParticleSystem(emitter,[]);
    glow(emitter,0.0);
    setParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,oldAlpha]);
}

