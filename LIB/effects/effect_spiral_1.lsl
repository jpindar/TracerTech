/* basic spiral ball

ORIENTATION MATTERS
*/


makeParticles(integer link, string color1, string color2)
{
   beginAngle = 0;
   endAngle = 0.0314;

   
   #ifdef PARTCOUNT
   partCount = PARTCOUNT;
   #else
   partCount = 10;

   #endif
   //partCount = 9;
minPartSpeed = 3.6;
maxPartSpeed = 3.6;
//partAge = 1.9;
//followVelocity = TRUE;
partOmega = <0.000000,12.00000,0.000000>;    //vary this
burstRate = 0.01; //vary this a little
  burstRadius = 0;   
startScale = <0.400000,0.400000,0.000000>;
endScale =   <2.000000,2.000000,0.000000>;
   systemSafeSet = systemAge;

   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK;
   if (followVelocity)
      flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
      
   list particles = [
   PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE,
   PSYS_SRC_BURST_RADIUS,     burstRadius,
   PSYS_SRC_ANGLE_BEGIN,      beginAngle,
   PSYS_SRC_ANGLE_END,        endAngle,
   //PSYS_SRC_TARGET_KEY,     llGetKey(),
   PSYS_PART_START_COLOR,     (vector)color1,
   PSYS_PART_END_COLOR,       (vector)color2,
   PSYS_PART_START_ALPHA,     startAlpha,
   PSYS_PART_END_ALPHA,       endAlpha,
   PSYS_PART_START_GLOW,      startGlow,
   PSYS_PART_END_GLOW,        endGlow,
   PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
   PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
   PSYS_PART_START_SCALE,     startScale,
   PSYS_PART_END_SCALE,       endScale,
   PSYS_SRC_TEXTURE,          texture,
   PSYS_SRC_MAX_AGE,          systemSafeSet,
   PSYS_PART_MAX_AGE,         partAge,
   PSYS_SRC_BURST_RATE,       burstRate,
   PSYS_SRC_BURST_PART_COUNT, partCount,
   PSYS_SRC_ACCEL,<0.0,0.0,0.0>,
   PSYS_SRC_OMEGA,             partOmega,
   PSYS_SRC_BURST_SPEED_MIN,   minPartSpeed,
   PSYS_SRC_BURST_SPEED_MAX,   maxPartSpeed,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

