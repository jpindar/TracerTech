string menutext="\nChoose One:";
list buttons=["fire","show","hide","channel","reset"];
key owner;
key toucher;
integer handle;
integer handle2;
string group;
integer menuChan = -12972;
integer newChan = 42;
integer chatChan =5004;

default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }

    state_entry()
    {
        owner=llGetOwner();
    }

    touch_start(integer num)
    {
        toucher=llDetectedKey(0);
        handle=llListen(menuChan,"",toucher,"");
        llDialog(toucher,menutext,buttons,menuChan);
    }
    
    listen(integer channel,string name,key id,string msg)
    {
        if(msg=="Cancel")
        {
            llListenRemove(handle);
        }
        else if(msg=="show")
        {
            llSay(chatChan,"show");
         }
        else if(msg=="hide")
        {
            llSay(chatChan,"hide");
        }
        else if(msg=="fire")
       {
            llSay(chatChan,"fire");
       }
       else if(msg=="channel")
       {
            llSay(chatChan, "set channel " + (string)newChan);
       }
        else
        {
       llOwnerSay(msg);
      llListenRemove(handle);
        }
    }
}