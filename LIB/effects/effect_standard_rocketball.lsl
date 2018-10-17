/*
 standard burst
 The ANGLE_CONE pattern can be used to imitate the EXPLODE pattern
 by explicitly setting PSYS_SRC_ANGLE_BEGIN to 0 and PSYS_SRC_ANGLE_END to PI or vice versa
*/


makeParticles(integer link, string color1, string color2)
{
   beginAngle = 0;
   endAngle = PI;

   #if defined STARTALPHA
   startAlpha = STARTALPHA;
   #else
   startAlpha = 1.0;
   #endif
   #if defined ENDALPHA
   endAlpha = ENDALPHA;
   #else
   endAlpha = 1.0;  // was 0.1
   #endif

   startSize = <0.5,0.5,0.0>;
   endSize = <0.5,0.5,0.0>;
   //startSize = <1.5,1.5,0.0>;
   //endSize = <0.5,0.5,0.0>;
   #ifdef PARTICLE_COUNT
   partCount = PARTICLE_COUNT;
   #else
   partCount = 200;
   #endif

   #if defined PARTICLE_SCALE
   partSizeScale = PARTICLE_SCALE;
   #else
   partSizeScale = 1.0;
   #endif

   #ifdef BURST_RADIUS
   burstRadius = BURST_RADIUS;
   #else
   burstRadius = 0.0;
   #endif

   burstRate = 0.1;
   partOmega = <0.0,0.0,0.0>;

   #ifdef DEBUG
   llOwnerSay("radius "+(string)burstRadius);
   llOwnerSay("systemAge "+(string)systemAge);
   llOwnerSay("partAge "+(string)partAge);
   llOwnerSay("startAlpha "+(string)startAlpha);
   llOwnerSay("endAlpha "+(string)endAlpha);
   llOwnerSay("startSize "+(string)(partSizeScale*startSize));
   llOwnerSay("endSize "+(string)(partSizeScale*endSize));
   llOwnerSay("maxPartSpeed "+(string)maxPartSpeed);
   llOwnerSay("minPartSpeed "+(string)minPartSpeed);
   llOwnerSay(" partCount "+(string) partCount);
   llOwnerSay("burstRat "+(string)burstRate);
   #endif

   systemSafeSet = systemAge;

   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK ;

   if (followVelocity)
      flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;

   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;

   list particles = [
   PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,     burstRadius,
   PSYS_SRC_ANGLE_BEGIN,      beginAngle,
   PSYS_SRC_ANGLE_END,        endAngle,
   PSYS_PART_START_COLOR,     (vector)color1,
   PSYS_PART_END_COLOR,       (vector)color2,
   PSYS_PART_START_ALPHA,     startAlpha,
   PSYS_PART_END_ALPHA,       endAlpha,
   PSYS_PART_START_SCALE,     partSizeScale*startSize,
   PSYS_PART_END_SCALE,       partSizeScale*endSize,
   PSYS_PART_START_GLOW,      startGlow,
   PSYS_PART_END_GLOW,        endGlow,
   PSYS_SRC_TEXTURE,          texture,
   PSYS_SRC_MAX_AGE,          systemSafeSet,
   PSYS_PART_MAX_AGE,         partAge,
   PSYS_SRC_BURST_RATE,       burstRate,
   PSYS_SRC_BURST_PART_COUNT,   partCount,
   PSYS_SRC_ACCEL,             <0.0,0.0,-0.3>,
   PSYS_SRC_OMEGA,             partOmega,
   PSYS_SRC_BURST_SPEED_MIN,   minPartSpeed,
   PSYS_SRC_BURST_SPEED_MAX,   maxPartSpeed,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

