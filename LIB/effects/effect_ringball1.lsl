//ringball
makeParticles(integer link, string color1, string color2)
{
   vector particleOmega = <0.0,0.0,0.0>;
   systemSafeSet = systemAge;
   float partSpeed1 = 1.0;
   float partSpeed2 = 1.0;
   //vector startSize = <1.5,1.5,0.0>;
   //vector endSize = <0.5,0.5,0.0>;
   //float systemAge = 3.0;
   //float burstRadius = 1.5;

   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK |
   PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   list particles = [
      PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE,
      PSYS_SRC_BURST_RADIUS,     burstRadius,
      PSYS_SRC_ANGLE_BEGIN,      beginAngle,
      PSYS_SRC_ANGLE_END,        endAngle,
      PSYS_SRC_TARGET_KEY,       llGetKey(),
      PSYS_PART_START_COLOR,     (vector)color1,
      PSYS_PART_END_COLOR,       (vector)color2,
      PSYS_PART_START_ALPHA,     startAlpha,
      PSYS_PART_END_ALPHA,       endAlpha,
      PSYS_PART_START_SCALE,     startSize,
      PSYS_PART_END_SCALE,       endSize,
      PSYS_PART_START_GLOW,      startGlow,
      PSYS_PART_END_GLOW,        endGlow,
      PSYS_SRC_TEXTURE,          texture,
      PSYS_SRC_MAX_AGE,          systemSafeSet,
      PSYS_PART_MAX_AGE,         partAge,
      PSYS_SRC_BURST_RATE,       rate,
      PSYS_SRC_BURST_PART_COUNT, 350,
      PSYS_SRC_ACCEL,            <0.0,0.0,0.0>,
      PSYS_SRC_OMEGA,             particleOmega,
      PSYS_SRC_BURST_SPEED_MIN,   partSpeed1,
      PSYS_SRC_BURST_SPEED_MAX,   partSpeed2,
      PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}
