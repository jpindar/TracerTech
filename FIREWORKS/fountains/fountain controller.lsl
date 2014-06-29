//fireworks controller
//Tracer Ping 2013

//string  SOUND = "0f76aca8-101c-48db-998c-6018faf14b62"; // a click sound
integer num = 1;
string  cmd_On = "fire";
string desc;
string color = "<1.0,0.0,0.0>";
integer chan = 556;
integer Handle;
integer textureIndex = 1;
key textureKey;

fire()
{
    llMessageLinked( LINK_SET, num, color, textureKey);
}

default
{
   on_rez(integer n){llResetScript();}  
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}
 
   state_entry()
   {
      chan = (integer)llGetObjectDesc();
      llListen( chan, "", "", "" );
      //Handle = llListen (channel, "", llGetOwner(), "");
      llOwnerSay("listening on channel "+(string)chan);
      //textureKey = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,textureIndex));
      llSetTexture(textureKey,2);
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
         if ((chan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chan = 0;
         llSetObjectDesc((string)chan);   
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
       chan = (integer)llGetObjectDesc();
       //llPlaySound( SOUND, 0.5 );
       fire();
    }
}






