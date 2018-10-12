integer on = FALSE;
vector color = <1.0,1.0,1.0>;
float intensity = 1.0;  // 0 to 1
float radius = 10.0;
float falloff = 1.0;  // 0.0.1 to 2.0 2.0 = abrupt

default
{
    state_entry()
    {
       
    }
    touch_start(integer numOfTouches)
    {
        on = !on;
        if (on)
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,TRUE,color,intensity,radius,falloff]);
        else
        llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POINT_LIGHT,FALSE,color,intensity,radius,falloff]);
      }           
}