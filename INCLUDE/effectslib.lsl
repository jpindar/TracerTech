


makeParticles1(vector color1, vector color2, string texture)
{
        llParticleSystem(
        [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
            PSYS_SRC_BURST_RADIUS,0,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,0,
			
            PSYS_SRC_TARGET_KEY,llGetKey(),
            PSYS_PART_START_COLOR,color1,
            PSYS_PART_END_COLOR,color2,
            PSYS_PART_START_ALPHA,1,
            PSYS_PART_END_ALPHA,0.5,
            PSYS_PART_START_SCALE,<0.500000,0.500000,0.000000>,
            PSYS_PART_END_SCALE,<0.500000,0.600000,0.000000>,
            PSYS_SRC_TEXTURE,texture,
            PSYS_SRC_MAX_AGE,0,
            PSYS_PART_MAX_AGE,5,
            PSYS_SRC_BURST_RATE,0.3,
            PSYS_SRC_BURST_PART_COUNT,20,
            PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,0.5,
            PSYS_SRC_BURST_SPEED_MAX,1.3,
            PSYS_PART_FLAGS,
                0 |
                PSYS_PART_EMISSIVE_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK
        ]);
}

makeParticles2(vector color1, vector color2, string texture)
{
        SystemAge =0.9;
        SystemSafeSet = SystemAge;
        llParticleSystem([
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, SystemAge,
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_SPEED_MIN, 2.0,
        PSYS_SRC_BURST_SPEED_MAX, 2.0,
        // PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
        PSYS_PART_FLAGS, ( 0
                     | PSYS_PART_INTERP_COLOR_MASK
                     | PSYS_PART_INTERP_SCALE_MASK
                     | PSYS_PART_EMISSIVE_MASK
                     | PSYS_PART_FOLLOW_VELOCITY_MASK)
        ]);
}	

makeParticles3(vector color1, vector color2, string texture)
    {
        SystemAge =0.871257;//life span of the particle system
        SystemSafeSet = SystemAge;
        llParticleSystem([
        0, 291, //PSYS_PART_FLAGS=256+32+2+1=PSYS_PART_EMISSIVE_MASK+PSYS_PART_FOLLOW_VELOCITY_MASK+PSYS_PART_INTERP_SCALE_MASK+PSYS_PART_INTERP_COLOR_MASK
        9, 2, // PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
        PSYS_SRC_ACCEL, <0, 0, 1>,
        //  8, <0, 0, -1.91>, // PSYS_SRC_ACCEL
        15, 76, // PSYS_SRC_BURST_PART_COUNT
        22, 0.01, // PSYS_SRC_ANGLE_BEGIN
        23, 0.174714, // PSYS_SRC_ANGLE_END
        2, 1, // PSYS_PART_START_ALPHA
        19, 0.871257, // PSYS_SRC_MAX_AGE
        7, 2.221704, // PSYS_PART_MAX_AGE
        13, 0.03, // PSYS_SRC_BURST_RATE
        17, 1.259999, // PSYS_SRC_BURST_SPEED_MIN
        18, 3.383097, // PSYS_SRC_BURST_SPEED_MAX
        PSYS_PART_START_COLOR,color1,
        PSYS_PART_START_SCALE,startSize,
        PSYS_PART_START_SCALE,endSize,
        PSYS_PART_END_COLOR,color2,
        PSYS_SRC_BURST_RADIUS,0.02,
        PSYS_PART_END_SCALE,<0.49, 0.49, 0.05>,
        4, 1E-06, //  PSYS_PART_END_ALPHA
        21,<0, 0, 0>, // PSYS_SRC_OMEGA
        12,"bda1445f-0e59-4328-901b-a6335932179b"
        ]);
    }
	
makeParticles4(vector color1, vector color2, string texture)
    { 
	float SystemAge = 1.75;
        SystemSafeSet = SystemAge;
        //texture = "6189b78f-c7e2-4508-9aa2-0881772c7e27";
        llParticleSystem([
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, SystemSafeSet,
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_SPEED_MIN, 1.5,// or 2
        PSYS_SRC_BURST_SPEED_MAX, 1.5,// or 2
        PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
        PSYS_PART_FLAGS, ( 0
                     | PSYS_PART_INTERP_COLOR_MASK
                     | PSYS_PART_INTERP_SCALE_MASK
                     | PSYS_PART_EMISSIVE_MASK
                     | PSYS_PART_FOLLOW_VELOCITY_MASK)
        ]);
    }

makeParticles5(vector color1, vector color2, string texture)
{
    float SystemAge = 1.75;
        SystemSafeSet = SystemAge;
        llParticleSystem([
           PSYS_PART_FLAGS,0
         | PSYS_PART_INTERP_COLOR_MASK
         | PSYS_PART_INTERP_SCALE_MASK
         | PSYS_PART_EMISSIVE_MASK
         | PSYS_PART_FOLLOW_VELOCITY_MASK,
         PSYS_SRC_PATTERN, 2,
         PSYS_SRC_TEXTURE, texture,
         PSYS_SRC_MAX_AGE, SystemSafeSet,
         PSYS_PART_MAX_AGE, 5.0,
         PSYS_PART_START_SCALE, <0.5, 0.5,0.0>,
         PSYS_PART_END_SCALE,   <0.5, 0.5,0.0>,
         PSYS_PART_START_COLOR, color1,
         PSYS_PART_END_COLOR, color2,
         PSYS_PART_START_ALPHA, 1.0,
         PSYS_PART_END_ALPHA, 0.1,
         PSYS_SRC_BURST_PART_COUNT, 500,
         PSYS_SRC_BURST_RATE, 0.2,
         PSYS_SRC_BURST_SPEED_MIN, 1.5,
         PSYS_SRC_BURST_SPEED_MAX, 1.5,
         // PSYS_SRC_BURST_RADIUS, 0.0,
         PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >
        ]);
}

makeParticles6(vector color1, vector color2, string texture)
{
        SystemSafeSet = SystemAge;
        llParticleSystem([
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, SystemAge,
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_SPEED_MIN, 2.0,
        PSYS_SRC_BURST_SPEED_MAX, 2.0,
        PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
        PSYS_PART_FLAGS, ( 0
                     | PSYS_PART_INTERP_COLOR_MASK
                     | PSYS_PART_INTERP_SCALE_MASK
                     | PSYS_PART_EMISSIVE_MASK
                     | PSYS_PART_FOLLOW_VELOCITY_MASK)
        ]);
}
	

makeParticles7(vector color1, vector color2, string texture)
{
    systemAge =0.9;//life span of the particle system
    systemSafeSet = systemAge;
    llParticleSystem([
        PSYS_SRC_PATTERN, 2,
        // PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_SRC_TEXTURE, texture,
        PSYS_SRC_BURST_PART_COUNT, 500,
        PSYS_SRC_BURST_RATE, 0.2,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, systemSafeSet,
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

makeParticles8(vector color1, vector color2, string texture)
{
    systemAge =0.9;//life span of the particle system
    systemSafeSet = systemAge;
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


makeParticles9(vector color1, vector color2, string texture)
{
    systemAge = 1.75;
    systemSafeSet = systemAge;
    llParticleSystem([
        PSYS_SRC_PATTERN, 2,
        PSYS_SRC_BURST_RADIUS, 0.0,
        PSYS_PART_START_COLOR, color1,
        PSYS_PART_END_COLOR, color2,
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.1,
        PSYS_PART_START_SCALE, <0.5, 0.5, FALSE>,
        PSYS_PART_END_SCALE,   <0.5, 0.5, FALSE>,
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_MAX_AGE, 5.0,
        PSYS_SRC_MAX_AGE, systemSafeSet,
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

makeParticles10(vector color1, vector color2, string texture)
{
        systemAge = 1.75;
        systemSafeSet = systemAge;
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
         PSYS_SRC_MAX_AGE, systemSafeSet,
         PSYS_PART_MAX_AGE, 5.0,
         PSYS_SRC_BURST_PART_COUNT, 500,
         PSYS_SRC_BURST_RATE, 0.2,
         PSYS_SRC_BURST_SPEED_MIN, 1.5,
         PSYS_SRC_BURST_SPEED_MAX, 1.5,
         PSYS_SRC_ACCEL, <0.0,0.0, -0.3 >,
         PSYS_PART_FLAGS,0
         | PSYS_PART_INTERP_COLOR_MASK
         | PSYS_PART_INTERP_SCALE_MASK
         | PSYS_PART_EMISSIVE_MASK
         | PSYS_PART_FOLLOW_VELOCITY_MASK
        ]);
}

