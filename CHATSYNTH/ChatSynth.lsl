//  touchUV.x goes across the texture from the left to the right
//  touchUV.y goes across the texture from the bottom to the top
//  ZERO_VECTOR (<0.0, 0.0, 0.0> ... the origin) is in the bottom left corner of the texture

integer targetPrim = 1;
integer targetFace = 2;
integer numberOfRows = 1;
float numberOfColumns = 36.5;
float xOffset =0.117;
integer chan;
integer chanBase = 5000;

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
            llWhisper(0, "Sorry, your viewer doesn't support touched faces.");
        }
        else if (touchUV == TOUCH_INVALID_TEXCOORD)
        {
            //TOUCH_INVALID_TEXCOORD has the vector value <-1.0, -1.0, 0.0>
            llWhisper(0, "Sorry, the touch position upon the texture could not be determined.");
        }
        else
        {
            debugSay("prim " + (string)link + " face " + (string)touchFace);
            if (!(link == targetPrim) && (touchFace == targetFace))
               return -1;
               
           // llSay(0, "llDetectedTouchUV(" + (string)touchUV + ")");
            columnIndex = llFloor((touchUV.x-xOffset) * numberOfColumns);
            rowIndex = llFloor(touchUV.y * numberOfRows);
            //nteger cellIndex = (rowIndex * llFloor(numberOfColumns)) + columnIndex;
           //  llSay(0,"UV (" + (string)columnIndex + ", " + (string)rowIndex + ") --> " + (string)cellIndex);
           debugSay("touch at " + (string)columnIndex + ", " + (string)rowIndex);
           llWhisper(0," Key "+(string)columnIndex +  " pressed");

        }
        return columnIndex;
    }

debugSay(string msg)
{
    //if (debug )llOwnerSay(msg);
}

