//sparkler
// by Tracer Ping July 2011
#define TRACERGRID
#include "lib.lsl"
vector color = COLOR_WHITE;
string texture = TEXTURE_CLASSIC;


makeParticles(vector color)
{
  llParticleSystem([
     PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
     PSYS_SRC_BURST_RADIUS, 0,
     PSYS_PART_START_COLOR,(vector)color,
     PSYS_PART_END_COLOR, (vector)color,
     PSYS_PART_START_ALPHA, 1.0,
     PSYS_PART_END_ALPHA, 1.0,
     PSYS_PART_START_SCALE, <0.5, 0.9, 0.0>,
     PSYS_PART_END_SCALE, <0.1, 0.1, 0.0>,
     PSYS_SRC_TEXTURE, texture,
     PSYS_SRC_MAX_AGE, 0.0,
     PSYS_PART_MAX_AGE, 0.2,
     PSYS_SRC_BURST_PART_COUNT,15,
     PSYS_SRC_BURST_RATE, 0.05,
     PSYS_SRC_BURST_SPEED_MIN, 1.0,
     PSYS_SRC_BURST_SPEED_MAX, 1.0,
     //PSYS_SRC_TARGET_KEY,(key)"",
     PSYS_PART_FLAGS,0
        | PSYS_PART_INTERP_COLOR_MASK
        | PSYS_PART_INTERP_SCALE_MASK
        | PSYS_PART_FOLLOW_SRC_MASK
        | PSYS_PART_FOLLOW_VELOCITY_MASK
        | PSYS_PART_EMISSIVE_MASK
        ]);
}


default
{
   on_rez(integer n){llResetScript();}

   state_entry ()
   {
      //texture = llGetInventoryName(INVENTORY_TEXTURE,0);
      //llSetTexture (texture, 2);
      setColor(LINK_THIS,color,1.0);
      setGlow(LINK_THIS,0.4);
      makeParticles (color);
   }
}

