/*
* glowzone
* copyright Tracer Prometheus 2018
*
* put in one prim of a three (or more) prim object
* touch on/off, when on each prim creates a particle system
* in a specified color
*
* Put the three prims in a big triangle surrounding an area such as a 
* dance floor, and you get the 'glowzone' effect.

*/

#define TRACERGRID

#include "LIB\lib.lsl"

//string texture = "";
//string texture = TEXTURE_BLANK;
//string texture = TEXTURE_SPIKESTAR;
string texture = TEXTURE_CLASSIC;

string color;
integer on = FALSE;

makeParticles(integer link, vector color)
{
   llLinkParticleSystem(link, [
   PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,0,
   PSYS_SRC_ANGLE_BEGIN,PI_BY_TWO,
   PSYS_SRC_ANGLE_END,0,
   PSYS_SRC_TARGET_KEY,llGetKey(),
   PSYS_PART_START_COLOR,color,
   PSYS_PART_END_COLOR,color,
   PSYS_PART_START_ALPHA,0.5,
   PSYS_PART_END_ALPHA,1,
   PSYS_PART_START_GLOW,0.2,
   PSYS_PART_END_GLOW,0.2,
   PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
   PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
   PSYS_PART_START_SCALE,<0.1,0.1,0.0>,
   PSYS_PART_END_SCALE,<2.5,0.5,0.0>,
   PSYS_SRC_TEXTURE,texture,
   PSYS_SRC_MAX_AGE,0,
   PSYS_PART_MAX_AGE,3,
   PSYS_SRC_BURST_RATE,0.02,
   PSYS_SRC_BURST_PART_COUNT,30,
   PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
   PSYS_SRC_OMEGA,<0.0,0.0,0.0>,
   PSYS_SRC_BURST_SPEED_MIN,3,
   PSYS_SRC_BURST_SPEED_MAX,3.9,
   PSYS_PART_FLAGS,
      PSYS_PART_EMISSIVE_MASK
      | PSYS_PART_FOLLOW_VELOCITY_MASK
      | PSYS_PART_INTERP_COLOR_MASK
      | PSYS_PART_INTERP_SCALE_MASK
      ]);
}

allOff()
{
   llParticleSystem([]);
   llLinkParticleSystem(LINK_SET,[]);
}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      #if !defined HOTLAUNCH
        allOff();
      #endif
   }

   touch_start(integer n)
   {
      on = !on;
      if (on)
      {
         makeParticles(1, COLOR_RED);
         makeParticles(2, COLOR_GREEN);
         makeParticles(3, COLOR_BRIGHT_BLUE);
      }
      else
      {
            allOff();
      }
   }
}