/////////////////////////
// fireworks burst v1.14
//Tracer Ping  July 2014
///////////////////////////

#include "lib.lsl"

integer FIRE_CMD =1;
integer preloadFace = 2;
vector color = <0.0, 0.0, 1.0>;
string texture = "6189b78f-c7e2-4508-9aa2-0881772c7e27";
string sound ="a2b1025e-1c8a-4dfb-8868-c14a8bed8116";
float VOLUME = 1.0;
float SystemSafeSet = 0.00;
float SystemAge = 1.75;

makeParticles(vector color)
{
   llParticleSystem([
   PSYS_PART_FLAGS,(0
      | PSYS_PART_INTERP_COLOR_MASK
      | PSYS_PART_INTERP_SCALE_MASK
      | PSYS_PART_EMISSIVE_MASK
      | PSYS_PART_FOLLOW_VELOCITY_MASK),
    PSYS_SRC_PATTERN, 2,
    PSYS_SRC_TEXTURE, texture,
    PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
    PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
    PSYS_PART_START_COLOR, color,
    PSYS_PART_END_COLOR, color,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 500,
    PSYS_SRC_BURST_RATE, 0.2,
    PSYS_PART_MAX_AGE, 5,
    PSYS_SRC_MAX_AGE, SystemAge,
    PSYS_SRC_BURST_SPEED_MIN, 1.5,
    PSYS_SRC_BURST_SPEED_MAX, 1.5,
    // PSYS_SRC_BURST_RADIUS, 0.0,
    PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >
    ]);
}

fire()
{
   integer soundChan = 556;
   llRegionSay(soundChan, sound);
   llPlaySound(sound, VOLUME );
   repeatSound(sound);
   SystemSafeSet = SystemAge;
   makeParticles(color);
   llSleep(SystemAge+1);
   SystemSafeSet = 0.0;
   llParticleSystem([]);
}

default
{
    changed(integer change){if(change & CHANGED_INVENTORY) {llResetScript();}}

    state_entry()
    {
       llSetTexture(texture,preloadFace);
       llParticleSystem([]);
    }

    link_message( integer n, integer num, string msg, key texture_key )
    {
        if (num == FIRE_CMD)
        {
           fire();
        }
    }

}




