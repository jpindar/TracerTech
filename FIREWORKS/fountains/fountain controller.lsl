///////////////////////////
//fireworks fountain controller
//Tracer Ping 2013

//string  SOUND = "0f76aca8-101c-48db-998c-6018faf14b62"; // a click sound
integer FIRE_CMD = 1;
string color = "<1.0,0.0,0.0>";
integer chatChan;
integer handle;
integer textureIndex = 1;
key textureKey;
integer preloadFace = 2;

#include "lib.lsl"



default
{
   on_rez(integer n){llResetScript();}  
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}
 
   state_entry()
   {
      chatChan = objectDescToInt();
      handle = llListen(chatChan, "", "", "" );
      //handle = llListen (channel, "", llGetOwner(), "");
      llOwnerSay("listening on channel "+(string)chatChan);
      //textureKey = getInventoryTexture();
      llSetTexture(textureKey,preloadFace);
   }

   listen( integer chan, string name, key id, string msg )
   {
      if ( msg == "show" )
      {
         llSetAlpha(1.0, ALL_SIDES);
        // llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, 0.00]);
      }
      else if ( msg == "hide")
      {
          llSetAlpha(0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if ( msg == "fire" )
      {
         fire();
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chatChan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chatChan = 0;
         setObjectDesc((string)chatChan);   
         llResetScript();
      }
      /*
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set texture")
      {
          integer numTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
          textureIndex = (integer)llToLower(llDeleteSubString(msg, 0, 11));
          if (textureIndex >= numTextures)
          {
              llOwnerSay("texture indexes must be 0 to " + (string)numTextures);
            return;
          }
          textureKey = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,textureIndex));
          llSetTexture(textureKey,2);
          llOwnerSay("texture set to "+(string)textureIndex+ " or " + (string)textureKey);
      }
      else if (llToLower(llGetSubString(msg, 0, 8)) == "set color")
      {
          color = llDeleteSubString(msg, 0, 9));
          llOwnerSay("color set to "+color);
      }

      */
   }

    touch_start(integer total_number)
    {
       chatChan = objectDescToInt();
       fire();
    }
}

fire()
{
    llMessageLinked( LINK_SET, FIRE_CMD, color, textureKey);
}




