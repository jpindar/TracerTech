///////////////////////////
//fireworks fountain controller
//Tracer Ping 2013
////////////////////////////
//string  SOUND = "0f76aca8-101c-48db-998c-6018faf14b62"; // a click sound
integer FIRE_CMD = 1;
string color = "<1.0,0.0,0.0>";
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
integer textureIndex = 1;
key textureKey;
integer preloadFace = 2;

#include "lib.lsl"



default
{
   on_rez(integer n){llResetScript();}  
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}
 
   state_entry()
   {
      chatChan = objectDescToInt();
      menuChan = randomChan();
      owner=llGetOwner();
      access = PUBLIC;
      handle = llListen(chatChan, "", "", "" );
      //handle = llListen (channel, "", llGetOwner(), "");
      llOwnerSay("listening on channel "+(string)chatChan);
      //textureKey = getInventoryTexture();
      llSetTexture(textureKey,preloadFace);
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

   listen(integer chan,string name,key id,string msg)  //listen to dialog box
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
     if ( msg == "fire" )
      {
          llSay(DEBUG_CHANNEL,"firing");
         fire();
      }
      else if(msg=="reset")
      {
          sendMsg("reset");
          llResetScript();
      }
      if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
        // llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, 0.00]);
      }
      else if ( msg == "hide")
      {
          llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }

      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chatChan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chatChan = 0;
         setObjectDesc((string)chatChan);   
         llResetScript();
      }
      else if (msg=="channel")
      {
         state changeChannel;
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
      /*
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set texture")
      {
          integer numTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
          textureIndex = (integer)llToLower(llDeleteSubString(msg, 0, 11));
          if (textureIndex >= numTextures)
          {
              llOwnerSay("texture indexes must be 0 to " + (string)numTextures);
            return;
          }
          textureKey = llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE,textureIndex));
          llSetTexture(textureKey,2);
          llOwnerSay("texture set to "+(string)textureIndex+ " or " + (string)textureKey);
      }
      else if (llToLower(llGetSubString(msg, 0, 8)) == "set color")
      {
          color = llDeleteSubString(msg, 0, 9));
          llOwnerSay("color set to "+color);
      }

      */
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
   //llSay(chatChan,msg);  
   llMessageLinked(LINK_SET, 0, msg, "");
   llSay(DEBUG_CHANNEL,msg); 
}

fire()
{
    llMessageLinked( LINK_SET, FIRE_CMD, color, textureKey);
}




