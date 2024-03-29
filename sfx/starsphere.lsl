/*
* starsphere  no config
* copyright Tracer Prometheus 2018

  put this in the root prim of a six prim object

 The ANGLE_CONE pattern can be used to imitate the EXPLODE pattern
 by explicitly setting PSYS_SRC_ANGLE_BEGIN to 0.0
 and PSYS_SRC_ANGLE_END to PI (or vice versa).

  define SYSTEMAGE to about 0.1 for parallel colors
  or  about 1.5 for serial

*/
#define DESCRIPTION "Starsphere "
#define VERSION "1.1"
#define REPEATER  // enable timer events

#include "LIB\lib.lsl"

//string texture = "";
//string texture = TEXTURE_BLANK;
string texture = TEXTURE_SPIKESTAR;
//string texture = TEXTURE_PATRIOTIC_STAR;
//string texture = TEXTURE_CLASSIC;
#ifndef COLOR1
   #define COLOR1 COLOR_WHITE
#endif
#ifndef COLOR2
   #define COLOR2 COLOR_WHITE
#endif
#ifndef COLOR3
   #define COLOR3 COLOR_WHITE
#endif

string color = COLOR_WHITE;
string color1 = COLOR_WHITE;
string color2 = COLOR_WHITE;
integer on = FALSE;
integer wind = FALSE;

// PRIDE is a specific type of RAINBOX, but it's the only one implemented so far
#if defined RAINBOW
   #ifndef PRIDE
      #define PRIDE
   #endif
#endif

#if defined STARTGLOW
float startGlow = STARTGLOW;  //notecard will override these
#else
float startGlow = 0;
#endif

#if defined STARTGLOW
float endGlow = ENDGLOW;
#else
float endGlow = 0;
#endif

#ifdef BURSTRADIUS
float burstRadius = BURSTRADIUS;
#else
float burstRadius = 15;
#endif

#if defined STARTALPHA
  float startAlpha = STARTALPHA;
#else
  float startAlpha = 1.0;
#endif
#if defined ENDALPHA
  endAlpha = ENDALPHA;
#else
  float endAlpha = 0.0;
#endif

#ifdef ANGLEEND
   float angleEnd = ANGLEEND;
#else
   float angleEnd = PI;
#endif

#ifdef SYSTEMAGE
   float systemAge = SYSTEMAGE;
   float delay = SYSTEMAGE;
#else
   float systemAge = 0;
   float delay = 1;
#endif

vector startScale = <0.5,0.5,0.0>;
vector endScale = <0.5,0.5,0.0>;
#if !defined SCALEFACTOR
   #define SCALEFACTOR 1.0
#endif

float particleAge = 2.0;
float speed = 0.1;
integer partCount = 200;

makeParticles(integer link, string color1, string color2)
{
   vector particleOmega = <0.0,0.0,0.0>;
   systemSafeSet = systemAge;
   integer flags =
   PSYS_PART_EMISSIVE_MASK |
   PSYS_PART_INTERP_COLOR_MASK |
   PSYS_PART_INTERP_SCALE_MASK ;

   #ifndef NOFOLLOWVELOCITY
   flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
   #endif

   if (wind > 0)
      flags = flags | PSYS_PART_WIND_MASK;

   list particles = [
   PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
   PSYS_SRC_BURST_RADIUS,      burstRadius,
   PSYS_SRC_ANGLE_BEGIN,       0.0,
   PSYS_SRC_ANGLE_END,         angleEnd,
   PSYS_PART_START_COLOR,      (vector)color1,
   PSYS_PART_END_COLOR,        (vector)color2,
   PSYS_PART_START_ALPHA,      startAlpha,
   PSYS_PART_END_ALPHA,        endAlpha,
   PSYS_PART_START_GLOW,       startGlow,
   PSYS_PART_END_GLOW,         endGlow,
   PSYS_PART_START_SCALE,      startScale * SCALEFACTOR,
   PSYS_PART_END_SCALE,        endScale * SCALEFACTOR,
   PSYS_SRC_TEXTURE,           texture,
   PSYS_SRC_MAX_AGE,           systemSafeSet,
   PSYS_PART_MAX_AGE,          particleAge,
   PSYS_SRC_BURST_RATE,        0.1,
   PSYS_SRC_BURST_PART_COUNT,  140,
   PSYS_SRC_ACCEL,             <0.0,0.0,-0.3>,
   PSYS_SRC_OMEGA,             particleOmega,
   PSYS_SRC_BURST_SPEED_MIN,   (1.5*speed),
   PSYS_SRC_BURST_SPEED_MAX,   (1.5*speed),
   PSYS_PART_FLAGS,flags
   ];
   llLinkParticleSystem(link,particles);
   systemSafeSet = 0.0;
}

boom(integer n)
{
   makeParticles(n,color1,color2);
   llSleep(systemAge);
}


allOff()
{
   llParticleSystem([]);
   llLinkParticleSystem(LINK_SET,[]);
}

go(integer on)
{
   if (on)
   {
      integer i;
      integer numOfColors;
      #if defined PRIDE
         list params = llCSV2List("pridered,prideorange,prideyellow,pridegreen,prideblue,pridepurple");
         //params = llCSV2List("<1,0,0,>,<1,1,0>,<0,1,0>,<0,0,1>,<0,1,1>,<1,1,1>");
         numOfColors = 6;
      #elif defined USA
         list params = llCSV2List("red,white,blue");
         numOfColors = 3;
      #elif defined FIRE
         list params = llCSV2List("gold,orange,red");
         numOfColors = 3;
      #elif defined WHITE
         list params = llCSV2List("white,white,white");
         numOfColors = 3;
      #else
         list params = [COLOR1,COLOR2,COLOR3];
         numOfColors = 3;
      #endif
      for (i=0; i<numOfColors; i++)
      {
         color1 = nameToColor( llList2String(params,i));
         //color1 = llList2String(params,i);
         color2 = color1;
         boom(i+1);
      }
   }
   else
   {
      allOff();
   }

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
      llSetObjectName(DESCRIPTION + " v" + VERSION);
   }

   touch_start(integer n)
   {
        on = !on;
        if (on)
        {
           llOwnerSay("on");
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

