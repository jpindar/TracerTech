////////////////////////
//fireworks menu v1.0
//copyright Tracer Tech aka Tracer Ping 2014
/////////////////////////////
string menutext="\nChoose One:";
list buttonsOwner=["owner","group","public","hide","show","channel", "fire"];
list buttonsAll=["fire"];
key owner;
key toucher;
integer handle;
integer chatChan;
integer menuChan;
integer access;

#include "lib.lsl"
 
default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
      chatChan = objectDescToInt();
      menuChan = randomChan();
      owner=llGetOwner();
      access = ACCESS_PUBLIC;
   }

   touch_start(integer num)
   {
      toucher=llDetectedKey(0);
      if (toucher == owner)
      {
          llDialog(toucher,menutext,buttonsOwner,menuChan);
      }
      else if ((access == ACCESS_GROUP) && (llSameGroup(toucher)))
      {
          llDialog(toucher,menutext,buttonsAll,menuChan);
      }
      else if ((access == ACCESS_PUBLIC)) 
      {
          llDialog(toucher,menutext,buttonsAll,menuChan);
      }
      else
      {
      }
      handle=llListen(menuChan,"",toucher,"");
      llSetTimerEvent(10); 
   }

   timer()
   {
       llSetTimerEvent(0);
       llListenRemove(handle);
   }
   
   listen(integer chan,string name,key id,string button)  //listen to dialog box
   {
      llSetTimerEvent(0);
      llListenRemove(handle);
      if (toucher == owner)
      {
         if(button == "public")
         {
            access = ACCESS_PUBLIC;
            sendMsg("PUBLIC");
         }
         else if(button == "group")
         {
            access = ACCESS_GROUP;
            sendMsg("GROUP");
         }
         else if(button == "owner")
         {
            access = ACCESS_OWNER;
            sendMsg("OWNER");
         }
      }
      if(button=="fire")
      {
          debugSay("menu firing");
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
      else if (button=="channel")
      {
         state changeChannel;
      }
      else if(button=="reset")
      {
          sendMsg("reset");
          llResetScript();
      }
   }
}


state changeChannel
{
   state_entry()
   {
      integer menuChan2 = randomChan();
      llTextBox(toucher,"enter new channel",menuChan2);
      integer handle2=llListen(menuChan2,"",toucher,"");
      llSetTimerEvent(10);
   }

   listen(integer channel,string name,key toucher,string msg)
   {
      llSetTimerEvent(0);
      integer newChan = (integer)msg;
      msg = "set channel " + (string)newChan;
      sendMsg(msg);
      chatChan = newChan;
      setObjectDesc((string)chatChan);
      state default;
   }

   timer()
   {
      state default;
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

