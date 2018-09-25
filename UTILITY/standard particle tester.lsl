/*
* standard particle tester
* copyright Tracer Ping 2018
*/
#define TRACERGRID
//#define RAINBOW
#define REPEATER

#include "lib.lsl"
string texture = "";
//string texture = TEXTURE_BLANK;
//string texture = TEXTURE_SPIKESTAR;
//string texture = TEXTURE_CLASSIC;


string color = (string)COLOR_WHITE;
string color1 = (string)COLOR_ORANGE;
string color2 = (string)COLOR_ORANGE;

integer on = TRUE;

/*
string primColor;
string lightColor = COLOR_WHITE;
float primGlow2 = 0.0;
integer glow = TRUE;
integer bounce = FALSE;
float startAlpha = 1;
list params;

float endAlpha = 0;
float startGlow = 0;
float endGlow = 0;
vector startSize = <1.5,1.5,0.0>;//or1.9
vector endSize = <0.5,0.5,0.0>;  // 0.5 to 1.5
float rate = 2; //4.7
float partAge = 5; //or 1.5
float beginAngle = PI;
float endAngle = 0;

float partRadius = 1.5; //or 1
*/
float systemAge = 5.0;
float startGlow = 0;
float endGlow = 0;
float speed = 1.0;
//#include "effects\effect_ringball1.lsl"
//#include "effects\effect_fountain2.lsl"
//#include "effects\effect_mini_fountain1.lsl"
#include "effects\effect_jopsys_fire.lsl"

boom()
{
   makeParticles(LINK_THIS,color1,color2);
   llSleep(systemAge);
   if (systemAge > 0)
       AllOff();
}


AllOff()
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
   state_entry()
   {
      #if !defined HOTLAUNCH
        // AllOff();
      #endif
   }

   touch_start(integer n)
   {
        on = !on;
        if (on)
        {
           llOwnerSay("on");
           go(1);
           #if defined REPEATER
             llSetTimerEvent(1);
           #endif
        }
        else
        {
            llOwnerSay("off");
            AllOff();
            llSetTimerEvent(0);
        }
   }

    timer()
    {
        go(1);
    }
}

