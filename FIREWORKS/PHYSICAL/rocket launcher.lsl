/////////////////////
// Tracer Tech rocket launcher
// listens for commands on either a chat channel
// or a link message
//////////////////////
integer debug = TRUE;
key sound = "0718a9e6-4632-48f2-af66-664196d7597d";
float speed = 15;  //8 to 25
integer payloadParam = 3;//typically time before explosion, typically  1 to 10 
integer payloadIndex = 0; 
integer payloadParam2 = 0;// for future expansion - a color index perhaps?
float heightOffset = 0.6;
float glowOnAmount = 0.0; //or 0.05
integer chatChan;
integer handle;
integer access;
key owner = "";
integer preloadFace = 2;

#include "lib.lsl"

fire()
{
    string rocket;
    integer i;

    //llPlaySound(sound,1);
    llTriggerSound(sound,1);
    repeatSound(sound);
    integer n = llGetInventoryNumber(INVENTORY_OBJECT);
    rotation rot = llGetRot();
    vector pos = llGetPos()+ (<0.0,0.0,heightOffset> * rot);
    vector vel = <0,0,speed> * rot;
    for (i = 0; i<n; i++)
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
      //llSetTexture(texture,preloadFace);
      owner = llGetOwner();
      chatChan = objectDescToInt();
      handle = llListen( chatChan, "","", "" );
      llOwnerSay("listening on channel "+(string)chatChan);
   }

    touch_start(integer n)
    {
      //  fire();
    }

    link_message(integer sender, integer num, string str, key id)
    {
       msgHandler(owner, str); 
    }
    
    listen( integer chan, string name, key id, string msg )
    {
       msgHandler(id, msg);
    }
}


msgHandler(string sender, string msg)
{
      if ((access == OWNER) && (!(sender == owner)))
          return;
      if ((access == GROUP) && (!llDetectedGroup(0)))
         return;
		 
      if ( msg == "fire" )
      {
         fire();
      }
      else if ( msg == "hide")
      {
          llSetLinkAlpha(LINK_SET,0.0, ALL_SIDES);
          //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
      }
      else if ( msg == "show" )
      {
         llSetLinkAlpha(LINK_SET,1.0, ALL_SIDES);
         //llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, glowOnAmount]);
      }
      else if (llToLower(llGetSubString(msg, 0, 10)) == "set channel")
      {
         chatChan = ((integer)llDeleteSubString(msg, 0, llStringLength("set channel")));
         llSetObjectDesc((string)chatChan);
         llResetScript();
      }
}


