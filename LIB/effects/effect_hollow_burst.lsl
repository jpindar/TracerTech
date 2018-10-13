/*
 hollow burst
 don't define burstRadius here, I think we may want to vary it


 The ANGLE_CONE pattern can be used to imitate the EXPLODE pattern by explicitly setting PSYS_SRC_ANGLE_BEGIN to 0.00000 and PSYS_SRC_ANGLE_END to 3.14159 (or PI) (or vice versa).
*/


makeParticles(integer link, string color1, string color2)
{

   #if defined STARTXSCALE
   vector startScale = <STARTXSCALE,STARTYSCALE,0>;
   #else
   vector startScale = <0.5,0.5,0.0>;
   #endif
   #if defined ENDXSCALE
   vector endScale = <ENDXSCALE,ENDYSCALE,0>;
   #else
   vector endScale = <0.5,0.5,0.0>;
   #endif

    #if defined STARTALPHA
    float startAlpha = STARTALPHA;
    #else
    float startAlpha = 1.0;
    #endif
    #if defined ENDALPHA
    endAlpha = ENDALPHA;
    #else
    float endAlpha = 0.2;
    #endif

   #ifdef ANGLE_END
      float angleEnd = ANGLE_END;
   #else
      float angleEnd = PI;
   #endif

   vector particleOmega = <0.0,0.0,0.0>;
   systemSafeSet = systemAge;
   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK ;

   #ifndef NOFOLLOWVELOCITY
   flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
   #endif

   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;

   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,      burstRadius,
   PSYS_SRC_ANGLE_BEGIN,       0.0,
   PSYS_SRC_ANGLE_END,         angleEnd,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,      startAlpha,
   PSYS_PART_END_ALPHA,        endAlpha,
   PSYS_PART_START_GLOW,       startGlow,
   PSYS_PART_END_GLOW,         endGlow,
   PSYS_PART_START_SCALE,      startScale,
   PSYS_PART_END_SCALE,        endScale,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,           systemSafeSet,
   PSYS_PART_MAX_AGE,          particleAge,
   PSYS_SRC_BURST_RATE,        0.1,
   PSYS_SRC_BURST_PART_COUNT,  140,
   PSYS_SRC_ACCEL,             <0.0,0.0,-0.3>,
   PSYS_SRC_OMEGA,             particleOmega,
   PSYS_SRC_BURST_SPEED_MIN,   (1.5*speed),
   PSYS_SRC_BURST_SPEED_MAX,   (1.5*speed),
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

