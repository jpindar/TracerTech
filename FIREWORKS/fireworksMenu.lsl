/*
*fireworks menu v1.3
*copyright Tracer Tech aka Tracer Ping 2015
*
*gets notecard data via link message
*responds to touch
*listens only to menu
*/
list buttonsOwner=["fire","hide","show"];
//list buttonsGroup=["hide","show","fire"];
//list buttonsPublic=["fire"];
key owner;
integer handle;
integer menuChan;
integer chatChan;
integer menuMode = 1;
integer access;
integer timeout = 10;

#include "lib.lsl"

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
       //llOwnerSay("menumode  "+ (string)menuMode);
      if (menuMode == 0)
      {
          sendMsg("fire");
      }
      else
      {
         key toucher;
         integer timeout = 10;
         string menuText = "on channel " + (string)chatChan + "\n\nChoose One:";
         toucher=llDetectedKey(0);
         llDialog(toucher,menuText,buttonsOwner,menuChan);
         handle=llListen(menuChan,"",toucher,"");
         llSetTimerEvent(timeout);
      }
   }

   timer()
   {
       llSetTimerEvent(0);
       llListenRemove(handle);
   }

  link_message( integer sender, integer num, string msg, key id )
  {
     list notecardList;
     if (num & RETURNING_NOTECARD_DATA)
     {
         notecardList = llCSV2List(msg);
         chatChan = getChatChan(notecardList);
         menuMode = getMenuMode(notecardList);
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
   }
}

sendMsg(string msg)
{
   #if defined REMOTE_MENU
      llSay(chatChan,msg);
   #endif
   llMessageLinked(LINK_SET, 0, msg, "");
   debugSay(msg);
}

