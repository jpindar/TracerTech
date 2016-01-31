/*
* rocketball 2.4
* this goes in the projectile, which in turn
* goes in the launcher
*/
#define EXPLODE_ON_COLLISION
#include "lib.lsl"

string texture;
integer rezParam;
string color1;
string color2;
string primColor = COLOR_GOLD;
string lightColor = COLOR_GOLD;
string sound1 = SOUND_PUREBOOM;
float intensity = 1.0;
float radius = 5;
float falloff = 0.1; //0.02 to 0.75
float primGlow = 0.4;
float breakSpeed = 10;
float primSize1 = 0.3;
integer index;
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
float endAlpha = 0;
vector startSize = <1.9,1.9,1.9>;
vector endSize = <1.9,1.9,1.9>;
vector omega = <0.0,0.0,0.0>;

float systemAge = 1.0;
integer explodeOnCollision = 0;
integer handle;
integer chan = 555;
list params;

#include "effects\effect_standard_rocketball.lsl"

default
{
    state_entry()
    {
       llLinkParticleSystem(LINK_THIS,[]);
    }
    
   on_rez(integer p)
   {
      llResetTime();
      setColor(LINK_SET,<0.0,0.0,0.0>,1.0);
      setParamsFast(LINK_THIS,[PRIM_SIZE, <primSize1,primSize1,primSize1>]);
      llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
      setParamsFast(LINK_SET,[PRIM_TEMP_ON_REZ,TRUE]);
      rezParam = p; //save this
      integer p1 = p & 0x7F;
      integer p2 = (p & 0x3F80) >> 7;
      integer p3 = (p & 0x3FC000) >>14;
      float t = (float)p1/10.0;
      float bouy = (float)p2/100.0;
      llSetBuoyancy(bouy);
      integer chan = (-42000) -p3;
      debugSay("p2 ="+ (string)p2);
      debugSay("chan = "+(string)chan);
      debugSay("t ="+ (string)t);
      handle=llListen(chan,"","","");
      if (p & DEBUG_MASK)
         debug = TRUE;
      else
         debug = FALSE;
      if (p & COLLISION_MASK)
         explodeOnCollision = 1; 
      if (p & FREEZE_MASK)
         freezeOnBoom = TRUE;
      //llCollisionSound("", 1.0);  //  Disable collision sounds
      // we don't know the color yet
      setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);
      //TODO can we make t a float?
      if (t<0.1)  //because 0 means no timer effect
         t = 1;
      if (rezParam>0)
      {   //use timer instead of sleeping to allow other events
          llSetTimerEvent(t);
          //debugSay("time is " + (string)t + " param2 is " + (string) bouy);
      }
   }

    listen( integer chan, string name, key id, string msg )
    {
      //debugSay(" listener got: "+ msg);
        params = llCSV2List(msg); 
        texture = llList2String(params,0);
        color1 = llList2String(params,1);
        color2 = llList2String(params,2);
        primColor = color1;
        lightColor = color1;
        //e = llList2Integer(emitters,i);
       setParamsFast(LINK_THIS,[PRIM_COLOR,ALL_SIDES,(vector)primColor,1.0]);
       llOwnerSay((string)llGetTime());
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
       if (explodeOnCollision==0)
         return;
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
            if (rezParam!=0)
            {
                  boom();
           }
         }
       } while (++f < n);
   }

   land_collision_start(vector pos)
   {
      if (explodeOnCollision==0)
         return;
      debugSay("collision with land");
      if (rezParam !=0)
      {
         boom();
      }
   }
   #endif


}

boom()
{
   //llMessageLinked(LINK_SET,(integer)42,"boom",(string)color)
   debugSay("boom");
   setColor(LINK_THIS,(vector)primColor,0.0);
   setParamsFast(LINK_THIS,[PRIM_GLOW, ALL_SIDES,1.0]);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,(vector)lightColor,intensity,radius,falloff]);

   makeParticles(effectsType,(vector)color1,(vector)color2,texture);
   //llMessageLinked(LINK_SET,(integer) debug,(string)color,"");
   llPlaySound(sound1,volume);
   setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   llSleep(systemAge);
   AllOff();
   llSetTimerEvent(0);
   if (rezParam !=0)
   {
       llSetStatus(STATUS_PHYSICS, FALSE);
       llDie();
   }
   llSleep(5); //dunno why this is needed - but without it, no boom
}

AllOff()
{
   setGlow(LINK_THIS,0.0);
   setParamsFast(LINK_SET,[PRIM_POINT_LIGHT,FALSE,(vector)lightColor,intensity,radius,falloff]);
   llLinkParticleSystem(LINK_THIS,[]);
}
