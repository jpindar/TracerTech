string menutext="\nChoose One:";
list buttonsOwner=["channel","reset","foo","owner","group","public", "fire","hide","show"];
list buttonsAll=["channel","reset","foo", "fire","hide","show"];
key owner;
key toucher;
integer handle;
integer handle2;
string group;
integer menuChan;
integer newChan = 42;
integer chatChan;
integer PUBLIC = 0;
integer GROUP = 1;
integer OWNER = 2;
integer access;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        chatChan = (integer)llList2String(llGetLinkPrimitiveParams(LINK_ROOT,[PRIM_DESC ]), 0);
        menuChan = (integer)(llFrand(-1000000000.0) - 1000000000.0); //we generate random channel...
        owner=llGetOwner();
        access = PUBLIC;
    }

    touch_start(integer num)
    {
        toucher=llDetectedKey(0);
        handle=llListen(menuChan,"",toucher,"");
        if (toucher == owner)
        {
            llDialog(toucher,menutext,buttonsOwner,menuChan);
        }
        else if ((access == GROUP) && (llDetectedGroup(1)))
        {
            llDialog(toucher,menutext,buttonsAll,menuChan);
        }
        else if ((access == PUBLIC)) 
        {
            llDialog(toucher,menutext,buttonsAll,menuChan);
         }
    }
    
    listen(integer channel,string name,key id,string msg)
    {
        if (toucher == owner)
        {
             if(msg == "all")
             {
                 access = PUBLIC;
                 sendMsg("ALL");
             }
             else if(msg == "group")
             {
                 access = GROUP;
                 sendMsg("GROUP");
             }
             else if(msg == "owner")
             {
                 access = OWNER;
                 sendMsg("OWNER");
             }
        }    
        if(msg=="Cancel")
        {
            llListenRemove(handle);
        }
        else if(msg=="reset")
        {
            sendMsg("reset");
            llResetScript();
        }

        else if(msg=="show")
        {
           sendMsg("show");
        }
        else if(msg=="hide")
        {
           sendMsg("hide");
        }
        else if(msg=="fire")
        {
            llSay(DEBUG_CHANNEL,"firing");
            sendMsg("fire");
        }
        else if (msg=="channel")
        {
             state changeChannel;
        }
        else
        {
           llListenRemove(handle);
        }
    }
}

state changeChannel
{
     state_entry()
    {
         llTextBox(toucher,"enter  new channel",menuChan+1);
         handle2=llListen(menuChan+1,"",toucher,"");
         llSetTimerEvent(10);
    }
    
    listen(integer channel,string name,key toucher,string msg)
    { 
        {
            newChan = (integer)msg;
            msg = "set channel " + (string)newChan;
            sendMsg(msg);
            chatChan = newChan;
            state default;
        }
    }   
      
   timer()
   {
       state default;
   }
}

sendMsg(string msg)
{
   llSay(chatChan,msg);  
   llMessageLinked(LINK_SET, 0, msg, "");   
}