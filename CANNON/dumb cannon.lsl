/////////////////////
// Tracer Tech rocket launcher
//////////////////////

/////////////////////
#include "lib.lsl"
integer debug = TRUE;
string rocket;
key soundKey = "0718a9e6-4632-48f2-af66-664196d7597d";
//key burstTexture = "5ae147e5-081f-40fb-8d49-1da4e88d45bf";
key burstTexture = "bda1445f-0e59-4328-901b-a6335932179b";
key payload = "0e86ed9c-eaf9-4f75-8b6f-1956cb5d6436";
float speed = 30;  //8 to 20
integer rocketParam = 1;//1 to 10
vector pos;
vector vel;
rotation rot;
string preloadPrimName = "preloader";
integer preloadFace = 2;
//469014d2-c9f9-4908-bbfd-f73ab3eee343
integer chan = UNKNOWN;
float volume = 1.0;

default
{

    state_entry()
    {
        //llSetLinkTexture(getLinkWithName(preloadPrimName),texture,preloadFace);
        // llSetTexture(burstTexture, 2);
        if(doneReadingNotecard == FALSE) state readNotecardToList;
        chan = getChatChan();
        volume =  getVolume();
        
        llOwnerSay((string)chan);
        llOwnerSay((string)volume);
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,chan,"fire","");
        llOwnerSay("touched");
    }

    link_message(integer sender, integer channel, string message, key id)
    {
       // if(channel==chan && message=="fire")
        {
            llPlaySound(soundKey,volume);
            //llSetTimerEvent(10);
            rocket = llGetInventoryName(INVENTORY_OBJECT,0);
            //rocket = payload;
            pos = llGetPos();
            rot = llGetRot();
            vector offset = llRot2Up(rot);
            pos = pos + offset;
            vel = <0,0,speed>*rot;
            llRezObject(rocket,pos,vel,rot, rocketParam);
        }

    }

    timer()
    {
        //llMessageLinked(LINK_SET,(integer)llGetObjectDesc(),"fireworkreload","");
        llSetTimerEvent(0);
    }
}

//alas, this has to be after the default state
#include "readNotecardToList.lsl"


