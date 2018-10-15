
/*
readNotecardToList.h

include this before you include readNotecardToList.lsl

The only reason this exists is that you apparently can't declare/define variables in
a state (but outside of any events/functions)

*/


/* these are parameters */
integer doneReadingNotecard = FALSE; // boolean
list notecardList;  // this is the 'return value' from getNotecardName.lsl

/* these would be local to the state if that were possible */
string notecardName;
integer notecardLineIndex;
key Query1;
