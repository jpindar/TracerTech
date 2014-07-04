/////////////////////////
// rocketball
// this goes in the projectile, which in turn
// goes in the launcher
////////////////////////
#include "lib.lsl"

integer effectsType = 4; 
string texture = TEXTURE_CLASSIC;

integer rezParam;

vector particleColor = (vector)COLOR_GOLD;
vector color1 = (vector)COLOR_GOLD;
vector color2 = (vector)COLOR_GOLD;
vector primColor = (vector)COLOR_GOLD;
vector lightColor = (vector)COLOR_GOLD;
float intensity = 1.0;
float radius = 20; //10 to 20
float falloff = 0.02; //0.02 to 0.75
float primGlow = 0.4;
float breakSpeed = 10;
float primSize = 0.3;
string sound1 = SOUND_PUREBOOM;

//string notecardName = "test";
integer index;
//key MyQuery1;
//key MyQuery2;
//string myData="<1.0,0.0,0.0>";
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
float endAlpha = 0;
vector startSize = <1.9,1.9,1.9>;
vector endSize = <1.9,1.9,1.9>;
float life = 1;
float SystemSafeSet = 0.00;
float SystemAge = 1.0;

#include "effectslib.lsl"

boom()
{
//     llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
    debugSay("boom");
    SystemSafeSet = SystemAge;
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, 0.0]);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,primColor,0.0]);
    //llSetAlpha(0.0,ALL_SIDES);
    makeParticles1(color1,color2,texture);
    llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,radius,falloff]);
    llPlaySound(sound1,1);
    //llSetStatus(STATUS_PHYSICS, FALSE);
    //llSetStatus(STATUS_PHANTOM, TRUE);
    llSleep(SystemAge);
    SystemSafeSet = 0.0;
    llParticleSystem([]);
    llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES, 0.0]);
    llSleep(life);
    llSetTimerEvent(0);
    if (rezParam !=0)
    {
        llDie();
    }
    llSleep(5); //dunno why this is needed - but without it, no boom
}

default
{
    on_rez(integer p)
    {
        rezParam = p;
        integer t = p & 0xFF;
        float bouy = (p & 0xFF00) / 16; 
        llSetBuoyancy(bouy/100);
        //llCollisionSound("", 1.0);  //  Disable collision sounds
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        llSetLinkPrimitiveParamsFast(0,[PRIM_TEMP_ON_REZ,TRUE]);
        //fullbright?
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,primGlow]);
        llSetLinkPrimitiveParamsFast(0,[PRIM_COLOR,ALL_SIDES,primColor,1.0]);
        llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,lightColor,intensity,radius,falloff]);
        llSetLinkPrimitiveParamsFast(0,[PRIM_SIZE, <primSize,primSize,primSize>]);
        integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
        float gravity = 0.8;
        float restitution = 0.3;
        float friction = 0.9;
        float density = 500;
        llSetPhysicsMaterial(mask,gravity,restitution,friction,density);
        if (t<1)  //because 0 means no timer effect
            t = 1;
        llSetTimerEvent(t);
    }

    state_entry()
    {
       llParticleSystem([]);
    }


    touch_start(integer total_number)
    {
        //launch((integer)llGetObjectDesc());
        //boom();
    }

    collision_start(integer n)
    {
        integer f = 0;
        key id;
        vector spd;

        debugSay(llGetScriptName() + ": collision ");
        debugSay( "me @ " +(string)llVecMag(spd = llGetVel())+"m/s");
        for (f=0; f<n; f++)
        {
            debugSay(llDetectedName(f) + " @ " + (string)llRound(llVecMag(llDetectedVel(f))) + "m/s");
        }
        f = 0;

        do
        {
           // if (llVecMag(llDetectedVel(f)) >= breakSpeed)
            {
                boom();
            }
        } while (++f < n);
    }

    land_collision_start(vector pos)
    {
       debugSay("collision with land");
       boom();
    }

    timer()
    {
        debugSay("timed out");
        llSetTimerEvent(0);
        boom();
    }

}

/*
makeParticles(vector color, integer effectsType)
{
   llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
}
*/
