/*
* dance bracelet v1.0
*Tracer Ping July 2016
*/
#define DEBUG
#define TRACERGRID
#include "lib.lsl"

string color1 = COLOR_GOLD;
string color2 = COLOR_RED;
string primColor = COLOR_GOLD;
string texture = TEXTURE_SPIKESTAR;
integer on = TRUE;
float glowAmount = 0.1;
float systemAge = 0;
float alpha = 1.0;
integer numOfEmitters = 1;
list colors = [COLOR_GOLD,COLOR_ORANGE,COLOR_RED];
list emitters;

#include "effects\effect_small_starburst.lsl"


sendMsg(integer cmd, string msg)
{
   #if defined REMOTE_MENU
      llSay(chatChan,msg);
   #endif
   #if defined LINKED
      llMessageLinked(LINK_THIS, cmd, msg, "");
   #else
      llMessageLinked(LINK_SET, cmd, msg, "");
   #endif
   //llMessageLinked(LINK_SET, 0, msg, "");
   //llMessageLinked(LINK_SET, 0, msg, "");
    debugSay("sent on/off linkmessage");
}

fire()
{
   setGlow(LINK_THIS,glowAmount);
   makeParticles(LINK_THIS,color1,color2);
}


default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_INVENTORY) llResetScript();}

   state_entry()
   {
      on = FALSE;
      llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
      llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0]);
      llParticleSystem([]);
      // if(doneReadingNotecard == FALSE) state readNotecardToList;
   }

   touch_start(integer n)
   {
      on = !on;
      if (on)
      {
         sendMsg(ON_CMD,"");
      }
      else
      {
        sendMsg(OFF_CMD,"");
      }
   }

   link_message( integer sender, integer num, string msg, key id )
   {
      debugSay("got linkmessage");
      if (num & RETURNING_NOTECARD_DATA)
      {
          debugSay("read notecard");
          debugSay(msg);
          list note = llCSV2List(msg);
          alpha = getFloat(note,"alpha");
          glowAmount = getFloat(note,"glow");
          primColor = parseColor(note,"primColor");
          color1 = parseColor(note,"color1");
          colors = [color1];
          color2 = parseColor(note,"color2");
          colors += color2;
          setParamsFast(LINK_SET,[PRIM_COLOR,ALL_SIDES,(vector)primColor,alpha]);
      }

      if ( num & ON_CMD ) //to allow for packing more data into num
      {
           debugSay("got 'on' message");
           llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
           llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, glowAmount]);
           fire();
      }
       else if ( num & OFF_CMD )
       {
            debugSay("got 'off' message");
            llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,0]);
            llParticleSystem([]);
       }
    }
}

//this has to be after the default state
//#include "readNotecardToList.lsl"

