////////////////////////
//fireworks burst controller v1.14
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
float glowOnAmount = 0.0; //or 0.05
integer chan;
integer handle;
key textureKey ="";
key id = "";
integer preloadFace = 2;

#include "lib.lsl"

fire()
{
    debugSay("firing");
    llMessageLinked( LINK_SET, num, color, textureKey);
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      llSetTexture(textureKey,preloadFace);
      //id = llGetOwner();
      chan = objectDescToInt();
      handle = llListen( chan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chan);
   }

   listen( integer chan, string name, key id, string msg )
   {
      debugSay("I heard <"+msg+">");
      if ( msg == "fire" )
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetAlpha(0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if ( msg == "show" )
      {
         llSetAlpha(1.0, ALL_SIDES);
         //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chan = 0;
         llSetObjectDesc((string)chan);
         llResetScript();
      }
   }

}

