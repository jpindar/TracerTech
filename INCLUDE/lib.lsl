

#define MY_DEBUG_CHAN 557
#define SOUND_REPEAT_CHAN 556

#define PUBLIC 0
#define GROUP 1
#define OWNER 2

#define TEXTURE_CLASSIC "6189b78f-c7e2-4508-9aa2-0881772c7e27" //"classic", also standard fountain texture

//these colors must be strings in thi exact format 
//because I don't want to bother writing a message parser
#define COLOR_WHITE "<1.00,1.00,1.00>"
#define COLOR_BLACK "<0.00,0.00,0.00>"
#define COLOR_RED "<1.00,0.00,0.00>"
#define COLOR_GREEN "<0.00,1.00,0.00>"
#define COLOR_BLUE "<0.00,0.00,1.00>"
#define COLOR_GOLD "<1.00,0.80,0.20>"
#define COLOR_3 "<0.00,0.80,0.20>"

#define SOUND_ROCKETLAUNCH1 "0718a9e6-4632-48f2-af66-664196d7597d"
#define SOUND_FOUNTAIN1 "1339a082-66bb-4d4b-965a-c3f13da18492"
#define SOUND_CLICK1 "0f76aca8-101c-48db-998c-6018faf14b62"
#define SOUND_BURST1 "a2b1025e-1c8a-4dfb-8868-c14a8bed8116"

float VOLUME = 1.0;  // 0.0 = silent to 1.0 = full volume
integer FIRE_CMD = 1;


#define GLOW_ON llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,1.0])
#define GLOW_OFF llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,0.0])

integer randomChan()
{
   return (integer)(llFrand(-1000000000.0) - 1000000000.0);
}

repeatSound(key soundKey)
{
    llRegionSay(SOUND_REPEAT_CHAN, soundKey);
}

debugSay(string msg)
{
//if (debug)
//   llOwnerSay(msg);
   llSay(MY_DEBUG_CHAN,msg);
}

integer objectDescToInt()
{
   return (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC ]), 0);
}  

setObjectDesc(string s)
{ //there is a good reason not to use llSetLinkPrimitiveParamsFast here
    llSetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC,s]);
}
	
playInventorySound()
{
   llPlaySound(llGetInventoryName(INVENTORY_SOUND,0),1);
}

string getInventoryTexture()
{
    return llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,0));
}

void effect1()
{
    SystemAge =0.9;//life span of the particle system
    SystemSafeSet = SystemAge;
    llParticleSystem([
        PSYS_SRC_PATTERN, 2,
        // PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_SRC_TEXTURE, texture1,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, SystemAge,
        PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
        PSYS_SRC_BURST_SPEED_MIN, 2.0,
        PSYS_SRC_BURST_SPEED_MAX, 2.0,
        PSYS_PART_FLAGS, ( 0
                     | PSYS_PART_INTERP_COLOR_MASK
                     | PSYS_PART_INTERP_SCALE_MASK
                     | PSYS_PART_EMISSIVE_MASK
                     | PSYS_PART_FOLLOW_VELOCITY_MASK)
    ]);
}


void effect2()
{
    SystemAge =0.9;//life span of the particle system
    SystemSafeSet = SystemAge;
    llParticleSystem([
        9, 2, // PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
        21,<0, 0, 0>, // PSYS_SRC_OMEGA
        0, 291, //PSYS_PART_FLAGS=256+32+2+1=PSYS_PART_EMISSIVE_MASK+PSYS_PART_FOLLOW_VELOCITY_MASK+PSYS_PART_INTERP_SCALE_MASK+PSYS_PART_INTERP_COLOR_MASK
        PSYS_SRC_ACCEL, <0, 0, 1>,
        //  8, <0, 0, -1.91>, // PSYS_SRC_ACCEL
        15, 76, // PSYS_SRC_BURST_PART_COUNT
        22, 0.01, // PSYS_SRC_ANGLE_BEGIN
        23, 0.17, // PSYS_SRC_ANGLE_END
        2, 1, // PSYS_PART_START_ALPHA
        19, 0.87, // PSYS_SRC_MAX_AGE
        7, 2.22, // PSYS_PART_MAX_AGE
        13, 0.03, // PSYS_SRC_BURST_RATE
        17, 1.26, // PSYS_SRC_BURST_SPEED_MIN
        18, 3.38, // PSYS_SRC_BURST_SPEED_MAX
        PSYS_PART_START_COLOR,color1,
        PSYS_PART_END_COLOR,color2,
        PSYS_PART_START_SCALE,startSize,
        PSYS_PART_START_SCALE,endSize,
        PSYS_SRC_BURST_RADIUS,0.02,
        PSYS_PART_END_SCALE,<0.49, 0.49, 0.05>,
        4, 1E-06, //  PSYS_PART_END_ALPHA
        12,"bda1445f-0e59-4328-901b-a6335932179b"
    ]);

}


 void effect3()
{
    float SystemAge = 1.75;
    SystemSafeSet = SystemAge;
    llParticleSystem([
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_PART_START_COLOR, color,
        PSYS_PART_END_COLOR, color,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_SRC_TEXTURE, texture1,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, SystemSafeSet,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
        PSYS_SRC_BURST_SPEED_MIN, 1.5,// or 2
        PSYS_SRC_BURST_SPEED_MAX, 1.5,// or 2
        PSYS_PART_FLAGS, ( 0
           | PSYS_PART_INTERP_COLOR_MASK
           | PSYS_PART_INTERP_SCALE_MASK
           | PSYS_PART_EMISSIVE_MASK
           | PSYS_PART_FOLLOW_VELOCITY_MASK)
        ]);
}

void effect4()
{
    {   SystemAge = 1.75;
        SystemSafeSet = SystemAge;
        llParticleSystem([
         PSYS_SRC_PATTERN, 2,
         // PSYS_SRC_BURST_RADIUS, 0.0,
         PSYS_PART_START_SCALE, <0.5, 0.5,0.0>,
         PSYS_PART_END_SCALE,   <0.5, 0.5,0.0>,
         PSYS_PART_START_COLOR, color1,
         PSYS_PART_END_COLOR, color2,
         PSYS_PART_START_ALPHA, 1.0,
         PSYS_PART_END_ALPHA, 0.1,
         PSYS_SRC_TEXTURE, texture,
         PSYS_SRC_MAX_AGE, SystemSafeSet,
         PSYS_PART_MAX_AGE, 5.0,
         PSYS_SRC_BURST_PART_COUNT, 500,
         PSYS_SRC_BURST_RATE, 0.2,
         PSYS_SRC_BURST_SPEED_MIN, 1.5,
         PSYS_SRC_BURST_SPEED_MAX, 1.5,
         PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >
         PSYS_PART_FLAGS,0
         | PSYS_PART_INTERP_COLOR_MASK
         | PSYS_PART_INTERP_SCALE_MASK
         | PSYS_PART_EMISSIVE_MASK
         | PSYS_PART_FOLLOW_VELOCITY_MASK
        ]);
}		
		