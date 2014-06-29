/////////////////////
// Tracer Tech rocket launcher
//////////////////////

integer debug = TRUE;
key soundKey = "0718a9e6-4632-48f2-af66-664196d7597d";
//key soundKey = "29bb5045-1bae-4402-bd0e-1df86a5a2bef"; //3sec crackle
//sparkballs are 20 speed, 1 param
float speed = 15;  //8 to 25
integer payloadParam = 3;//1 to 10 typ 1 to 3
integer payloadIndex = 0;
integer payloadParam2 = 0;
float heightOffset = 0.6;
float glowOnAmount = 0.0; //or 0.05
integer chan;
integer handle;
key id = "";
integer preloadFace = 2;

#include "lib.lsl"

fire()
{
    string rocket;
    integer soundChan = 556;

    //llPlaySound(soundKey,1);
    llTriggerSound(soundKey,1);
    llRegionSay(soundChan, soundKey);
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    integer i;
    rotation rot = llGetRot();
    vector pos = llGetPos()+ (<0.0,0.0,heightOffset> * rot);
    vector vel = <0,0,speed> * rot;
    for (i = 0; i< n; i++)
    {
        rocket = llGetInventoryName(INVENTORY_OBJECT,i);
        llRezAtRoot(rocket,pos,vel, rot, payloadParam + (payloadParam2*256));
    }
}

default
{
   on_rez(integer n){llResetScript();}
   changed(integer change){if(change & CHANGED_OWNER) llResetScript();}

   state_entry()
   {
      //llSetTexture(textureKey,preloadFace);
      //id = llGetOwner();
      chan = objectDescToInt();
      handle = llListen( chan, "",id, "" );
      llOwnerSay("listening on channel "+(string)chan);
   }

    touch_start(integer total_number)
    {
      //  fire();
    }

    link_message(integer sender, integer num, string str, key id)
    {
       msgHandler(str); 
    }
    
    listen( integer chan, string name, key id, string msg )
    {
       msgHandler(msg);
    }
}


msgHandler(string msg)
{
      if ( msg == "fire" )
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetAlpha(0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if ( msg == "show" )
      {
         llSetAlpha(1.0, ALL_SIDES);
         //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         if ((chan = ((integer)llDeleteSubString(msg, 0, 11))) < 0)
            chan = 0;
         llSetObjectDesc((string)chan);
         llResetScript();
      }
}


