// standard rocketball
makeParticles(integer link, string color1, string color2)
{
   vector particleOmega = <0.0,0.0,0.0>;
   float beginAngle = 0;
   float endAngle = 2* PI;
   float startAlpha = 1.0;
   float endAlpha = 0.1;
   vector startSize = <0.5,0.5,0.0>;
   vector endSize = <0.5,0.5,0.0>;
   float partAge = 5;
   float burstRate = 0.2;
   MaxPartSpeep = 2.0;
   MinPartSpeed2 = 2.0;
   systemSafeSet = systemAge;
   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK |
   PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   list particles = [
      PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE,
      PSYS_SRC_BURST_RADIUS,      burstRadius,
      PSYS_SRC_ANGLE_BEGIN,      beginAngle,
      PSYS_SRC_ANGLE_END,        endAngle,
      PSYS_PART_START_COLOR,     (vector)color1,
      PSYS_PART_END_COLOR,       (vector)color2,
      PSYS_PART_START_ALPHA,     startAlpha,
      PSYS_PART_END_ALPHA,       endAlpha,
      PSYS_PART_START_SCALE,     startSize,
      PSYS_PART_END_SCALE,       endSize,
      PSYS_PART_START_GLOW, startGlow,
      PSYS_PART_END_GLOW, endGlow,
      PSYS_SRC_TEXTURE,          texture,
      PSYS_SRC_MAX_AGE,          systemSafeSet,
      PSYS_PART_MAX_AGE,         partAge,
      PSYS_SRC_BURST_RATE,       burstRate,
      PSYS_SRC_BURST_PART_COUNT,  500,
      PSYS_SRC_ACCEL,             <0.0,0.0, -0.3 >,
      PSYS_SRC_OMEGA,             particleOmega,
      PSYS_SRC_BURST_SPEED_MIN,   MinPartSpeed,
      PSYS_SRC_BURST_SPEED_MAX,   MaxPartSpeed,
      PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

