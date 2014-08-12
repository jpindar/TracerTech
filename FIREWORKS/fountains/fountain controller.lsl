///////////////////////////
//fireworks burst controller v1.9.3  14/7/4
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the main prim
//it sends link messages to the actual particle script
//it listens on the description channel then shows, hides etc.
// should respond to chat from the user or from
// the menu script
////////////////////////////
#include "lib.lsl"

float glowOnAmount = 0.0;
string color1 = COLOR_RED;
string color2 = COLOR_RED;
string texture = TEXTURE_CLASSIC;
integer preloadPrim = 2;
integer preloadFace = 2;
key myOwner;
integer handle;
integer chatChan = UNKNOWN;
integer newChan;
integer access = ACCESS_OWNER;
key Query1;
integer done = FALSE;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      myOwner = llGetOwner();
      llSetLinkTexture(preloadPrim,texture,preloadFace);
      if(done == FALSE) state readNotecardToList;
      chatChan = getChatChan();
      handle = llListen(chatChan, "","", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   link_message(integer sender, integer num, string str, key id) //from the menu script
   {
      //debugSay("heard link message " + (string)num + str);
       msgHandler(myOwner, str); 
   }

   listen( integer chan, string name, key id, string msg )// from an avatar
   {
       //debugSay("got message " + msg + " on channel " + (string) chan);
       msgHandler(id, msg);
   }
}

//alas, this has to be after the default state
#include "readNotecardToList.lsl"

msgHandler(string sender, string msg)
{
   //debugSay("got message <" + msg +">");
   //llSetTimerEvent(0);
   msg = llToLower(msg);
   if (sender == myOwner)
   {
      if(msg == "public")
      {
         debugSay("setting access = public");
         access = ACCESS_PUBLIC;
      }
      else if(msg == "group")
      {
         debugSay("setting access = group only");
         access = ACCESS_GROUP;
      }
      else if(msg == "owner")
      {
          debugSay("setting access == owner only");
          access = ACCESS_OWNER;
      }
   }
   if ((access == ACCESS_OWNER) && (!sameOwner(sender)) )
       return;
   if ((access == ACCESS_GROUP) && (!llSameGroup(sender)))
      return;
   if (msg == "fire")
   {
       fire();
   }
   else if (msg == "hide")
   {
       llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
   }
   else if (msg == "show" )
   {
       llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowOnAmount]);
   }
}

sendMsg(string msg)
{
   #if defined REMOTE_CONTROLLER
      llSay(chatChan,msg);
   #endif
   llMessageLinked(LINK_SET, 0, msg, "");
   debugSay(msg);
}

fire()  //this is the only message that goes to the particle script
{
    string fireMsg = (string)color1 + (string)color2;
    //debugSay("sending fire linkmessage" + fireMsg + texture);
    llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_RED+COLOR_WHITE, texture);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_WHITE+COLOR_WHITE, texture);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_BLUE+COLOR_WHITE, texture);
}

