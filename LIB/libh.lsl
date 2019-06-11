
#ifndef LIB_H
   #define LIB_H

#if defined TRACERGRID
   #ifndef HYPERGRID
      #define HYPERGRID
   #endif
#endif

#if defined HYPERGRID
   #ifndef TRACERGRID
      #define TRACERGRID
   #endif   
#endif

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
#define CMD_FIRE 1
#define PRELOAD_TEXTURE_CMD 2
#define READ_NOTECARD_CMD 4
#define RETURNING_NOTECARD_DATA 8
#define SET_CHATCHAN_CMD 16
#define MAINMENU_CMD 32
#define FIRE_CMD2 64
#define FIRE_CMD3 128
#define ON_CMD 256
#define CMD_ON 256
#define OFF_CMD 512
#define CMD_OFF 512


#ifdef HYPERGRID

   #define TEXTURE_CLASSIC           "f19d8a42-c2d6-4f44-a31a-abc490b65f8c"
   #define TEXTURE_CLASSIC_THIN          "b3312adb-0fe1-4ef7-a74a-085d0b4d3f22"
   #define TEXTURE_SPIKESTAR         "67b464c2-d8e9-4986-8d14-1681224068eb"
   //#define TEXTURE_CLASSIC         "bdd0d47f-e6b2-4971-9eae-e167def7c2ef"
   //#define TEXTURE_SPIKESTAR       "24acad78-2cba-4306-a45c-5702b64ac647"
   #define TEXTURE_NAUTICAL_STAR     "84003b34-ad78-4c8b-a279-037004b2c8b3"  //GCG OK
   //#define TEXTURE_NAUTICAL_STAR2     "1e83875a-7096-4c68-8003-6612e296ea29" //GCG NG?
   #define TEXTURE_PATRIOTIC_STAR    "d80f20f5-269e-4662-a2e2-b4f7098a81dd"   //GCG OK
   #define TEXTURE_PAWSOME           "36a631d4-e202-4d0a-8b05-6a48fde0d258"
   #define TEXTURE_PAWSOME_CHROME    "23a79d51-75e8-4266-b447-547093c36fd6"
   #define TEXTURE_BLANK             "2e3e01f7-2d09-43f3-9eb5-8155efb327f4"
   #define TEXTURE_FLAMEBALL         "1d747f98-41e2-4bd6-bbd4-9a9f36ef78bb"
   #define TEXTURE_FEATHERS          "467472da-9584-42c4-927e-c06b739b29f4"
   #define TEXTURE_WHIRLBLADES       "7af7b5a8-75b9-4736-b244-bec7be20a106"
   #define TEXTURE_GLOSSY_HEART  "d056a3a7-e456-4ff3-b360-04475fb16200"   // GCG NG?
   #define TEXTURE_GLOSSY_HEARTS "d056a3a7-e456-4ff3-b360-04475fb16200"   // GCG NG?
   #define TEXTURE_ROSE1         "05135c09-e9a5-45da-b00d-19a0c8ef1b71"
   #define TEXTURE_MAPLE_LEAF  "17eca2aa-6616-4dc2-8856-63dd82c14ca5"
   #define TEXTURE_MAPLE_LEAF_SMALL  "18e42515-503c-4d9b-89cc-edf3f38d3604"
   #define TEXTURE_WEED "4160ca88-f7f3-44d1-bfdf-517dfcd690c5"
   #define TEXTURE_ONE_RING "5c924eec-edd6-436b-a097-b27ebbc30a89"
   #define TEXTURE_PAWSOME_WHITE "df12a718-9398-4dda-86a2-a698fc024aaf"
   #define TEXTURE_TORNADO1            "046ed932-2f8b-4f79-9bd5-d25c388e6afd"  //NG in GCG
   #define TEXTURE_COURIER_NEW_A       "5473e212-e7bf-47f7-82d7-ca1c78c5e50c"
   #define TEXTURE_COURIER_NEW_B       "9e9e3c28-10bc-4647-ab5b-6ebe464b4d92"
   #define TEXTURE_COURIER_NEW_C       "0b723437-7157-448c-8d48-d7667a6f45cb"
   #define TEXTURE_COURIER_NEW_SPACE   "b7ea800f-80b5-4882-8a2e-4833752bd9a5"
   #define TEXTURE_COURIER_NEW_BOLD_A  "11d48c16-c02e-4766-9ab2-fc8b39ff1f39"
   #define TEXTURE_COURIER_NEW_BOLD_B  "c290a675-7383-449a-9c77-87a5aed545de"
   #define TEXTURE_COURIER_NEW_BOLD_C  "d3eb6aca-d7d1-46ad-99da-fb2320031a7f"
   #define TEXTURE_TOBETESTED "d8bbe2e6-a679-4a34-9829-e72760e928e4"
   #define TEXTURE_PURPLE_SWIRLY "d5d22584-94a9-4cbe-89e6-a6328ef36197"
   #define TEXTURE_ROSE_STEM "d7669781-4e49-40c2-b60a-841d37b25476"
   #define TEXTURE_HEART2 "5b246c26-3b16-4e22-b1e9-6c57aef64bab"

#elif defined SOAS
   #define TEXTURE_CLASSIC   "e51dfec9-b481-4ea0-aa67-545632d0b3fd"
   #define TEXTURE_SPIKESTAR "9fe0e79b-f810-481a-9b6f-6a6931ed50ca"
#elif defined KITELY
   #define TEXTURE_CLASSIC "663340da-e9b4-41a5-8d89-c5259b72ad8b"
#elif defined AMARYLLIS
   #define TEXTURE_CLASSIC   "9bcfe4c3-0e6a-41ad-b7ca-1a6936dfa6c0"
   #define TEXTURE_SPIKESTAR "3b4d481c-a4a4-4d0c-9875-9a4ed27df9be"
   #define TEXTURE_CLASSIC2  "9e31a480-c4fe-4340-90ae-747abdbee6fc"
   #define TEXTURE_PATRIOTIC_STAR    "20bc5407-8666-4598-829e-3040d6633cea"
#endif


//these colors must be strings in this exact format
//2 decimal places are close enough
#define COLOR_WHITE         "<1.00,1.00,1.00>"
#define COLOR_BLACK         "<0.00,0.00,0.00>"
#define COLOR_RED           "<1.00,0.00,0.00>"
#define COLOR_GREEN         "<0.00,1.00,0.00>"
#define COLOR_BLUE          "<0.00,0.00,1.00>"
#define COLOR_GOLD          "<1.00,0.80,0.20>"
#define COLOR_YELLOW        "<1.00,1.00,0.00>"
#define COLOR_ORANGE        "<1.00,0.50,0.00>"
#define COLOR_PURPLE        "<1.00,0.00,1.00>"
#define COLOR_PURPLE2       "<0.69, 0.05, 0.79>"
#define COLOR_3             "<0.00,0.80,0.20>"
#define COLOR_HOTPINK       "<1.0,0.3,0.5>"
#define COLOR_BLUEPURPLE    "<0.7,0.00,1.00>"
#define COLOR_LIGHTBLUE     "<0.30,0.40,1.00>"
#define COLOR_BRIGHT_BLUE   "<0.3,0.3,1.00>"
//#define COLOR_BLUE_TOO    "<0.00,0.46,0.85>"
#define COLOR_LIGHTGREYBLUE "<0.47,0.68,0.77>"
#define COLOR_TEAL          "<0.22,0.80,0.80>"
#define COLOR_AQUA          "<0.5,0.86,1.00>"  //but cyan == aqua?
#define COLOR_CYAN          "<0.0,1.00,1.00>"
#define COLOR_LIME          "<0.00,1.0,0.44>"
#define COLOR_PRIDE_RED      "<0.906, 0.000, 0.000>"
#define COLOR_PRIDE_ORANGE   "<1.000, 0.549, 0.000>"
#define COLOR_PRIDE_YELLOW   "<1.000, 0.937, 0.000>"
//#define COLOR_PRIDE_GREEN  "<0.000, 0.506, 0.122>" //too dark for fireworks
#define COLOR_PRIDE_GREEN    "<0.000, 0.980, 0.216>" 
//#define COLOR_PRIDE_BLUE   "<0.000, 0.267, 1.000>" //too dark for fireworks
#define COLOR_PRIDE_BLUE     "<0.161, 0.380, 1.000>"
//#define COLOR_PRIDE_PURPLE "<0.463, 0.000, 0.537>" //too dark for fireworks
#define COLOR_PRIDE_PURPLE   "<0.808, 0.000, 0.941>" 

//string color = "<0.42,0.017,0.59>";

#if defined HYPERGRID
   #define SOUND_WHOOSH001  "a120d4b5-e56c-4f28-ac02-f606862d269e"    //GCG OK
   #define SOUND_CHEE       "2494e177-c350-4868-a609-d14a0d9488ea"
   #define SOUND_PUREBOOM   "8dac6ea6-380f-4d5e-81d7-fbf6a7ad936e"    //GCG OK
   #define SOUND_CLANGECHO  "69f401d1-1e61-476b-99b1-dce18531996b"
   #define SOUND_BANG1      "562f55da-414d-4ae7-b89a-7648f17a836f"
   #define SOUND_SILENCE    "806f9a16-5799-43cb-a8e7-4430b44b2d2e" //GCG
   #define SOUND_SILENT     "806f9a16-5799-43cb-a8e7-4430b44b2d2e" // GCG
   #define SOUND_CRACKLE3S  "35eaaf68-23ff-4c6a-bf7f-7c9235d6a661"
   #define SOUND_TRIPPYBOOM "8a7ffb6a-4511-4058-b474-4543bda891b7"
   #define SOUND_SPARKLER_5 "f0b33013-a0d1-465f-8776-2de923152ca4"
   
   
#elif defined SOAS
   #define SOUND_WHOOSH001  "3a3882d0-d8a6-4e03-b440-be31c37c805d"
   #define SOUND_PUREBOOM   "bbfcb1bf-93b2-4071-832e-89492dd04d68"
#elif defined AMARYLLIS
   #define SOUND_PUREBOOM    "520c5354-db61-4ac4-9fe4-2f3753a1735f"
   #define SOUND_WHOOSH001   "48c633b4-91a3-4712-a651-35d52905b1e3"
   #define SOUND_CHEE        "8e98cc7c-85ff-4513-91a1-4b2e5ec85608"
   #define SOUND_BANG1       "41e4d1ab-4261-4651-bd0a-cf9b1a8a9836"
   #define SOUND_SPARKLER_5  "16f68c93-0017-453b-83a3-261a50ca8d10"
   #define SOUND_SILENCE "1b54648f-7f6c-4957-a015-9b3bc3274c35"
#endif

// masks for encoding options into a short message

#define LAUNCH_ALPHA_MASK    0x00800000
#define DEBUG_MASK           0x01000000
#define COLLISION_MASK       0x02000000
#define FREEZE_MASK          0x04000000
#define WIND_MASK            0x08000000
#define LOW_VELOCITY_MASK    0x10000000
#define FOLLOW_VELOCITY_MASK 0x20000000

#define MAX_INT           0x80000000
// this will do for now
#define ERROR_FLAG        -8989

// global variables
integer debug = FALSE;
float volume = 1.0;  // 0.0 = silent to 1.0 = full volume
float systemSafeSet = 0.00;//prevents erroneous particle emissions
list linknumberList;
integer wind;


#endif  /* ifndef LIB_H */

