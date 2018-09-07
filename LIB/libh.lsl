
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
#define FIRE_CMD2 64
#define FIRE_CMD3 128
#define ON_CMD 256
#define OFF_CMD 512

#ifdef INWORLDZ
#define TEXTURE_CLASSIC         "6189b78f-c7e2-4508-9aa2-0881772c7e27" //"classic", also standard fountain texture
#define TEXTURE_SPIKESTAR       "bda1445f-0e59-4328-901b-a6335932179b"
#define TEXTURE_FOXFIRE         "952fc0fe-f879-47bc-8450-bc816f817f10" //uncertain TOS
#define TEXTURE_NAUTICAL_STAR   "f0797071-d608-4606-985d-9bb7f3750256" ///K.O.
#define TEXTURE_BUGS            "5ae147e5-081f-40fb-8d49-1da4e88d45bf"
#define TEXTUREGOLDFIREBALLS1   "65411eda-0414-4302-895a-7bef02a96dd8"
#define TEXTUREGOLDFIREBALLS2   "ef63dd5d-b158-443b-88cf-c6fd79931bb8"
#define TEXTURE_FURBALL         "2ef875c7-6e25-4314-8139-fc888931985c"
#define TEXTURE_SMOKEBALL       "9600c188-86a6-4acd-ab7d-8b68d2577b8f"
#define TEXTURE_SMOKEBALL_LIGHT "5d2dab53-acfa-41d6-8c77-a0cfd688e012"
#define TEXTURE_XMARK           "1e8274d8-2104-4330-9417-b8e3970dadeb"
#define TEXTURE_FOXFIRE2        "db6446f4-df26-41d0-8f73-a536a7f9054e"
#define TEXTURE_SNOWFLAKE1      "02256cd8-bd90-476e-a342-4dc4b685ab84"
#define TEXTURE_SNOWFLAKE2      "d3b61f47-a55c-4b41-9cb3-e5da60993955"
#define TEXTURE_GOLDSTAR1       "ae74cda6-dc88-489a-812a-531548e8e3b5"
#define TEXTURE_BALLOON         "2543c174-b58a-4070-b6c6-5634242de88d"
#define TEXTURE_1               "06f1b652-1a63-4c07-9baf-ebcf4d386e7c"
#define TEXTURE_SPOTLIGHT       "575cd7a8-1732-4b06-9d3a-067232be49db"
#define TEXTURE_XSTAR           "1e52ad95-4093-42db-ab17-e92cd18ad461"
#define TEXTURE_RAINBOWBURST    "c24aad31-0a35-45ce-82d3-72eceb6216ec"
#define TEXTURE_FIREBALL_CRAZY  "db6446f4-df26-41d0-8f73-a536a7f9054e"

#define TEXTURE_LIGHTNING1 "86c062bf-9929-47a5-8c46-7f86c1961676"
#define TEXTURE_LIGHTNING2 "56186985-f1ab-4637-b396-5c941979bb4d"
#define TEXTURE_LIGHTNING3 "202a0b4f-5123-4888-9ff6-c6bc320032ae"
#define TEXTURE_LIGHTNING4 "c834d59c-456f-4882-931f-b5320ff35337"
#define TEXTURE_LIGHTNING5 "00faa9d7-bcb6-46b9-958a-4e79fa2e454c"
#define TEXTURE_LIGHTNING6 "659d59ef-ff01-4582-8908-7e63bd33e763"
//"ffe22c5d-0712-42d6-97a3-4cdfc35614a2"
//"e5bc2d4e-a5a1-d075-c29a-60da0d43f448"
// "f0797071-d608-4606-985d-9bb7f3750256"
 //39579f43-e6ff-4711-af68-925b737abc0d
#elif defined TRACERGRID
#define TEXTURE_CLASSIC   "bdd0d47f-e6b2-4971-9eae-e167def7c2ef"
#define TEXTURE_SPIKESTAR "24acad78-2cba-4306-a45c-5702b64ac647"
#define TEXTURE_BLANK     "2e3e01f7-2d09-43f3-9eb5-8155efb327f4"
#elif defined SOAS
#define TEXTURE_CLASSIC   "e51dfec9-b481-4ea0-aa67-545632d0b3fd"
#define TEXTURE_SPIKESTAR "9fe0e79b-f810-481a-9b6f-6a6931ed50ca"
#endif


//these colors must be strings in this exact format
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
#define COLOR_BLUEPURPLE "<0.7,0.00,1.00>"
#define COLOR_LIGHTBLUE "<0.30,0.40,1.00>"

//string color = "<0.42,0.017,0.59>";
#ifdef INWORLDZ

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
#define SOUND_TREX_ROAR "a28830df-7eec-4bb9-9356-f2950346e765"
#define SOUND_SPARKLE1_5S "61318170-fa9f-45c7-a92c-8714872ee496"
//string sound2 ="ef63dd5d-b158-443b-88cf-c6fd79931bb8";
//#define SOUND_WHOOSH001 "fe1a112d-edbc-47f8-8885-087a12d1bafb"
#define SOUND_WHOOSH001 "cbe0f64f-fb02-4aaa-8b8d-8dd729d3cda0"
#define SOUND_BOOM001 "e53efc67-f50d-4ec5-809b-d13d487e9666"  //metallic boom/gong sound

#elif defined TRACERGRID
   #define SOUND_WHOOSH001 "a120d4b5-e56c-4f28-ac02-f606862d269e"
   #define SOUND_PUREBOOM  "8dac6ea6-380f-4d5e-81d7-fbf6a7ad936e"
#elif defined SOAS
   #define SOUND_WHOOSH001 "3a3882d0-d8a6-4e03-b440-be31c37c805d"
   #define SOUND_PUREBOOM  "bbfcb1bf-93b2-4071-832e-89492dd04d68"
#endif


#define DEBUG_MASK     0x01000000
#define COLLISION_MASK 0x02000000
#define FREEZE_MASK    0x04000000
#define WIND_MASK      0x08000000
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
float partSpeed1 = 1.0;
float partSpeed2 = 1.0;
integer menuMode = 0;
integer wind;
#endif


