/*
*fireworks menu v1.4
*copyright Tracer Tech aka Tracer Ping 2018
*
*gets notecard data via link message
*responds to touch
*listens only to menu
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
          if (menuMode == 0)
          {
             sendMsg("fire");
           }
           else
           {
              llDialog(toucher,menuText,buttonsOwner,menuChan);
           }
      }
      else if ((access == ACCESS_GROUP) && (llSameGroup(toucher)))
      {
          //else if ((access == ACCESS_GROUP) && (llDetectedGroup(0)))
          if (menuMode == 0)
          {
             sendMsg("fire");
          }
          else
          {
             llDialog(toucher,menuText,buttonsOwner,menuChan);
          }
      }
      else //access == ACCESS_PUBLIC
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
         //debugSay("got list:" + llDumpList2String(notecard,"-"));
         chatChan = getChatChan(notecard);
         menuMode = getInteger(notecard,"menu");
         //debugSay("got menuMode = " + (string)menuMode);
         access = getAccess(notecard);
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


