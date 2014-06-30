//Fireworks Fountain v1.14
//Tracer Ping July 2014

vector color = <1.0,0.0,0.0>;
string textureKey = "6189b78f-c7e2-4508-9aa2-0881772c7e27";
float SystemAge = 4.0;//life span of the particle system
string sound = "1339a082-66bb-4d4b-965a-c3f13da18492";
float VOLUME = 1.0;  // 0.0 = silent to 1.0 = full volume
float SystemSafeSet = 0.00;//prevents erroneous particle emissions
integer preloadFace = 2;
integer FIRE_CMD = 1;

makeParticles(vector color)
{
    llParticleSystem([
    PSYS_PART_FLAGS , 0
    | PSYS_PART_INTERP_COLOR_MASK
    | PSYS_PART_INTERP_SCALE_MASK
 //   | PSYS_PART_FOLLOW_SRC_MASK
    | PSYS_PART_FOLLOW_VELOCITY_MASK
    | PSYS_PART_EMISSIVE_MASK,
    PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_SRC_TEXTURE,           textureKey,
    PSYS_SRC_MAX_AGE,           SystemSafeSet,
    PSYS_PART_MAX_AGE,          5.0,
    PSYS_SRC_BURST_RATE,        0.02,
    PSYS_SRC_BURST_PART_COUNT,  10.0,
    PSYS_SRC_BURST_RADIUS,     0.3,
    PSYS_SRC_BURST_SPEED_MIN,   12.0,
    PSYS_SRC_BURST_SPEED_MAX,   14.0,
    PSYS_SRC_ACCEL,             <0.5,0.0,-2.0>,
    PSYS_PART_START_COLOR,      color,
    PSYS_PART_END_COLOR,        color,
    PSYS_PART_START_ALPHA,      1.0,
    PSYS_PART_END_ALPHA,        0.3,
    PSYS_PART_START_SCALE,      <1.5,1.5,0.0>,
    PSYS_PART_END_SCALE,        <3.0,3.0,0.0>,
    PSYS_SRC_ANGLE_BEGIN,       PI_BY_TWO /7,
    PSYS_SRC_ANGLE_END,         0,
    PSYS_SRC_OMEGA,             <0.0,0.0,0.0>
    ]);
} 

fire()
{
    integer soundChan = 556;
    llRegionSay(soundChan, sound);
    llPlaySound(sound, VOLUME );
    llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,1.0,PRIM_FULLBRIGHT,ALL_SIDES,TRUE]); 
    SystemSafeSet = SystemAge;
    makeParticles(color);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llParticleSystem([]);
    llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0.0,PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
    }

default
{
    state_entry()
    {
        //textureKey = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
       llSetTexture(textureKey,preloadFace);
       llParticleSystem([]);
    }

    link_message( integer sender, integer num, string msg, key target )
    {
        if ( num == FIRE_CMD )
        {
            //color = (vector)msg;
            fire();
        }
    }


}



