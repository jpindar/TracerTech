////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
list buttonsOwner=["fire","hide","show"];
key owner;
key toucher;
integer handle;
integer menuChan;
integer chatChan;
integer timeout = 10;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
      menuChan = randomChan();
   }

   touch_start(integer num)
   {
      string menuText = "on channel " + (string)chatChan + "\n\nChoose One:";
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
     if (num & RETURNING_NOTECARD_DATA)
        notecardList = llCSV2List(msg);
     chatChan = getChatChan();
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

