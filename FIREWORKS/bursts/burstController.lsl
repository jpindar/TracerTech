////////////////////////
//fireworks burst controller v1.14
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the burst prim
//it link messages to the actual particle script
// it listens on the description channel then shows, hides etc.

/////////////////////////////
string menutext="\nChoose One:";
list buttonsOwner=["channel","reset","foo","owner","group","public", "fire","hide","show"];
list buttonsAll=["channel","reset","foo", "fire","hide","show"];
key owner;
key toucher;
integer handle;
string group;
integer chatChan;
integer menuChan;
integer newChan;
integer PUBLIC = 0;
integer GROUP = 1;
integer OWNER = 2;
integer access;
key textureKey ="";
key id = "";
integer preloadFace = 2;
float glowOnAmount = 0.0; //or 0.05


#include "lib.lsl"

fire()  //this is the only message that goes to the particle script
{
    debugSay("firing");
    llMessageLinked( LINK_SET, num, color, textureKey);
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      llSetTexture(textureKey,preloadFace);
      chatChan = objectDescToInt();
      menuChan = randomChan();
      owner=llGetOwner();
      access = PUBLIC;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   touch_start(integer num)
   {
      toucher=llDetectedKey(0);
      if (toucher == owner)
      {
          llDialog(toucher,menutext,buttonsOwner,menuChan);
      }
      else if ((access == GROUP) && (llDetectedGroup(0)))
      {
          llDialog(toucher,menutext,buttonsAll,menuChan);
      }
      else if ((access == PUBLIC)) 
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
   
   listen( integer chan, string name, key id, string msg ) //listen for chat command
   {
      llSetTimerEvent(0);
      if (toucher == owner)
      {
         if(msg == "public")
         {
            access = PUBLIC;
            sendMsg("PUBLIC");
         }
         else if(msg == "group")
         {
            access = GROUP;
            sendMsg("GROUP");
         }
         else if(msg == "owner")
         {
            access = OWNER;
            sendMsg("OWNER");
         }
      }
      if(msg=="fire")
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetLinkAlpha(LINK_ALL,0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_ALL,1.0, ALL_SIDES);
         //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (msg=="channel")
      {
         state changeChannel;
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chan = 0;
         setObjectDesc((string)chan);  //TEST ME does this set the prim or the object? 
         llResetScript();
      }
      else if(msg=="reset")
      {
          llResetScript();
      }
      if(msg=="Cancel")
      {
         llListenRemove(handle);
      }
      else
      {
         llListenRemove(handle);
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
        {
           llSetTimerEvent(0);
           newChan = (integer)msg;
           //msg = "set channel " + (string)newChan;
           //sendMsg(msg);
           chatChan = newChan;
           setObjectDesc((string)chatChan);
           state default;
        }
    }   
      
   timer()
   {
       state default;
   }
}

sendMsg(string msg)
{
   llSay(chatChan,msg);  
   llMessageLinked(LINK_SET, 0, msg, "");   
   llSay(DEBUG_CHANNEL,msg); 
}



