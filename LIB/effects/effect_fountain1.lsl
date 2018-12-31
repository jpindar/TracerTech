
//standard fountain effect
makeParticles(integer link, string color1, string color2)
{
   systemSafeSet = systemAge;
   #if defined GRAVITY
      vector acc = <0.0,0.0,GRAVITY>;
    #else
      vector acc = <0.0,0.0,0.0>;
    #endif

    float angle = PI/14;
    #if defined ANGLEBEGIN
        angle = ANGLEBEGIN;
    #endif

    float partMaxAge = 4.0;
    #if defined PARTAGE
        partMaxAge = PARTAGE;
    #endif



    //llOwnerSay((string)angle);
   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK;
   if (followVelocity)
      flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;

   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,      0.35,
   PSYS_SRC_ANGLE_BEGIN,       angle,
   PSYS_SRC_ANGLE_END,         0,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,      1.0,
   PSYS_PART_END_ALPHA,        0.3,
   PSYS_PART_START_GLOW,       startGlow,
   PSYS_PART_END_GLOW,         endGlow,
   PSYS_PART_START_SCALE,      startScale,
   PSYS_PART_END_SCALE,        endScale,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,           systemSafeSet,
   PSYS_PART_MAX_AGE,          partMaxAge,
   PSYS_SRC_BURST_RATE,        0.02,
   PSYS_SRC_BURST_PART_COUNT,  10,
   PSYS_SRC_ACCEL,             acc,
   PSYS_SRC_OMEGA,             partOmega,
   PSYS_SRC_BURST_SPEED_MIN,   (1.2*speed),
   PSYS_SRC_BURST_SPEED_MAX,   (1.4*speed),
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   if (systemAge !=0)  systemSafeSet = 0.0;
}

