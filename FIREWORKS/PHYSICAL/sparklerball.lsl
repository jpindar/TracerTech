//sparkler
// by Tracer Ping July 2011

vector color1 = <1.0, 1.0, 1.0 >;
string texture = "6189b78f-c7e2-4508-9aa2-0881772c7e27";
float VOLUME = 1.0;     // 0.0 = silent to 1.0 = full volume
//string sound = "a2b1025e-1c8a-4dfb-8868-c14a8bed8116";



makeParticles (vector color)
{
//  llPlaySound (sound, VOLUME);

  llParticleSystem ([
         PSYS_SRC_TEXTURE, texture,
         PSYS_PART_START_SCALE, <0.50, 1.0, 0.5>,
         PSYS_PART_END_SCALE, <0.10, 0.10, 0.10>,
         PSYS_PART_START_COLOR, color,
         PSYS_PART_END_COLOR, color,
         PSYS_PART_START_ALPHA, 1.0,
         PSYS_PART_END_ALPHA, 1.0,

         PSYS_SRC_BURST_PART_COUNT, 30,
         PSYS_SRC_BURST_RATE, 0.05,
         PSYS_PART_MAX_AGE, 0.2,
        // PSYS_PART_MAX_AGE, 0.1,  //too slow
         PSYS_SRC_MAX_AGE, 0.0,

         PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
         PSYS_SRC_BURST_SPEED_MIN, 0.5,
         PSYS_SRC_BURST_SPEED_MAX, 2,
         PSYS_SRC_BURST_RADIUS, 0,

         PSYS_PART_FLAGS, (0
                       | PSYS_PART_INTERP_COLOR_MASK
                       | PSYS_PART_INTERP_SCALE_MASK
                       | PSYS_PART_FOLLOW_SRC_MASK
                       | PSYS_PART_FOLLOW_VELOCITY_MASK
                       //| PSYS_PART_TARGET_POS_MASK
                       | PSYS_PART_EMISSIVE_MASK
                       //| PSYS_PART_TARGET_LINEAR_MASK
                       //| PSYS_PART_BOUNCE_MASK
                       //| PSYS_PART_WIND_MASK
             )]);
}



default
{
  state_entry ()
  {
   // llPreloadSound (sound);
    //texture = llGetInventoryName(INVENTORY_TEXTURE,0);
    llSetTexture (texture, 2);
    makeParticles (color1);
  }
  
  on_rez(integer n){llResetScript();}
}



