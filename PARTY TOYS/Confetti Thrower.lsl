integer m_perm  =   FALSE;
string texture;
string target = "";
default
{
   changed(integer change)
   {
       if(change &( CHANGED_INVENTORY|CHANGED_SCALE)) llResetScript();
    }

    attach(key id)
    {
        llResetScript();
    }
    
    on_rez(integer i)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);   
        texture = llGetInventoryName(INVENTORY_TEXTURE,0); 
        llSetTexture(texture, ALL_SIDES);
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llListen(1, "", llGetOwner(), "");
            m_perm = TRUE;
        }
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if(m_perm == TRUE)
        {
            if(llToLower(message) == "yay")
            {
                llStartAnimation("Confetti Thrower pose");
               // llPlaySound("Confetti Thrower sound",1.0);
                //PSYS_SRC_PATTERN_ANGLE_CONE
                llParticleSystem(
                [
               // PSYS_SRC_TARGET_KEY,target,
                    PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_SRC_BURST_RADIUS,1.1,
                    PSYS_SRC_ANGLE_BEGIN,0,
                    PSYS_SRC_ANGLE_END,0,
                    PSYS_SRC_TARGET_KEY,llGetKey(),
                    PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
                    PSYS_PART_START_ALPHA,1,
                    PSYS_PART_END_ALPHA,1,
                    PSYS_PART_START_GLOW,0,
                    PSYS_PART_END_GLOW,0,
                    PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
                    PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
                    PSYS_PART_START_SCALE,<0.200000,0.200000,0.000000>,
                    PSYS_PART_END_SCALE,<0.200000,0.200000,0.000000>,
                    PSYS_SRC_TEXTURE,texture,
                    PSYS_SRC_MAX_AGE,0,
                    PSYS_PART_MAX_AGE,5,
                    PSYS_SRC_BURST_RATE,0.1,
                    PSYS_SRC_BURST_PART_COUNT,51,
                    PSYS_SRC_ACCEL,<0.000000,0.000000,-0.600000>,
                    PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
                    PSYS_SRC_BURST_SPEED_MIN,1.2,
                    PSYS_SRC_BURST_SPEED_MAX,2,
                    PSYS_PART_FLAGS,
                        0 |
                        PSYS_PART_BOUNCE_MASK
                       // | PSYS_PART_TARGET_LINEAR_MASK

                ]);
                
                llSleep(4);
                
                llParticleSystem([]);
                llStopAnimation("Confetti Thrower pose");
            }
        }
    }
}