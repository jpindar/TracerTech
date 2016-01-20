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
string sound = SOUND_SPARKLE1_5S;
list emitterNames = ["e1"];//["e1","e2","e3"];
float speed = 10; //5 to 10
float omega = 0;
float systemAge = 4.5; //4 to 4.5
integer numOfEmitters = 1;
float oldAlpha;
list emitters;
  #include "effects\effect_fountain1.lsl"

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
            //lightColor = color1;
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

   oldAlpha = llGetAlpha(ALL_SIDES);
   //llPlaySound(sound, volume/numOfEmitters);
   //repeatSound(sound,volume/numOfEmitters);
   llPlaySound(sound, volume);
   repeatSound(sound,volume);
   for(i=0;i<numOfEmitters;i++)
   {
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

