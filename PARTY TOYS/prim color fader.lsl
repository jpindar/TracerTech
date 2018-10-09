
/*
   color fader  
   copyright 2019 Tracer Prometheus
   Continuoulsy changes the hue of a prim, keeping the intensit and saturation constant.
   
*/
#include "LIB\lib.lsl"
#include "LIB\colorlib.lsl"

float time = 0.1;
float e = 0.01;
float hue = 1.0;
float saturation = 1.0;
float lightness = 0.5;
vector color;
float intensity = 1.0;
float radius = 1;
float falloff = 0.1;


default
{
    state_entry()
    {
        llSetTimerEvent(time);
    }

   timer()
    {
        hue += e;
        if (hue > 1.0)
            hue = 0;
        color = HSL2RGB(<hue,saturation, lightness>);
        llSetColor(color,ALL_SIDES);
        //setParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,color,intensity,radius,falloff]);
    }
}
