///////////////////////////
//fireworks burst controller v2.0  2014/8/14
//copyright Tracer Tech aka Tracer Ping 2014
//this goes in the main prim
//it sends link messages to the actual particle script
//it listens on the description channel then shows, hides etc.
// should respond to chat from the user or from
// the menu script
////////////////////////////
#include "lib.lsl"
integer debug = FALSE;

string color1 = COLOR_WHITE;
string color2 = COLOR_WHITE;
string color3 = COLOR_WHITE;
string texture = TEXTURE_CLASSIC;
key owner; 
string preloadPrimName = "preloader";
integer preloadFace = 0;
float glowAmount = 0.0;
integer handle;
integer chatChan = UNKNOWN;
key id = "";
integer delay = 2;

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
      if(doneReadingNotecard == FALSE) state readNotecardToList;
      chatChan = getChatChan();
      owner = llGetOwner();
      //id  = owner;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   //link mmessages come from the menu script
   link_message(integer sender, integer num, string str, key id) //from the menu script
   {
       //debugSay("heard link message " + (string)num + str);
       msgHandler(owner, str); 
   }

   //chat comes from trigger or avatar
   listen( integer chan, string name, key id, string msg )
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
   msg = llToLower(msg);
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
       llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowAmount]);
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

fire()
{
    string fireMsg = color1+color2+color3;
    //debugSay("sending fire linkmessage" + fireMsg + texture);
    llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
    //llMessageLinked(LINK_SET, FIRE_CMD, color1+color1, texture);
    //llSleep(delay);
    //llMessageLinked( LINK_SET, FIRE_CMD, color2+color2, texture);
    //llSleep(delay);
    //llMessageLinked( LINK_SET, FIRE_CMD, color3+color3, texture);
}

