/*
 * derived from "Fire" by Jopsy Pendragon
 * but quite modified by now
 *
 */

string color1 = "<1,1,0>";
string color2 = "<.4,0,0>";
string texture = "";
float systemSafeSet = 0;
float systemAge = 0;

makeParticles(integer link, string color1, string color2)
{
   systemSafeSet = systemAge;
   integer flags = 0
      | PSYS_PART_INTERP_COLOR_MASK
      | PSYS_PART_INTERP_SCALE_MASK
      | PSYS_PART_EMISSIVE_MASK
      | PSYS_PART_FOLLOW_VELOCITY_MASK
      | PSYS_PART_WIND_MASK
      | PSYS_PART_BOUNCE_MASK;

   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_EXPLODE,
   PSYS_SRC_TEXTURE,             texture,
   PSYS_PART_START_ALPHA,      0.8,
   PSYS_PART_END_ALPHA,        0.0,
   PSYS_PART_START_SCALE,      <0.25,0.25,FALSE>,
   PSYS_PART_END_SCALE,        <0.5,0.5, FALSE>,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,

   PSYS_SRC_BURST_PART_COUNT,  4,
   PSYS_SRC_BURST_RATE,        0.05,
   PSYS_PART_MAX_AGE,          0.75,
   PSYS_SRC_MAX_AGE,           0.0,
   PSYS_SRC_BURST_SPEED_MIN,   0.1,
   PSYS_SRC_BURST_SPEED_MAX,   0.3,
   PSYS_SRC_ANGLE_BEGIN,       0.03*PI,
   PSYS_SRC_ANGLE_END,         0.00*PI,
   PSYS_SRC_ACCEL,             <0.0,0.0,1.5>,
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

default
{
    state_entry()
    {
       makeParticles(LINK_THIS, color1, color2);
    }
}
