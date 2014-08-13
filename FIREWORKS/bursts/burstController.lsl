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

float glowOnAmount = 0.05;
string color1 = COLOR_RED;
string color2 = COLOR_RED;
string color3 = COLOR_RED;
string texture = TEXTURE_CLASSIC;
key myOwner; 
integer handle;
integer chatChan;
key id = "";
integer newChan;
integer access;
integer delay = 2;

default
{
   on_rez(integer n){llResetScript();}

   state_entry()
   {
      llMessageLinked(LINK_SET, PRELOAD_TEXTURE_CMD, "", texture);
      //id = llGetOwner();
      chatChan = objectDescToInt();
      myOwner = llGetOwner();
      access = ACCESS_PUBLIC;
      handle = llListen( chatChan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

   link_message(integer sender, integer num, string str, key id) //from the menu script
   {
       debugSay("heard link message " + str);
       msgHandler(myOwner, str); 
   }

   listen( integer chan, string name, key id, string msg )
   {
       debugSay("got message " + msg + " on channel " + (string) chan);
       msgHandler(id, msg);
   }
   
    touch_start(integer total_number)
    {
   //    fire();
    }
   
}

msgHandler(string sender, string msg)
{
      debugSay("got message <" + msg +">");
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
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
          llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if (msg == "show" )
      {
          llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
          llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llGetSubString(msg, 0, 10) == "set channel")
      {
         chatChan = ((integer)llDeleteSubString(msg, 0, llStringLength("set channel")));
         setObjectDesc((string)chatChan);
         llResetScript();
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
    debugSay("sending fire linkmessage" + fireMsg + texture);
    llMessageLinked(LINK_SET, FIRE_CMD, fireMsg, texture);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_RED+COLOR_WHITE, texture);
    //llSleep(delay);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_WHITE+COLOR_WHITE, texture);
    //llSleep(delay);
    //llMessageLinked( LINK_SET, FIRE_CMD, COLOR_BLUE+COLOR_WHITE, texture);
}

