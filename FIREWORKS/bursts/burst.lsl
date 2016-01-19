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
float falloff = 0.1;
float speed = 1;
float systemAge = 1.75; //1.75 for normal, 1.0 or even 0.5 for multiple bursts
integer numOfEmitters = 1;
float oldAlpha;
list emitters;

#include "effects\effect_standard_burst.lsl"

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
      if (num & RETURNING_NOTECARD_DATA)
      {
          list note = llCSV2List(msg);
          volume = getVolume(note);
          wind = getInteger(note, "wind");
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
   integer i; 
   integer e;
   string color;

   oldAlpha = llGetAlpha(ALL_SIDES);
   //llPlaySound(sound, volume/numOfEmitters);
   //repeatSound(sound,volume/numOfEmitters);
   llPlaySound(sound, volume);
   repeatSound(sound,volume);
   for(i=0;i<numOfEmitters;i++)
   {
      e = llList2Integer(emitters,i);
      setGlow(e,glowAmount);
      makeParticles(e,color1,color2);
      llSleep(0.5);
      setGlow(LINK_SET,0.0);
      setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   }
   llSleep(systemAge);
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
   setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,oldAlpha]);
   //setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   //llLinkParticleSystem(LINK_THIS,[]);
   //glow(LINK_THIS,0.0);
   //setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_WHITE,oldAlpha]);
}


