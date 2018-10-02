/*
*Fireworks burst emitter v2.7
*Tracer Ping Sept 2018
*/

#define TRACERGRID
//#define SOAS

//#define DEBUG

#include "LIB\lib.lsl"

string color1;
string color2;
string color3;
string lightColor;
string texture;
//string sound = SOUND_BURST1;
string sound = SOUND_PUREBOOM;
float intensity = 1.0;
float radius = 20;
float falloff = 0.1;
float speed = 1;
float oldAlpha;
list colors;
list emitters;
list params;
float systemAge;
float particleAge;
float flashTime = 0.2;
float startGlow;
float endGlow;

#ifdef TRIPLE
   float glowAmount = 1.0; // or 0.2
   list emitterNames = ["e1"];
   integer numOfEmitters = 1;
   float interEmitterDelay = 0.1;
   #include "LIB\effects\effect_standard_burst_exp1.lsl"
#else
   float glowAmount = 0.5; // or 0.2
   //list emitterNames = ["e1"];
   list emitterNames = ["e1","e2","e3"];
   integer numOfEmitters = 1;
   float interEmitterDelay = 0.5;
   #include "LIB\effects\effect_standard_burst.lsl"
#endif

fire()
{
   integer i;
   integer e;

   oldAlpha = llGetAlpha(ALL_SIDES);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,0.0]);
   // try repeating this section to make FAST series bursts

   for(i=0;i<numOfEmitters;i++)
   {
      //llPlaySound(sound, volume/numOfEmitters);  //only if the are simultaneous?
      llPlaySound(sound, volume);
      repeatSound(sound,volume);
      color1 = llList2String(colors,i*2);
      color2 = llList2String(colors,(i*2)+1);
      e = llList2Integer(emitters,i);
      setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,TRUE,(vector)color1,intensity,radius,falloff]);
      setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)color1,0.0]);
      setGlow(e,glowAmount);
      makeParticles(e,color1,color2);
      llSleep(flashTime);
      setGlow(LINK_SET,0.0);
      setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
      llSleep(interEmitterDelay);
   }
   llSleep(systemAge+particleAge);
   allOff();
}

allOff()
{
   integer i;
   integer e;
   setGlow(LINK_SET,0.0);
   for(i=0;i<numOfEmitters;i++)
   {
      e = llList2Integer(emitters,i);
      setParamsFast(e,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
      llLinkParticleSystem(e,[]);
   }
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,oldAlpha]);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   llLinkParticleSystem(LINK_SET,[]);
   setGlow(LINK_SET,0.0);
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,oldAlpha]);
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      llPreloadSound(sound);
      emitters = getLinknumbers(emitterNames);
      oldAlpha = llGetAlpha(ALL_SIDES);
      allOff();
   }

   //link messages come from the controller
   link_message( integer sender, integer num, string msg, key id )
   {
      integer i;
      if (num & RETURNING_NOTECARD_DATA)
      {
         list note = llCSV2List(msg);
         volume = getVolume(note);
         wind = getInteger(note, "wind");
         systemAge = getFloat(note, "systemAge");
         particleAge = getFloat(note, "particleAge");
      }
      if ( num & FIRE_CMD ) //to allow for packing more data into num
      {
         if (llStringLength(msg) > 0)
         {
            //expected format is
            //UUID,color,color......
            //although more than the frst two colors may not be used
            debugSay(" listener got: "+ msg);
            params = llCSV2List(msg);
            integer len = llGetListLength(params);
            texture = llList2String(params,0);
            color1 = llList2String(params,1);
            lightColor = color1;
            colors = [color1];

            for (i=2; i<len; i++)
            {
                colors += llList2String(params,i);
            }
          }
          fire();
      }
   }
}

