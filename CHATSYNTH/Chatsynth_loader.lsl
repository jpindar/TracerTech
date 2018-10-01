/*
 *  loader for Chatsynth 2.0
 *  Copyright Tracer Ping  2018
 *
 *  touchUV.x goes across the texture from the left to the right
 *  touchUV.y goes across the texture from the bottom to the top
 *  ZERO_VECTOR aka <0.0, 0.0, 0.0> is at the bottom left corner of the texture
*/
//#define DEBUG
#define CHANNEL_BASE 2000
#include "LIB\lib.lsl"
#include "CHATSYNTH\ChatSynth.lsl"


/*
integer targetPrim = 1;
integer targetFace = 2;
integer numberOfRows = 1;
float numberOfColumns = 36.5;
float xOffset =0.117;
integer chan;
integer chanBase = 4000;


integer getTouch()
    {
        integer link = llDetectedLinkNumber(0);
        integer touchFace = llDetectedTouchFace(0);
        vector touchUV = llDetectedTouchUV(0);
        float touchU = touchUV.x;
        float touchV = touchUV.y;
        integer columnIndex = 0;
        integer rowIndex = 0;

         if (llDetectedTouchFace(0) == -1)
        {
            llSay(0, "Sorry, your viewer doesn't support touched faces.");
        }
        else if (touchUV == TOUCH_INVALID_TEXCOORD)
        {
            llSay(0, "touch position upon the texture could not be determined.");
        }
        else
        {
            debugSay("prim " + (string)link + " face " + (string)touchFace);
            if (!(link == targetPrim) && (touchFace == targetFace))
               return -1;

            debugSay("detected touch at " + (string)touchUV);
            columnIndex = llFloor((touchUV.x-xOffset) * numberOfColumns);
            rowIndex = llFloor(touchUV.y * numberOfRows);
            //integer cellIndex = (rowIndex * llFloor(numberOfColumns)) + columnIndex;
            //debugSay("detected touch at " + (string)columnIndex + ", " + (string)rowIndex);
            debugSay("Key "+(string)columnIndex +  " pressed");
        }
        return columnIndex;
    }

default
{

    touch_start(integer num_detected)
    {
        integer keyTouched;
        keyTouched = getTouch();
        chan = chanBase + keyTouched;
        llRegionSay(chan, "fire");
    }
}
*/
