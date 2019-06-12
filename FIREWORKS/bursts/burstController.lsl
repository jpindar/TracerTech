/*
* fireworks burst controller v3.0
* copyright Tracer Ping 2015
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*/


//#define DEBUG
string version = "3.02";
#define NOTECARD_IN_THIS_PRIM
#include "LIB\lib.lsl"
#include "LIB\readNotecardToList.h"

string texture = TEXTURE;
string color;
float glowAmount = 0.0;
key owner;
string preloadPrimName = "preloader";  //can be same as emitter?
integer preloadFace = 0;
integer handle;
integer chatChan;
key id = "";
integer access;
float delay = 0.0;  // 0.3 for multiburst
integer maxColors = 12;


/* for multiburst,
  add more parseColors as needed, ideally two per prim per burst

  construct fireMsg's

  uncomment delays and llMessageLinked's
 */
fire()
{
   integer i;
   string fireMsg = texture;
   for (i=1; i<=maxColors; i++)
   {
     color = parseColor(notecardList,"color"+(string)i);
     fireMsg =fireMsg + "," + color;
   }

   debugSay(2,"controller: sending fire msg " + fireMsg);
   llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg2, texture);
   //llSleep(delay);
   //llMessageLinked(LINK_SET, FIRE_CMD, fireMsg3, texture);
}


msgHandler(string sender, string msg)
{
   debugSay(2,"got message <" + msg +">");
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
      return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)) && (owner != id))
      return;
   debugSay(2,"got message <" + msg +">");
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
         llSetObjectDesc((string)chatChan + " "+version + DESCRIPTION);
      #endif
      integer preloadLink = getLinkWithName(preloadPrimName);
      debugSay(3,"preloader is "+(string)preloadLink);
      if (assert((preloadLink>0),"CAN'T FIND THE PRELOADER"))
         llSetLinkTexture(preloadLink,texture,preloadFace);
   }

   //link messages come from the menu script
   link_message(integer sender, integer num, string msg, key id)
   {
      debugSay(2, "got link  message " + msg );
      msgHandler(owner, msg);
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
   {
      debugSay(2,"got message " + msg + " on channel " + (string) chan);
      msgHandler(id, msg);
   }
}

//this has to be after the default state
#include "LIB\readNotecardToList.lsl"


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


