/*
* launch controller header
* copyright Tracer Prometheus / Tracer Ping 2018
* tracerping@gmail.com
*
* reads data from notecard and forwards it via linkmessage
* listens for commands on either a chat channel or a link message
*
*rezzes and launches projectile from its inventory
*
*
*/
//#define DEBUG
#define TRACERGRID
#define DESCRIPTION "plain spikestar"
#define LAUNCHALPHA 1
#define BURSTRADIUS 0
#define PARTCOUNT 200
#define BURSTRATE 0.1
#define PARTAGE 1.0
#define SYSTEMAGE 0.9

#define STARTGLOW 0.2
#define ENDGLOW 0.1
#define STARTALPHA 1.0
#define ENDALPHA 1.0
#define STARTSCALE <1.0,1.0,0.0>
#define ENDSCALE <1.0,1.0,0.0>

//#define TEXTURE1 TEXTURE_NAUTICAL_STAR
//#define TEXTURE1 TEXTURE_RAINBOWBURST
//#define TEXTURE1 TEXTURE_CLASSIC
#define TEXTURE1 TEXTURE_SPIKESTAR

//#define BOOMSOUND SOUND_PUREBOOM
//#define BOOMSOUND SOUND_CLANGECHO
#define BOOMSOUND SOUND_BANG1

//#define LAUNCHSOUND SOUND_WHOOSH001
#define LAUNCHSOUND SOUND_CHEE


#include "FIREWORKS\PHYSICAL\launcher.lsl"





