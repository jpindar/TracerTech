// osSetWindParam() sample
// Touch this object to change the current wind parameters
// Run osGetWindParam() sample to check if these values are applied
 
float newStrength;
float newAvgStrength = 15.0;
float newAvgDirection = 10.0;
float newVarStrength = 7.0;
float newVarDirection = -30.0;
float newRateChange = 8.0;
integer on = FALSE;
 
default
{
    touch_start(integer number)
    {
        string activePluginName = osWindActiveModelPluginName();
        if(activePluginName == "SimpleRandomWind")
        {
            on =  !on;
            llOwnerSay("[SimpleRandomWind]");
            if (on)
                newStrength = newAvgStrength;
            else
                newStrength = 0.0;
            osSetWindParam("SimpleRandomWind", "strength", newStrength);

            llOwnerSay("changing wind strength to " + (string)newStrength);
            float s = osGetWindParam("SimpleRandomWind", "strength");
            llOwnerSay("wind strength is " + string(s));
        }
        else if(activePluginName == "ConfigurableWind")
        {
            llSay(0, "[ConfigurableWind]");
            osSetWindParam("ConfigurableWind", "avgStrength", newAvgStrength);
            llSay(0, "average wind strength(avg_strength) is changed to " + (string)newAvgStrength);
            osSetWindParam("ConfigurableWind", "avgDirection", newAvgDirection);
            llSay(0, "average wind direction in degrees(avg_direction) is changed to " + (string)newAvgDirection);
            osSetWindParam("ConfigurableWind", "varStrength", newVarStrength);
            llSay(0, "allowable variance in wind strength(var_strength) is changed to " + (string)newVarStrength);
            osSetWindParam("ConfigurableWind", "varDirection", newVarDirection);
            llSay(0, "allowable variance in wind direction in +/- degrees(var_direction) is changed to " + (string)newVarDirection);
            osSetWindParam("ConfigurableWind", "rateChange", newRateChange);
            llSay(0, "rate of change(rate_change) is changed to " + (string)newRateChange);
        }            
    }
}