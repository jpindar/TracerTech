/*
* launch controller
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
#define STARTGLOW 0.2
#define ENDGLOW 0.1
#define BURSTRADIUS 10
#define LAUNCHALPHA 1
#define PARTAGE 2.0
#define SYSTEMAGE 1.0
//#define PARTICLE_SCALE 5
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





