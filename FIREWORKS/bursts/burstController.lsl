////////////////////////
//fireworks burst controller v1.14
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the burst prim
//it link messages to the actual particle script
// it listens on the description channel then shows, hides etc.
/////////////////////////////
float glowOnAmount = 0.0; //or 0.05
string SOUND = "0f76aca8-101c-48db-998c-6018faf14b62"; // a click sound
string color = "<1.0,1.0,1.0>";
key owner;
integer handle;
integer FIRE_CMD = 1;
string group;
integer chatChan;
integer newChan;
integer PUBLIC = 0;
integer GROUP = 1;
integer OWNER = 2;
integer access;
key textureKey ="";
key id = "";
integer preloadFace = 2;

#include "lib.lsl"

fire()  //this is the only message that goes to the particle script
{
    debugSay("firing");
    llMessageLinked( LINK_SET,FIRE_CMD, color, textureKey);
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      llSetTexture(textureKey,preloadFace);
      //id = llGetOwner();
      chatChan = objectDescToInt();
      access = PUBLIC;
      handle = llListen( chatChan, "","", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   listen( integer chan, string name, key id, string msg ) //listen for chat not menu 
   {
      llSetTimerEvent(0);
      if (id == owner)
      {
         if(msg == "public")
         {
            access = PUBLIC;
         }
         else if(msg == "group")
         {
            access = GROUP;
         }
         else if(msg == "owner")
         {
            access = OWNER;
         }
      }
      if (access = owner) && (!(id = owner))
          return;
      if (access = GROUP) && (!llDetectedGroup(0))
         return;
      if (msg == "fire")
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetLinkAlpha(LINK_ALL,0.0, ALL_SIDES);
          llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_ALL,1.0, ALL_SIDES);
         llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chan = 0;
         setObjectDesc((string)chan);
         llResetScript();
      }
      else
      {
         llListenRemove(handle);
      }
   }
}


sendMsg(string msg)
{
   //llSay(chatChan,msg);
   llMessageLinked(LINK_SET, 0, msg, "");   
   llSay(DEBUG_CHANNEL,msg); 
}


