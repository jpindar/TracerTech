string owner;
integer total;
string textcolour = "<0,1,0>";
string name1 = "Tracer Tech Fireworks \nTip Jar";
string name2 = "Tracer Tech Fireworks Tip Jar";
string name3 = "TracerTech"

default
{
    on_rez(integer param){llResetScript();}

    state_entry()
    {   //if first param is PAY_HIDE, there is no input box
        llSetPayPrice(PAY_DEFAULT, [PAY_HIDE,PAY_HIDE,PAY_HIDE,PAY_HIDE]);
        owner=llKey2Name(llGetOwner());
        llSetText((name1),(vector)textcolour,1);
        //llSetText((owner +"'s Tip Jar"),(vector)textcolour,1);
    }

    money(key tipper, integer amount)
    {
        llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES,1.0]);
        total += amount;
        string tipname = llKey2Name(tipper);
        llSetText(owner +"'s Tip Jar\n" + (string)amount + "L$ donated last\n" + (string)total + "L$ donated so far!",(vector)textcolour,1);
        //llSetText(name2+"\n" + (string)amount + "L$ donated last\n" + (string)total + "L$ donated so far!",(vector)textcolour,1);
        llInstantMessage(tipper,"Thanks for the tip, " +(string)tipname);
        llInstantMessage(llGetOwner(),(string)tipname+" donated L$" + (string)amount);
        llSetTimerEvent(1.0);
    }

    timer()
    {
        llSetPrimitiveParams([PRIM_GLOW,ALL_SIDES, 0.0]);
    }
}

