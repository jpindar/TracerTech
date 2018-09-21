
//fountain effect
makeParticles(integer link, string color1, string color2)
{
   systemSafeSet = systemAge;
   vector particleOmega;
   integer flags = PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK |
   PSYS_PART_FOLLOW_SRC_MASK |
   PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;
   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,      0.0,
   PSYS_SRC_ANGLE_BEGIN,       PI_BY_TWO /8,
   PSYS_SRC_ANGLE_END,         0,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,      1,
   PSYS_PART_END_ALPHA,        0.2,
   PSYS_PART_START_SCALE,      <0.25,0.25,0.0>,
   PSYS_PART_END_SCALE,        <1.0,1.0,0.0>,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,           systemSafeSet,
   PSYS_PART_MAX_AGE,          4.0,
   PSYS_SRC_BURST_RATE,        0.0,
   PSYS_SRC_BURST_PART_COUNT,  20,
   PSYS_SRC_ACCEL,             <1.0,0.0,-2.0>,
   PSYS_SRC_OMEGA,             <0.0,0.0,0.0>,
   PSYS_SRC_BURST_SPEED_MIN,   5.0,
   PSYS_SRC_BURST_SPEED_MAX,   8.0,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

