/*

tickertape 0.1
copyright Tracer Ping 9/8/2018

*/

#define DEBUG
#define TRACERGRID
#include "lib.lsl"

string text = "ABC";
integer targetLinear = FALSE;
integer targetPos = TRUE;
string target = "ee6dd6e4-1281-42d3-8baf-42c1e79995d2";
//TODO get this key from the target automatically
integer boldface = TRUE;

float interval = 2.4;
integer on = TRUE;
string currenttext = "";
integer handle;

list characters = [
   TEXTURE_COURIER_NEW_SPACE,

   TEXTURE_COURIER_NEW_A,
   TEXTURE_COURIER_NEW_B,
   TEXTURE_COURIER_NEW_C
];

list boldCharacters = [
   TEXTURE_COURIER_NEW_SPACE,

   TEXTURE_COURIER_NEW_BOLD_A,
   TEXTURE_COURIER_NEW_BOLD_B,
   TEXTURE_COURIER_NEW_BOLD_C
];

string chars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ .?;!,:0123456789@";

makeParticles(string texture)
{
   integer flags = 0
   | PSYS_PART_EMISSIVE_MASK
   | PSYS_PART_INTERP_COLOR_MASK
   | PSYS_PART_INTERP_SCALE_MASK;
   if (targetLinear) flags = flags | PSYS_PART_TARGET_LINEAR_MASK;
   if (targetPos) flags = flags | PSYS_PART_TARGET_POS_MASK;
   llParticleSystem([
      PSYS_SRC_TARGET_KEY, target,
      PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,
      PSYS_SRC_TEXTURE, texture,
      PSYS_PART_START_SCALE,<2.0, 2.0, 0.0>,
      PSYS_PART_END_SCALE,<2.0, 2.0, 0.0>,
      PSYS_PART_START_ALPHA,1.0,
      PSYS_PART_END_ALPHA,1.0,
      PSYS_PART_START_COLOR, <1.0,0.0,0.0>,
      PSYS_PART_END_COLOR, <0.0,0.0,1.0>,
      PSYS_PART_START_GLOW, 0.1,
      PSYS_PART_END_GLOW, 0.1,
      PSYS_PART_MAX_AGE,20.0,
      PSYS_SRC_BURST_RATE,2.2,
      PSYS_SRC_BURST_PART_COUNT,1,
      PSYS_SRC_MAX_AGE,0.0,
      PSYS_SRC_BURST_RADIUS,0.5,
      PSYS_SRC_INNERANGLE,0.0,
      PSYS_SRC_OUTERANGLE,0.0,
      PSYS_SRC_OMEGA,<0.0, 0.0, 0.0>,
      PSYS_SRC_ACCEL, <0,0,0.0>,
      PSYS_SRC_BURST_SPEED_MIN,0.25,
      PSYS_SRC_BURST_SPEED_MAX,0.25,
      PSYS_PART_FLAGS, flags
      ]);
}

allOff()
{
   llParticleSystem([]);
}

default
{
   state_entry()
   {
      if(on)
      {
         llSetTimerEvent(interval);
         handle = llListen(99, "", llGetOwner(), "");
      }
   }

   touch_start(integer num_detected)
   {
      if(on)
      {
         llSetTimerEvent(0.0);
         //llListenControl(handle, FALSE);
      }
      else
      {
         //handle = llListen(99, "", llGetOwner(), "");
         llSetTimerEvent(interval);
      }
      on = !on;
   }

   listen( integer channel, string name, key id, string message)
   {
      text = message;
      currenttext = message;
      llOwnerSay("Setting text:" + message);
   }

   timer()
   {
      string texture; 
      if(currenttext == "")
      {
         currenttext = text;
      }
      
      string c = llGetSubString(currenttext, 0, 0);
      if (boldface)
         texture = llList2Key(boldCharacters, llSubStringIndex(chars, llToUpper(c)));
      else
         texture = llList2Key(characters, llSubStringIndex(chars, llToUpper(c)));
      
      makeParticles(texture);

      if(llStringLength(currenttext) == 1)
      {
         if(currenttext != " ")
         {
            currenttext = " ";
         }
         else
         {
            currenttext = "";
         }
      }
      else
      {
         currenttext = llGetSubString(currenttext, 1, -1);
      }
   }
}


