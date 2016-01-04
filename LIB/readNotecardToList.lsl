// needs:
//string notecardName;
//integer notecardLineIndex;
//Query1;
//boolean done;
//list notecardList

state readNotecardToList
{
    state_entry()
    {
        notecardName = getNotecardName("config");
        if (notecardName == "")
        {
           doneReadingNotecard = TRUE;
           state default;
        }
        notecardLineIndex = 0;
        Query1 = llGetNotecardLine(notecardName, notecardLineIndex++); 
        llOwnerSay("loading notecard...");
    }

    dataserver(key query_id, string data)
    {
        if ((Query1 == query_id) && (data != EOF))
        {
            if ((llSubStringIndex(data,"//") == -1) && (data != ""))
            {
               notecardList = notecardList + llCSV2List(data);
            }
            Query1 = llGetNotecardLine(notecardName, notecardLineIndex++);
        }
        if (data == EOF)
        {
            doneReadingNotecard = TRUE;
            //debugSay(llList2CSV(notecardList));
            llMessageLinked(LINK_SET, RETURNING_NOTECARD_DATA, llList2CSV(notecardList),""); 
            llOwnerSay("...done");
            state default;
        }
    }
}



