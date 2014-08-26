/////////////////////
// Tracer Tech rocket launcher
//////////////////////

/////////////////////
integer debug = TRUE;
string rocket;
key soundKey = "0718a9e6-4632-48f2-af66-664196d7597d";
//key burstTexture = "5ae147e5-081f-40fb-8d49-1da4e88d45bf";
key burstTexture = "bda1445f-0e59-4328-901b-a6335932179b";
key payload = "0e86ed9c-eaf9-4f75-8b6f-1956cb5d6436";
float speed =10;  //8 to 20
integer rocketParam = 1;//1 to 10
vector pos;
vector vel;
//469014d2-c9f9-4908-bbfd-f73ab3eee343
default
{

    state_entry()
    {
       // llSetTexture(burstTexture, 2);
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,(integer)llGetObjectDesc(),"fire","");
    }

    link_message(integer sender, integer channel, string message, key id)
    {
        if(channel==(integer)llGetObjectDesc()&&message=="fire")
        {
            llPlaySound(soundKey,1);
            //llSetTimerEvent(10);
            rocket = llGetInventoryName(INVENTORY_OBJECT,0);
            //rocket = payload;
            pos = llGetPos();
            vector offset = llRot2Up(llGetRot());
            pos = pos + offset;
            vel = <0,0,speed>*llGetRot();
            llRezObject(rocket,pos,vel,llGetRot(), rocketParam);
        }

    }

    timer()
    {
        //llMessageLinked(LINK_SET,(integer)llGetObjectDesc(),"fireworkreload","");
        llSetTimerEvent(0);
    }
}




