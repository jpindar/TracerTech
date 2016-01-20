/*
*Fireworks Fountain emitter v2.5.3
*Tracer Ping July 2014
*/
#include "lib.lsl"
//#define RAINFALL
//#define MINIFOUNTAIN

string color1;
string color2;
string color3;
string lightColor;
string texture;
string sound = SOUND_SPARKLE1_5S;
list emitterNames = ["e1"];//["e1","e2","e3"];
float oldAlpha;
list colors;
list emitters;
list params;
integer numOfEmitters = 1;
float glowAmount = 1.0;
float systemAge = 5;

#if defined RAINFALL
   float speed = 5;
   #include "effects\effect_fountain_rainfall1.lsl"
#elif defined MINIFOUNTAIN
   float speed = 10;
   float omega = 0;
   #include "effects\effect_mini_fountain1.lsl"
#else
   float speed = 10;
   float omega = 0;
   #include "effects\effect_fountain1.lsl"
#endif

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

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
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
            //llOwnerSay(" listener got: "+ msg);
            params = llCSV2List(msg); 
            texture = llList2String(params,0);
            color1 = llList2String(params,1);
            lightColor = color1;
            colors = [color1];
            colors += llList2String(params,2);
         }
         fire();
      }
   }
}

fire()
{
   integer i; 
   integer e;

   oldAlpha = llGetAlpha(ALL_SIDES);
   //llPlaySound(sound, volume/numOfEmitters);
   //repeatSound(sound,volume/numOfEmitters);
   llPlaySound(sound, volume);
   repeatSound(sound,volume);
   for(i=0;i<numOfEmitters;i++)
   {
       color1 = llList2String(colors,i*2);
       color2 = llList2String(colors,(i*2)+1);
       e = llList2Integer(emitters,i);
       setParamsFast(e,[PRIM_COLOR,ALL_SIDES,(vector)color1,1.0]);
       //setParamsFast(e,[PRIM_POINT_LIGHT,TRUE,(vector)color1,intensity,radius,falloff]);
       setGlow(e,1.0);
       makeParticles(e,color1,color2);
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
      //setParamsFast(e,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor, intensity,radius,falloff]);
      llLinkParticleSystem(e,[]);
      setGlow(e,0.0);
      setParamsFast(e,[PRIM_COLOR,ALL_SIDES,(vector)COLOR_BLACK,oldAlpha]);
   }
}

