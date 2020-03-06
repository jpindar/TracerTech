/*
* launch controller header
* copyright Tracer Prometheus / Tracer Ping 2018
* tracerping@gmail.com
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
* rezzes and launches projectile from its inventory
*
*/
#define PREFIX " "
#define DESCRIPTION "plain spikestar"
#define DEBUGLEVEL 1
//#define TRACERGRID
#define HYPERGRID

#define LAUNCHALPHA 1
#define LAUNCHDELAY 0
#define BALLS 1
#define SMOKE 1
//#define NOFLASH
//#define MIRROR

//#define STATIC
//#define REZPOSABS <150,150,100>
//#define REZPOSREL <0,0,50>
//#define LAUNCH_ROT_ABSOLUTE <0,0,0>
#define LAUNCH_ROT_RELATIVE <0,0,0>

//#define MULTIBURST

//#define MODEANGLE
#define STARTANGLE 0
#define ENDANGLE PI
#define PARTOMEGA <0.0,0.0,0.0>
#define PARTACCEL <0.0,0.0,0.0>

#define MINPARTSPEED 1.0
#define MAXPARTSPEED 1.0

#define BURSTRADIUS 10
#define BURSTRATE 0.2
#define PARTCOUNT 200
#define PARTAGE 2.0
#define SYSTEMAGE 2.0

#define STARTSCALE <1.0,1.0,0.0>
#define ENDSCALE   <1.0,1.0,0.0>
#define STARTGLOW  0.1
#define ENDGLOW    0.1
#define STARTALPHA 1.0
#define ENDALPHA   1.0

#define FOLLOWVELOCITY
//#define NO_FOLLOW_VELOCITY  
//#define WIND

//#define TEXTURE1 TEXTURE_NAUTICAL_STAR
//#define TEXTURE1 TEXTURE_PATRIOTIC_STAR
//#define TEXTURE1 TEXTURE_RAINBOWBURST
//#define TEXTURE1 TEXTURE_CLASSIC
#define TEXTURE1 TEXTURE_SPIKESTAR

#define LAUNCHSOUND SOUND_WHOOSH001
//#define LAUNCHSOUND SOUND_CHEE
//#define LAUNCHSOUND SOUND_LAUNCH2

//#define BOOMSOUND SOUND_PUREBOOM
#define BOOMSOUND SOUND_BANG1

#include "FIREWORKS\PHYSICAL\launcher.lsl"

