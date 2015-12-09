////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
list buttonsOwner=["fire","hide","show"];
//list buttonsGroup=["hide","show","fire"];
//list buttonsPublic=["fire"];
key owner;
integer handle;
integer chatChan;
integer timeout = 10;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}

   touch_start(integer num)
   {
      key toucher;
      integer timeout = 10;
      string menuText = "on channel " + (string)chatChan + "\n\nChoose One:";
      integer menuChan = randomChan();
      toucher=llDetectedKey(0);
      handle=llListen(menuChan,"",toucher,"");
      llDialog(toucher,menuText,buttonsOwner,menuChan);
      llSetTimerEvent(timeout); 
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
   //debugSay(msg); 
}

