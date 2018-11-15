/*
*fireworks menu v1.5
*copyright Tracer Tech aka Tracer Ping 2018
*
*gets notecard data via link message
*responds to touch , either by sending fire message immediately
* or by creating a menu and listening to it
*
* when touched either sends fire command (via chat or linkmessage, determined at compiletime) or opens a popup menu.
*
* link message listener: if linkmessage parameter num is RETURNING_NOTECARD_DAT
* it parses control channel, menumode, and accessmode from parameter msg
*
* chat listener (listening to the popup menu)
* handles menu button presses by sending a command (fire, show or hide) via chat or
* linkmessage (determined at compiletime)
*
*/
//#define LINKED
list buttonsOwner=["fire","hide","show"];
list buttonsPublic=["fire"];
key owner;
key toucher;
integer handle;
integer chatChan;
integer menuChan;
integer access;
integer menuMode = 1;
integer enabled = FALSE;

#include "LIB\lib.lsl"

sendMsg(string msg)
{
   #if defined REMOTE_MENU
      llSay(chatChan,msg);
   #endif
   #if defined LINKED
      llMessageLinked(LINK_THIS, 0, msg, "");
   #else
      llMessageLinked(LINK_SET, 0, msg, "");
   #endif
   //llMessageLinked(LINK_SET, 0, msg, "");
   //llMessageLinked(LINK_SET, 0, msg, "");
}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      menuChan = randomChan();
      owner=llGetOwner();
      access = ACCESS_PUBLIC;
   }

   touch_start(integer num)
   {
      if (! enabled)
         return;
      integer timeout = 10;
      string menuText = "listening on channel " + (string)chatChan;
      toucher=llDetectedKey(0);
      if (toucher == owner)
      {
      debugSay(1,"you are the owner");
      debugSay(1,"menuMode = " + (string)menuMode);
         if (menuMode == 0)
         {
            sendMsg("fire");
         }
         else
         {
            llDialog(toucher,menuText,buttonsOwner,menuChan);
         }
      }
      //else if (llDetectedGroup(0))
      else if (llSameGroup(toucher))
      {
         //llOwnerSay("you are in the group");
         if ((access == ACCESS_GROUP) || (access == ACCESS_PUBLIC))
         {
            if (menuMode == 0)
            {
               sendMsg("fire");
            }
            else
            {
               llDialog(toucher,menuText,buttonsOwner,menuChan);
            }
         }
         else
         {
            llInstantMessage(toucher,"sorry, access is set to owner-only");
            return;
         }
      }
      else //public
      {
         debugSay(1,"you are in the public");
         if (access == ACCESS_PUBLIC)
         {
            if (menuMode == 0)
            {
               sendMsg("fire");
            }
            else
            {
              llDialog(toucher,menuText,buttonsPublic,menuChan);
            }
         }
         else
         {
            if (access == ACCESS_GROUP)
               llInstantMessage(toucher,"sorry, access is set to group-only");
            else
               llInstantMessage(toucher,"sorry, access is set to owner-only");
            return;
         }
      }
      handle=llListen(menuChan,"",toucher,"");
      llSetTimerEvent(timeout);
   }

   timer()
   {
      llSetTimerEvent(0);
      llListenRemove(handle);
   }

  link_message( integer sender, integer num, string msg, key id )
  {
     if (num & RETURNING_NOTECARD_DATA)
     {
         list notecard = llCSV2List(msg);
         //debugSay(2,"got list:" + llDumpList2String(notecard,"-"));
         chatChan = getChatChan(notecard);
         menuMode = getInteger(notecard,"menu");
         //debugSay(3,"got menuMode = " + (string)menuMode);
         access = getAccess(notecard);
         //debugSay(3,"access from notecard = " + (string)access);
         enabled = TRUE;
     }
   }

   listen(integer chan,string name,key id,string button)  //listen to dialog box
   {
      llSetTimerEvent(0);
      llListenRemove(handle);
      if(button=="fire")
      {
          sendMsg("fire");
      }
      if(button=="show")
      {
         sendMsg("show");
      }
      else if(button=="hide")
      {
         sendMsg("hide");
      }
      //else if(button=="reset")
      //{
      //    sendMsg("reset");
      //    llResetScript();
      //}
   }
}


