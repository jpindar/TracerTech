//Audio repeater 
//for Tracer Tech 3D Fireworks

integer chan = 556;
integer handle;
integer KEYLENGTH = 36;
default
{
    state_entry()
    {
        handle = llListen( chan, "","", "" );
    }

   listen( integer chan, string name, key id, string msg )
   {
       float vol = 1;
       integer len = llStringLength(msg);
       string sound = llGetSubString(msg,0,KEYLENGTH-1);
       
       if (len>KEYLENGTH)
       {
           vol = (float)llGetSubString(msg,KEYLENGTH+1,len+1);
       }
       llPlaySound(sound,vol);
   }
    
}