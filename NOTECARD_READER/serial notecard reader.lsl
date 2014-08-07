string notecardName = "TEST";  //can be a UUID
integer index;
key MyQuery1;
string myData;
list newList; 
 
default
{
    state_entry()
    {
        notecardName = getNotecardName();
    }

    touch_start(integer total_number)
    {
        index = 0;
        MyQuery1 = llGetNotecardLine(notecardName, index);
    }
    
    dataserver(key query_id, string data)
    {
        if ((MyQuery1 == query_id) && (data != EOF) && (data != ""))
        {
                process(index, data);
                MyQuery1 = llGetNotecardLine(notecardName, ++index);
        }
    }
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