//
//  Popgun Bullet

vector velocity;
integer shot = FALSE;
//integer fade = FALSE;
//float alpha = 1.0;
string soundName;

splat()
{
        //llPushObject(llDetectedKey(0), <9999999999,9999999999,99999999999>, <0,0,0>, FALSE);
        //llSetStatus(STATUS_PHANTOM, TRUE);
        //vector pos = llGetPos();
        //llMoveToTarget(pos, 0.3);  //  Move to where we hit smoothly
        //llSetColor(<0,0,1>, ALL_SIDES);
        //llTriggerSound(soundName, 1.0);
        //llMakeFountain(50, 0.3, 2.0, 4.0, 0.5*PI,
        //                FALSE, "drop", <0,0,0>, 0.0);
        //fade = TRUE;
        llSetTimerEvent(5);
        if (shot)
        {
            debug("bye!");
            //llSetStatus(STATUS_PHYSICS, FALSE);
            //llSetStatus(STATUS_PHANTOM, TRUE);
            llSetAlpha(0.0,ALL_SIDES);
            llDie();
        }
}

default
{
    state_entry()
    {
        //soundName=llGetInventoryName(INVENTORY_SOUND,0);
        //llSetDamage(100.0);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSetPrimitiveParams([PRIM_TEMP_ON_REZ,TRUE] );
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
    }

    on_rez(integer param)
    {
       // llOwnerSay("rezzing with param <" + (string)param + ">");
        float bouy = param;
        bouy = bouy /10;
        llOwnerSay("rezzing with param <" + (string)bouy + ">");
        llSetBuoyancy(bouy);  //  Make bullet float and not fall, try 0.5
        llCollisionSound("", 1.0);  //  Disable collision sounds
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        velocity = llGetVel();
        float vmag = llVecMag(velocity);
        if (vmag > 0.1)
           shot = TRUE;
        debug((string)vmag + "m/s");
        llSetTimerEvent(60);  //  Time until shot deletes itself
    }

    timer()
    {
        if (shot)
        {
            debug("bye!");
            llSetStatus(STATUS_PHYSICS, FALSE);
            llSetStatus(STATUS_PHANTOM, TRUE);
            llSetAlpha(0.0,ALL_SIDES);
            llDie();
        }
    }
}

    collision_start(integer total_number)
    {
       debug("collision");
       splat();
    }

    land_collision_start(vector pos)
    {
       debug("land_collision");
       splat();
    }
    
    
debug(string msg)
{
    llOwnerSay(msg);
}

