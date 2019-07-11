/*
 * ringball  
   beginAngle and endAngle can be set
   either here or in rocketball.h
   to make partial rings
 
 defined in effect.h: 
 beginAngle & endAngle    set to 0 and PI
 startAlpha & endAlpha    STARTALPHA ENDALPHA
 startGlow & endGlow      STARTGLOW
 startScale & endScale    STARTSCALE
 partCount                PARTCOUNT
 burstRadius              BURSTRADIUS
 burstRate                BURSTRATE
 followVelocity           FOLLOWVELOCITY
 systemAge                SYSTEMAGE
 partAge                  PARTAGE
 minPartSpeed             MINPARTSPEED
 maxPartSpeed             MAXPARTSPEED
 partOmega                set to <0,0,0>
 burstCount
 partAccel 
 texture
*/


makeParticles(integer link, string color1, string color2)
{

   #ifdef DEBUG
   llOwnerSay("radius "+(string)burstRadius);        //defined in effect.h
   llOwnerSay("systemAge "+(string)systemAge);       //defined in effect.h
   llOwnerSay("partAge "+(string)partAge);           //defined in effect.h
   llOwnerSay("startAlpha "+(string)startAlpha);     //defined in effect.h
   llOwnerSay("endAlpha "+(string)endAlpha);         //defined in effect.h
   llOwnerSay("startSize "+(string)(startScale));    //defined in effect.h
   llOwnerSay("endSize "+(string)(endScale));        //defined in effect.h
   llOwnerSay("maxPartSpeed "+(string)maxPartSpeed); //defined in effect.h
   llOwnerSay("minPartSpeed "+(string)minPartSpeed); //defined in effect.h
   llOwnerSay("partCount "+(string) partCount);      //defined in effect.h
   llOwnerSay("burstRat "+(string)burstRate);        //defined in effect.h
   #endif

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
   PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE,
   PSYS_SRC_BURST_RADIUS,     burstRadius,
   PSYS_SRC_ANGLE_BEGIN,      beginAngle,
   PSYS_SRC_ANGLE_END,        endAngle,
   PSYS_SRC_TARGET_KEY,       llGetKey(),
   PSYS_PART_START_COLOR,     (vector)color1,
   PSYS_PART_END_COLOR,       (vector)color2,
   PSYS_PART_START_ALPHA,     startAlpha,
   PSYS_PART_END_ALPHA,       endAlpha,
   PSYS_PART_START_GLOW,      startGlow,
   PSYS_PART_END_GLOW,        endGlow,
   PSYS_PART_START_SCALE,     startScale,
   PSYS_PART_END_SCALE,       endScale,
   PSYS_SRC_TEXTURE,          texture,
   PSYS_SRC_MAX_AGE,          systemSafeSet,
   PSYS_PART_MAX_AGE,         partAge,
   PSYS_SRC_BURST_RATE,       burstRate,
   PSYS_SRC_BURST_PART_COUNT, partCount,
   PSYS_SRC_ACCEL,            partAccel,
   PSYS_SRC_OMEGA,            partOmega,
   PSYS_SRC_BURST_SPEED_MIN,  minPartSpeed,
   PSYS_SRC_BURST_SPEED_MAX,  maxPartSpeed,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

