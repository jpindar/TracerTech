///////////////////////////
//fireworks fountain controller
//Tracer Ping 2013
////////////////////////////
string color1 = "<1.00,0.00,0.00>";
string color2 = "<1.00,1.00,0.00>";
string texture;
key owner;
key toucher;
integer handle;
integer chatChan;
integer newChan;
integer access;
integer preloadFace = 2;

#include "lib.lsl"

default
{
   on_rez(integer n){llResetScript();}  
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}
 
   state_entry()
   {
      texture = TEXTURE_CLASSIC;
      chatChan = objectDescToInt();
      owner=llGetOwner();
      access = PUBLIC;
      handle = llListen(chatChan, "", "", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
      llSetTexture(texture,preloadFace);
   }

    link_message(integer sender, integer num, string str, key id)
    {
      llSay(MY_DEBUG_CHAN,"Heard link msg  ");
       msgHandler(owner, str); 
    }
    
    listen( integer chan, string name, key id, string msg )
    {
      llSay(MY_DEBUG_CHAN,"Heard chat msg ");  
       msgHandler(id, msg);
    }
}

msgHandler(string sender, string msg)
   {
       llSay(MY_DEBUG_CHAN,"heard " + msg +" from" + sender);
      llSetTimerEvent(0);
      if (sender == owner)
      {
         if(msg == "public")
         {
            access = PUBLIC;
         }
         else if(msg == "group")
         {
            access = GROUP;
         }
         else if(msg == "owner")
         {
            access = OWNER;
         }
      }
      if ((access == OWNER) && (!(sender == owner)))
          return;
      if ((access == GROUP) && (!llDetectedGroup(0)))
         return;
 
     if ( msg == "fire" )
      {
         fire();
      }
      else if(msg =="reset")
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
         chatChan = ((integer)llDeleteSubString(msg, 0, llStringLength("set channel")));
         setObjectDesc((string)chatChan);   
         llResetScript();
      }
      else
      {
         llListenRemove(handle);
      }
}

sendMsg(string msg)
{
   llMessageLinked(LINK_SET, 0, msg, "");
  llSay(MY_DEBUG_CHAN,msg);  
}

fire()
{
    string fireMsg = (string)color1 + (string)color2;
    llSay(MY_DEBUG_CHAN,"sending fire linkmessage" + fireMsg + texture);
    llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
}




