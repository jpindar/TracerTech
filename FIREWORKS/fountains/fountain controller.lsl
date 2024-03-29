/*
* fireworks fountain controller
* copyright Tracer Ping 2018
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
* sends link messages to the actual particle scripts
*/

#define NOTECARD_IN_THIS_PRIM
#include "LIB\lib.lsl"
#include "LIB\readNotecardToList.h"
string version = "3.1";
string texture = TEXTURE;

string color1;
string color2;
string color3;
string preloadPrimName = "pre";
integer preloadFace = 0; // was 3?
key owner;
integer handle;
integer chatChan;
key id = "";
integer access;
//integer delay = 2;
float systemAge = 1;

fire(float time)
{
   string fireMsg1 = texture+"," +(string)time+","+color1+","+color2+","+color3;
   //string fireMsg1 = texture+","+color1+","+color1+","+color1;
   //string fireMsg2 = texture+","+color2+","+color2+","+color2;
   //string fireMsg3 = texture+","+color3+","+color3+","+color3;
   debugSay(2, "controller: sending fire linkmsg "+ fireMsg1);
   llMessageLinked(LINK_SET, FIRE_CMD, fireMsg1, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg2, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg3, texture);
}

fireOn(float time)
{
   string fireMsg1 = texture+"," +(string)time+","+color1+","+color2+","+color3;
   debugSay(2, "sending fireOn msg "+ fireMsg1);
   llMessageLinked(LINK_SET, ON_CMD, fireMsg1, texture);
}

msgHandler(string sender, string msg)
{
   debugSay(2,"controller: got message <" + msg +">");
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
      return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      return;
   debugSay(3,"controller: msg = <" + msg +">");
   msg = llToLower(msg);
   if (msg == "fire")
   {
      debugSay(3,"controller: calling fire()");
      fire(systemAge);
   }
   if (msg == "on")
   {
      debugSay(2,"on");
      fireOn(0.0);
   }
   if (msg == "off")
   {
      debugSay(2,"off");
      llMessageLinked(LINK_SET, CMD_OFF , "", "");
   }

   else if (msg == "hide")
   {
       llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
   }
   else if (msg == "show")
   {
       llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
   }
}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      #ifdef NOTECARD_IN_THIS_PRIM
         if(doneReadingNotecard == FALSE) state readNotecardToList;
         chatChan = getChatChan(notecardList);
         color1 = parseColor(notecardList,"color1");
         color2 = parseColor(notecardList,"color2");
         color3 = parseColor(notecardList,"color3");
         systemAge = getFloat(notecardList,"time",1.0);

         owner = llGetOwner();
         //no volume, the emitter makes the sound
         //no collision
         access = getAccess(notecardList);
         //id  = owner;
         handle = llListen( chatChan, "",id, "" );
         llOwnerSay("listening on channel "+(string)chatChan);
         #if defined DESCRIPTION
            llSetObjectDesc("channel "+(string)chatChan+" "+version+" "+DESCRIPTION);
         #else
            llSetObjectDesc("channel "+(string)chatChan+" "+version);
         #endif
      #endif
      integer preloadLink = getLinkWithName(preloadPrimName);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER"))
         llSetLinkTexture(preloadLink,texture,preloadFace);
   }

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
   {
       debugSay(2,"controller: got link message " + msg );
       msgHandler(owner, msg);
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
   {
       debugSay(2,"controller: got message " + msg + " on channel " + (string) chan);
       msgHandler(id, msg);
   }
}

//this has to be after the default state
#include "LIB\readNotecardToList.lsl"


/*
sendMsg(string msg1, string msg2)
{
   #if defined REMOTE_CONTROLLER
      llSay(chatChan,msg);
   #endif
   llMessageLinked(LINK_SET, FIRE_CMD, msg1, msg2);
   debugSay(msg);
}
*/


