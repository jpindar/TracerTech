string notecardName = "TEST";  //can be a UUID
integer index;
key MyQuery1;
key MyQuery2;
string myData;
 
default
{
    state_entry()
    {
        notecardName = llGetInventoryName(INVENTORY_NOTECARD,0);
        if (llGetInventoryKey(notecardName) == NULL_KEY)
        {
            llOwnerSay("no notecard found");
            return;
        }
        MyQuery1 = llGetNotecardLine(notecardName, index);
    }

    dataserver(key query_id, string data)
    {
        if ((MyQuery1 == query_id) && (data != EOF))
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

  llSay(0, "Line " + (string) index + " " + line);
  i = llSubStringIndex(line, target);  
  data1 = llGetSubString(line,0,i-1);
  data2 = llGetSubString(line,i+1, llStringLength(line));
  llSay(0, "<" + data1 + "><" + data2+ ">");
}