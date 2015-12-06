/////////////////////////
// rocketball
// this goes in the projectile, which in turn
// goes in the launcher
////////////////////////
#include "lib.lsl"
integer effectsType = 2;  //1to 4

string texture = TEXTURE_CLASSIC;
integer rezParam;
string particleColor = COLOR_GOLD;
string color1 = COLOR_GOLD;
string color2 = COLOR_GOLD;
string primColor = COLOR_GOLD;
string lightColor = COLOR_GOLD;
float intensity = 1.0;
float radius = 20; //10 to 20
float falloff = 0.02; //0.02 to 0.75
float primGlow = 0.4;
float breakSpeed = 10;
float primSize = 0.3;
string sound1 = SOUND_PUREBOOM;
integer index;
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
float endAlpha = 0;
vector startSize = <1.9,1.9,1.9>;
vector endSize = <1.9,1.9,1.9>;
float life = 1;
float SystemSafeSet = 0.00;
float systemAge = 1.0;

#include "effectslib.lsl"

default
{
   on_rez(integer p)
   {
       float bouy = 5;
       rezParam = p;
       integer t = p & 0xFF;
       integer p2 = (p & 0xFF00) / 256;
       integer p3 = (p & 0xFF0000);
       if (p & DEBUG_MASK)
         debug = TRUE;
       else
         debug = FALSE;;
       debugSay("rezParam = " +(string) p); 
       if (p2 > 0)
          bouy = p2;
       llSetBuoyancy(bouy/100);
       //llCollisionSound("", 1.0);  //  Disable collision sounds
       llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
       setParamsFast(0,[PRIM_TEMP_ON_REZ,TRUE]);
       setParamsFast(LINK_THIS,[PRIM_GLOW,ALL_SIDES,primGlow]);
       setParamsFast(0,[PRIM_COLOR,ALL_SIDES,(vector)primColor,1.0]);
       setParamsFast(0,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
       setParamsFast(0,[PRIM_SIZE, <primSize,primSize,primSize>]);
       integer mask = FRICTION & DENSITY & RESTITUTION & GRAVITY_MULTIPLIER;
       float gravity = 0.8;
       float restitution = 0.3;
       float friction = 0.9;
       float density = 500;
       llSetPhysicsMaterial(mask,gravity,restitution,friction,density);
       if (t<1)  //because 0 means no timer effect
           t = 1;
        if (rezParam>0)
          llSetTimerEvent(t);
   }

   timer()
   {
       debugSay("timed out");
       llSetTimerEvent(0);
       boom();
   }

   #ifdef EXPLODE_ON_COLLISION
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
              if (rezParam>0)
                  boom();
           }
       } while (++f < n);
   }

   land_collision_start(vector pos)
   {
      debugSay("collision with land");
      if (rezParam>0)
         boom();
   }
   #endif


}

boom()
{
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   debugSay("boom");
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES, 0.0]);
   llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)primColor,0.0]);

   makeParticles((vector)color1,(vector)color2,texture);

   llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
   llPlaySound(sound1,volume);
   llSleep(systemAge);

   llParticleSystem([]);
   llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0.0]);
   llSleep(life);
   llSetTimerEvent(0);
   if (rezParam !=0)
   {
       llSetStatus(STATUS_PHYSICS, FALSE);
       llDie();
   }
   llSleep(5); //dunno why this is needed - but without it, no boom
}

