#include "lib.lsl"
integer side = 1; //this will have to be changed in each case
default
{
    link_message(integer sender, integer num, string str, key msg)
    {
       if (num==PRELOAD_TEXTURE_CMD) 
            llSetTexture(msg,side);
    }   
    
} 