#include "lib.lsl"
integer side =0;
//side nmber will have to be changed in each case
// 0 for the tube base inner face
default
{
    link_message(integer sender, integer num, string str, key msg)
    {
       if (num==PRELOAD_TEXTURE_CMD)
            { 
            llSetTexture(msg,side);
            }
    }   
    
} 