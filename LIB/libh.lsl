
#ifndef LIB_H
   #define LIB_H

#define UNKNOWN -9999
#define setParamsFast llSetLinkPrimitiveParamsFast

#define MY_DEBUG_CHAN 557
#define SOUND_REPEAT_CHAN 556
#define CNTL_CHAN 558

#define ACCESS_PUBLIC 1
#define ACCESS_GROUP 2
//#define ACCESS_GROUP_ONLY 4
#define ACCESS_OWNER 3

#define FIRE_CMD 1
#define PRELOAD_TEXTURE_CMD 2
#define READ_NOTECARD_CMD 4
#define RETURNING_NOTECARD_DATA 8
#define SET_CHATCHAN_CMD 16
#define MAINMENU_CMD 32

#define TEXTURE_CLASSIC "6189b78f-c7e2-4508-9aa2-0881772c7e27" //"classic", also standard fountain texture
#define TEXTURE_SPIKESTAR "bda1445f-0e59-4328-901b-a6335932179b"
#define TEXTURE_FOXFIRE "952fc0fe-f879-47bc-8450-bc816f817f10" //uncertain TOS
#define TEXTURE_NAUTICAL_STAR  "f0797071-d608-4606-985d-9bb7f3750256" ///K.O.
#define TEXTURE_BUGS "5ae147e5-081f-40fb-8d49-1da4e88d45bf"
#define TEXTUREGOLDFIREBALLS1 "65411eda-0414-4302-895a-7bef02a96dd8"
#define TEXTUREGOLDFIREBALLS2 "ef63dd5d-b158-443b-88cf-c6fd79931bb8"
#define TEXTURE_FURBALL "2ef875c7-6e25-4314-8139-fc888931985c"
#define TEXTURE_SMOKEBALL "9600c188-86a6-4acd-ab7d-8b68d2577b8f"
#define TEXTURE_SMOKEBALL_LIGHT "5d2dab53-acfa-41d6-8c77-a0cfd688e012"
#define TEXTURE_XMARK "1e8274d8-2104-4330-9417-b8e3970dadeb"
#define TEXTURE_FOXFIRE2 "db6446f4-df26-41d0-8f73-a536a7f9054e"
#define TEXTURE_SNOWFLAKE1 "02256cd8-bd90-476e-a342-4dc4b685ab84"
#define TEXTURE_SNOWFLAKE2 "d3b61f47-a55c-4b41-9cb3-e5da60993955"
#define TEXTURE_GOLDSTAR1 "ae74cda6-dc88-489a-812a-531548e8e3b5"



//"e5bc2d4e-a5a1-d075-c29a-60da0d43f448"
// "f0797071-d608-4606-985d-9bb7f3750256"
 //39579f43-e6ff-4711-af68-925b737abc0d

//these colors must be strings in thi exact format 
//because I don't want to bother writing a message parser
#define COLOR_WHITE "<1.00,1.00,1.00>"
#define COLOR_BLACK "<0.00,0.00,0.00>"
#define COLOR_RED "<1.00,0.00,0.00>"
#define COLOR_GREEN "<0.00,1.00,0.00>"
#define COLOR_BLUE "<0.00,0.00,1.00>"
#define COLOR_GOLD "<1.00,0.80,0.20>"
#define COLOR_YELLOW "<1.00,1.00,0.00>"
#define COLOR_ORANGE "<1.00,0.50,0.00>"
#define COLOR_PURPLE "<1.00,0.00,1.00>"
#define COLOR_3 "<0.00,0.80,0.20>"
#define COLOR_HOTPINK "<1.0,0.3,0.5>"

//string color = "<0.42,0.017,0.59>";

#define SOUND_ROCKETLAUNCH1 "0718a9e6-4632-48f2-af66-664196d7597d"
#define SOUND_FOUNTAIN1 "1339a082-66bb-4d4b-965a-c3f13da18492"
#define SOUND_CLICK1 "0f76aca8-101c-48db-998c-6018faf14b62"
#define SOUND_BURST1 "a2b1025e-1c8a-4dfb-8868-c14a8bed8116"
#define SOUND_PUREBOOM "6a9751cf-3170-4de4-b629-2453593dc751"
#define SOUND_2 "ef63dd5d-b158-443b-88cf-c6fd79931bb8"
#define SOUND_CRACKLE1 "ad1cb1d3-1805-4d93-b4db-47be024a99ed"
#define SOUND_CRACKLE2 "29bb5045-1bae-4402-bd0e-1df86a5a2bef"
#define SOUND_RUMBLE "58edd7a4-be95-4282-a964-549eee8caf75"
#define SOUND_WHOOSH "aa1f3484-446a-4bbb-b147-03c6e5bd8ff4"

//string sound2 ="ef63dd5d-b158-443b-88cf-c6fd79931bb8";

#define DEBUG_MASK     0x01000000
#define COLLISION_MASK 0x02000000
// global variables
integer debug = FALSE;
float volume = 1.0;  // 0.0 = silent to 1.0 = full volume
float systemSafeSet = 0.00;//prevents erroneous particle emissions
key Query1;
string notecardName;
list notecardList;
integer notecardLineIndex;
integer doneReadingNotecard = FALSE;
list linknumberList;
#endif


