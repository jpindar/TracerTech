/*

particle system header
effect.h
v1.0

*/

   float beginAngle = 0;
   float endAngle = PI;

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
    
    
   vector startSize = <0.5,0.5,0.0>;
   vector endSize = <0.5,0.5,0.0>;

   #if defined PARTICLE_SCALE
   float partSizeScale = PARTICLE_SCALE;
   #else
   float partSizeScale = 1.0;
   #endif

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
   
   float burstRate = 0.2;
   
   //float maxPartSpeed = 2.0;
   //float minPartSpeed = 2.0;
   float maxPartSpeed = 1.5;
   float minPartSpeed = 1.5;
   vector partOmega = <0.0,0.0,0.0>;
   float burstCount;
   vector partAccel;

///   float partAge = 5;
   float partAge = 1;
   float systemAge = 1;
   
   string texture;
   float rate ;

   //integer flags;

