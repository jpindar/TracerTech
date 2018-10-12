/*
* starsphere  no config
* copyright Tracer Prometheus 2018

 The ANGLE_CONE pattern can be used to imitate the EXPLODE pattern
 by explicitly setting PSYS_SRC_ANGLE_BEGIN to 0.0
 and PSYS_SRC_ANGLE_END to PI (or vice versa).

*/

#define TRACERGRID
//#define RAINBOW
//#define REPEATER

#include "LIB\lib.lsl"

//string texture = "";
//string texture = TEXTURE_BLANK;
string texture = TEXTURE_SPIKESTAR;
//string texture = TEXTURE_CLASSIC;

float delay = 1;

string color = (string)COLOR_WHITE;
string color1 = (string)COLOR_WHITE;
string color2 = (string)COLOR_WHITE;

integer on = FALSE;
float startAlpha = 1;
float endAlpha = 0;

#if defined STARTGLOW
float startGlow = STARTGLOW;  //notecard will override these
#else
float startGlow;
#endif

#if defined STARTGLOW
float endGlow = ENDGLOW;
#else
float endGlow;
#endif

#ifdef TT_BURST_RADIUS
float burstRadius = TT_BURST_RADIUS;
#else
float burstRadius = 5;
#endif

vector startSize = <1.5,1.5,0.0>;//or1.9
vector endSize = <0.5,0.5,0.0>;  // 0.5 to 1.5

float particleAge = 1.0;

float systemAge = 0; // 0.2 to 0.3
float speed = 0.1;


#include "LIB\effects\effect_hollow_burst.lsl"

boom()
{
   makeParticles(LINK_THIS,color1,color2);
   llSleep(systemAge);
   //allOff();
}


allOff()
{
   llParticleSystem([]);
   llLinkParticleSystem(LINK_THIS,[]);
}

go(integer on)
{
   #if defined RAINBOW
   integer i;
   list params = llCSV2List("red,orange,yellow,green,blue,purple");
   //params = llCSV2List("<1,0,0,>,<1,1,0>,<0,1,0>,<0,0,1>,<0,1,1>,<1,1,1>");
   for (i=0; i<6; i++)
   {
      color1 = nameToColor( llList2String(params,i));
      //color1= llList2String(params,i);
      color2 = color1;
      boom();
   }
   #else
      boom();
   #endif

}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      #if !defined HOTLAUNCH
        allOff();
      #endif
   }

   touch_start(integer n)
   {
        on = !on;
        if (on)
        {
           llOwnerSay("on");
           llSleep(1);
           go(TRUE);
           #if defined REPEATER
             llSetTimerEvent(delay);
           #endif
        }
        else
        {
            llSetTimerEvent(0);
            llOwnerSay("off");
            allOff();
        }
   }

    timer()
    {
        go(TRUE);
    }
}

