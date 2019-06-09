/*
*fireworks menu v1.3
*copyright Tracer Tech aka Tracer Ping aka Tracer Prometheus 2019
*
*gets notecard data via link message
*responds to touch
*listens only to menu
*
* when touched either sends fire command (via chat or linkmessage, determined at compiletime) or opens a popup menu.
*
* link message listener: if linkmessage parameter num is RETURNING_NOTECARD_DAT
* it parses control channel, menumode, and accessmode from parameter msg
*
* chat listener (listening to the popup menu)
* handles menu button presses by sending a command (fire, show or hide) via chat or
* linkmessage (determined at compiletime)
*
*/
#include "FIREWORKS\PHYSICAL\menu.lsl"

