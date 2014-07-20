
makeParticles(list newList, float time)
{

    float systemSafeSet = time;
    list params = [PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_RADIUS,0,
        PSYS_SRC_ANGLE_BEGIN,0,
        PSYS_SRC_ANGLE_END,0,
        PSYS_SRC_TARGET_KEY,llGetKey(),
        PSYS_PART_START_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_END_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_START_ALPHA,1,
        PSYS_PART_END_ALPHA,0.5,
        PSYS_PART_START_SCALE,<0.500000,0.500000,0.000000>,
        PSYS_PART_END_SCALE,<0.500000,0.600000,0.000000>,
        PSYS_SRC_TEXTURE,"",
        PSYS_SRC_MAX_AGE, systemSafeSet,
        PSYS_PART_MAX_AGE,5,
        PSYS_SRC_BURST_RATE,0.3,
        PSYS_SRC_BURST_PART_COUNT,20,
        PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
        PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
        PSYS_SRC_BURST_SPEED_MIN,0.5,
        PSYS_SRC_BURST_SPEED_MAX,1.3,
        PSYS_PART_FLAGS, 0 | 
                PSYS_PART_EMISSIVE_MASK |
                PSYS_PART_FOLLOW_VELOCITY_MASK |
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK
        ];

    params = mergeLists(newList, params);
    llParticleSystem(params);    
    systemSafeSet = 0;

}




