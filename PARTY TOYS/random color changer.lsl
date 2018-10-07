vector c;
float base_delay = 1.0;
float variable_delay = 1.5;

default
{
    state_entry()
    {
             llSetTimerEvent(llFrand(variable_delay) + base_delay);
        }
    }

    timer()
    {
        float x = llFrand(1.0);
        float y = llFrand(1.0);
        float z = llFrand(1.0);
        llSetColor(<x,y,z>,ALL_SIDES);
        //llSetTimerEvent(llFrand(variable_delay) + base_delay);
    }
}

