//chat analyzer 0.1
//Tracer Ping 2013
integer chan = 111;

default
{ 

   state_entry()
   {
     llListen(chan, "", "", "" );
     llSay(DEBUG_CHANNEL,"listening on channel "+(string)chan);
   }

   listen( integer chan, string name, key id, string msg )
   {
      llSay(DEBUG_CHANNEL, "ch "+(string)chan +" <"+name+"><"+(string)id+"><"+msg+">");
   }


}


