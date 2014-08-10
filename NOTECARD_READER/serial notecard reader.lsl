string notecardName = "TEST";  //can be a UUID
integer index;
key Query1;
string myData;
list newList; 
integer done = FALSE;
#include "libh.lsl"
#include "lib.lsl" 
 
default
{
    state_entry()
    {
        readNotecard()
    }

    dataserver(key query_id, string data)
    {
        if ((Query1 == query_id) && (data != EOF) && (data != ""))
        {
            process(index, data);
            Query1 = llGetNotecardLine(notecardName, index++);
        }
        if ((data == EOF) || (data == ""))
        {
            done = TRUE;
            //llSay(0,llList2CSV(newList));
            //llMessageLinked(LINK_SET,0,llList2CSV(newList),"");
        }
    }
}

readNotecard()
{
        notecardName = getNotecardName();
        index = 0;
       Query1 = llGetNotecardLine(notecardName, index++);
}

process(integer index, string line)
{
    integer i;
    string target = ":";
    string data1;
    string data2;

    if ((line == EOF)|| (line == ""))
       return;
    llSay(0, "Line " + (string) index + " " + line);
    i = llSubStringIndex(line, target);  
    data1 = llGetSubString(line,0,i-1);
    data2 = llGetSubString(line,i+1, llStringLength(line));
    llSay(0, "<" + data1 + "><" + data2+ ">");
    newList = newList + data1 + data2;
}