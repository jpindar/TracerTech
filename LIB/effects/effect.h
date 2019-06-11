/*

particle system header
effect.h
v1.0

*/

   #if defined BEGINANGLE
      float beginAngle = BEGINANGLE;
   #elif defined STARTANGLE
      float beginAngle = STARTANGLE;
   #else
      float beginAngle = 0;
   #endif
   
   #if defined ENDANGLE
      float endAngle = ENDANGLE;
   #else
      float endAngle = PI;
   #endif

   #if defined STARTALPHA
   float startAlpha = STARTALPHA;
   #else
   float startAlpha = 1.0;
   #endif
   #if defined ENDALPHA
   float endAlpha = ENDALPHA;
   #else
   float endAlpha = 0.2;
   #endif

   #if defined STARTGLOW
   float startGlow = STARTGLOW;
   #else
   float startGlow = 0.0;
   #endif
   #if defined ENDGLOW
   float endGlow = ENDGLOW;
   #else
   float endGlow = 0.0;
   #endif
    
   #if defined STARTSCALE
      vector startScale = STARTSCALE;
   #else
      vector startScale = <0.5,0.5,0.0>;
   #endif

   #if defined ENDSCALE
      vector  endScale = ENDSCALE;
   #else
      vector endScale = <0.5,0.5,0.0>;
   #endif

   //#if defined PARTICLE_SCALE
   //float partSizeScale = PARTICLE_SCALE;
   //#else
   //float partSizeScale = 1.0;
   //#endif

   #ifdef BURSTRADIUS
   float burstRadius = BURSTRADIUS;
   #else
   float burstRadius = 0.0;
   //float burstRadius = 1.5;
   #endif

   #ifdef PARTCOUNT
   integer partCount = PARTCOUNT;
   #else
   integer partCount = 300;
   #endif
   
   #ifdef FOLLOWVELOCITY
      integer followVelocity = TRUE;
   #else
      integer followVelocity = FALSE;
   #endif
   
   #ifdef BURSTRATE
      float burstRate = BURSTRATE;
   #else
      float burstRate = 0.1;  // was 0.2
   #endif

   #if defined SYSTEMAGE
   float systemAge = SYSTEMAGE;
   #else
   float systemAge = 1.0;
   #endif
   
   #ifdef PARTAGE
   float partAge = PARTAGE;
   #else
   float partAge = 1;
   #endif

   // this can be overridden by a launch message, 
   // but we still want the variables declared here
   #if defined MAXPARTSPEED
   float maxPartSpeed = MAXPARTSPEED;
   #else
   float maxPartSpeed = 1.0;
   #endif

   #if defined MINPARTSPEED
   float minPartSpeed = MINPARTSPEED;
   #else
   float minPartSpeed = 1.0;
   #endif

   vector partOmega = <0.0,0.0,0.0>;
   float burstCount;
   vector partAccel;
   string texture;
   //integer flags;

