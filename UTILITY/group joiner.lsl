// Group Joiner (Free)
// Ver 1.0;
// Steelman Enterprises Inc.

// In the General tab, just below Owner, set the Group to the desired target group
// Then click another box, any will do, and take the prim into Inventory.
// On re-rezzing it will initialise and be ready for use.

string gGroupName = "TracerTech group";

list group_key;

default
{
    state_entry()
    {
        group_key = llGetObjectDetails(llGetKey(),[OBJECT_GROUP]);
        llSetText("Touch me to join the " + gGroupName,<0,1,0>,1.0);
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        llInstantMessage(llDetectedKey(0),"Go to your chat and click the next line to get to the " + gGroupName);
        llInstantMessage(llDetectedKey(0),"Click here: secondlife:///app/group/" + (string)group_key + "/about");
    }
}
