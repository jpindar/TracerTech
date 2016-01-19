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
list emitterNames = ["e1"];
float intensity = 1.0;
float radius = 20;
float falloff = 0.02;
float speed = 1;
float systemAge = 1.75; //1.75 for normal, 1.0 or even 0.5 for multiple bursts
float oldAlpha;
list emitters;

#include "effects\effect_standard_burst.lsl"

default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
       //llPreloadSound(sound);
      emitters = getLinknumbers(emitterNames);
      oldAlpha = llGetAlpha(ALL_SIDES);
      allOff();
   }

   //link messages come from the controller
   link_message( integer sender, integer num, string msg, key id )
   {
      if (num & RETURNING_NOTECARD_DATA)
      {
          list note = llCSV2List(msg);
          volume =getVolume(note);
      }
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
   integer e;
   oldAlpha = llGetAlpha(ALL_SIDES);
   llSetLinkPrimitiveParamsFast(emitter,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   llSetLinkPrimitiveParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)color1,1.0]);
   glow(emitter,glowAmount);
   integer numOfEmitters = 1;
   // llPlaySound(sound, volume/numOfEmitters);
   llTriggerSound(sound, volume/numOfEmitters);
   repeatSound(sound,volume/numOfEmitters);
   e = llList2Integer(emitters,0);
   makeParticles(e,color1,color2);
   llSleep(0.5);
   setGlow(LINK_SET,0.0);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   setParamsFast(emitter,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,oldAlpha]);
   llSleep(systemAge);
   allOff();
}

allOff()
{

   systemSafeSet = 0.0;
   llLinkParticleSystem(emitter,[]);
}


