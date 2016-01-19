/*
//fireworks burst controller v2.0  2014/8/14
//copyright Tracer Tech aka Tracer Ping 2014
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*/
#define NOTECARD_IN_THIS_PRIM
#include "lib.lsl"

string color1 = COLOR_WHITE;
string color2 = COLOR_WHITE;
string color3 = COLOR_WHITE;
string texture = TEXTURE_SPIKESTAR;
//string texture = TEXTURE_CLASSIC;
float glowAmount = 0.0;
key owner; 
string preloadPrimName = "e1";
integer preloadFace = 0;
integer handle;
integer chatChan;
key id = "";
integer access;
integer delay = 0;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;

         chatChan = getChatChan(notecardList);
         owner = llGetOwner();
         //no volume, the emitter makes the sound
         //no collision
         access = getAccess(notecardList);
         //id  = owner;
         handle = llListen( chatChan, "",id, "" );
         llOwnerSay("listening on channel "+(string)chatChan);
      #endif
      llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
   }

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
   {
       debugSay("controller: got link  message " + msg );
       msgHandler(owner, msg); 
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
   {
       debugSay("controller: got message " + msg + " on channel " + (string) chan);
       msgHandler(id, msg);
   }
}

//this has to be after the default state
#include "readNotecardToList.lsl"

msgHandler(string sender, string msg)
{
   //debugSay("got message <" + msg +">");
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
      return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      return;
   //debugSay("got message <" + msg +">");
   msg = llToLower(msg);
   if (msg == "fire")
   {
       fire();
   }
   else if (msg == "hide")
   {
       llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
   }
   else if (msg == "show")
   {
       llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowAmount]);
   }
}

/*
sendMsg(string msg)
{
   #if defined REMOTE_CONTROLLER
      llSay(chatChan,msg);
   #endif
   llMessageLinked(LINK_SET, 0, msg, "");
   debugSay(msg);
}
*/

fire()
{
   //string fireMsg1 = color1+color2+color3;
   string fireMsg1 = color1+color1+color1;
   fireMsg2 = color2+color2+color2;
   fireMsg3 = color3+color3+color3;

   llMessageLinked(LINK_SET, FIRE_CMD, fireMsg1, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg2, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg3, texture);
}

