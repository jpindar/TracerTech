////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
list buttons1=["fire"];
key owner;
key toucher;
integer handle;
integer chatChan;
integer timeout = 10;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
      owner=llGetOwner();
   }

   touch_start(integer num)
   {
      doMenu(llDetectedKey(0));
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
        notecardList = llCSV2List(msg);
        chatChan = getChatChan();
     }
     if (num & MAINMENU_CMD)
     {
         doMenu(id);
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
   }
}

doMenu(key toucher)
{
   string menuText = "on channel " + (string)chatChan + "\n\nChoose One:";
   integer menuChan = randomChan();
   
   if ((toucher == owner) || llDetectedGroup(1))
   {
      llDialog(toucher,menuText,buttons1,menuChan);
      handle=llListen(menuChan,"",toucher,"");
      llSetTimerEvent(timeout);
   }
}

sendMsg(string msg)
{
    integer cmd = 0;
    
    if (msg =="fire")
       cmd = FIRE_CMD;
   #if defined REMOTE_MENU
      llSay(chatChan,msg);
   #else
      llMessageLinked(LINK_SET, cmd, msg, "");
   #endif
   //debugSay(msg); 
}

