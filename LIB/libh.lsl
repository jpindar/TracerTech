
#ifndef LIB_H
   #define LIB_H

#if defined OPENSIM
   #ifndef TRACERGRID
      #define TRACERGRID
   #endif
   #ifndef HYPERGRID
      #define HYPERGRID
   #endif
#endif

#define UNKNOWN -9999
#define setParamsFast llSetLinkPrimitiveParamsFast

#define SOUND_REPEAT_CHAN 556
#define MY_DEBUG_CHAN 557
#define SOUND_DEBUG_CHAN 557
#define CNTL_CHAN 558
#define GLOBAL_CHAN 559

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


#ifdef AMARYLLIS
  #define POSITION_FLOOR_CENTER <29.0,185.0,28.5>
#endif

#ifdef HYPERGRID

   #define TEXTURE_CLASSIC           "f19d8a42-c2d6-4f44-a31a-abc490b65f8c"      //DG OK, GCG OK
   #define TEXTURE_CLASSIC_THIN      "b3312adb-0fe1-4ef7-a74a-085d0b4d3f22"      //DG OK, GCG OK?
   #define TEXTURE_SPIKESTAR         "67b464c2-d8e9-4986-8d14-1681224068eb"      //DG OK,GCG OK
   #define TEXTURE_SPIKESTAR2        "306e15ec-9a9d-4c54-9bc9-4683234a5352"      // DG OK, GCG OK
   #define TEXTURE_SPIKESTAR3        "e8ad4cd4-327f-4e1e-b384-6b5e73bd9f32"      // DG OK, GCG OK
   //#define TEXTURE_CLASSIC         "bdd0d47f-e6b2-4971-9eae-e167def7c2ef"
   //#define TEXTURE_SPIKESTAR       "24acad78-2cba-4306-a45c-5702b64ac647"
   #define TEXTURE_NAUTICAL_STAR     "84003b34-ad78-4c8b-a279-037004b2c8b3"      //GCG OK   DG OK
   //#define TEXTURE_NAUTICAL_STAR2  "1e83875a-7096-4c68-8003-6612e296ea29"      //GCG NG
   #define TEXTURE_PATRIOTIC_STAR    "d80f20f5-269e-4662-a2e2-b4f7098a81dd"      //GCG OK  DG OK
   #define TEXTURE_PAWSOME           "36a631d4-e202-4d0a-8b05-6a48fde0d258"      //GCG NG   DG NG
   #define TEXTURE_PAWSOME_CHROME    "23a79d51-75e8-4266-b447-547093c36fd6"      //GCG NG  DG NG
   #define TEXTURE_PAWSOME_CHROME2   "62f87ff6-b72d-45e7-974f-6ca25555578d"      //DG
   #define TEXTURE_SQUARE            "2e3e01f7-2d09-43f3-9eb5-8155efb327f4"      //DG OK?
   #define TEXTURE_FLAMEBALL         "1d747f98-41e2-4bd6-bbd4-9a9f36ef78bb"      //DG OK
   #define TEXTURE_FEATHERS          "467472da-9584-42c4-927e-c06b739b29f4"      //DG OK  GCG NG
   #define TEXTURE_WHIRLBLADES       "7af7b5a8-75b9-4736-b244-bec7be20a106"      //DG OK  GCG NG
   #define TEXTURE_GLOSSY_HEART      "d056a3a7-e456-4ff3-b360-04475fb16200"      // GCG NG
   #define TEXTURE_GLOSSY_HEARTS     "d056a3a7-e456-4ff3-b360-04475fb16200"      // GCG NG
   #define TEXTURE_ROSE1             "05135c09-e9a5-45da-b00d-19a0c8ef1b71"      // GCG NG
   #define TEXTURE_MAPLE_LEAF        "17eca2aa-6616-4dc2-8856-63dd82c14ca5"      //DG OK  GCG OK
   #define TEXTURE_MAPLE_LEAF_SMALL  "18e42515-503c-4d9b-89cc-edf3f38d3604"      //DG OK   GCG OK
   #define TEXTURE_WEED_LEAF2        "91f2af58-f5bf-48d5-8be0-059ddcb7f796"      //DG GCG
   #define TEXTURE_WEED              "4160ca88-f7f3-44d1-bfdf-517dfcd690c5"      // GCG
   #define TEXTURE_WEED_LEAF_WHITE   "c0b45398-15b7-4138-a955-03c51639ba73"      //DG GCG

   #define TEXTURE_ONE_RING           "5c924eec-edd6-436b-a097-b27ebbc30a89"      //DG NG, NG TG  , GCG OK
   #define TEXTURE_ONE_RING_2         "ccc45d4c-1c87-47e1-847f-1cb9c07b69a5"      //DG OK      GCG NG
   #define TEXTURE_PAWSOME_WHITE      "df12a718-9398-4dda-86a2-a698fc024aaf"      // GCG OK   DG NG
   #define TEXTURE_TORNADO1           "046ed932-2f8b-4f79-9bd5-d25c388e6afd"      //NG in GCG   OK in DG?
   #define TEXTURE_COURIER_NEW_A      "5473e212-e7bf-47f7-82d7-ca1c78c5e50c"
   #define TEXTURE_COURIER_NEW_B      "9e9e3c28-10bc-4647-ab5b-6ebe464b4d92"
   #define TEXTURE_COURIER_NEW_C      "0b723437-7157-448c-8d48-d7667a6f45cb"
   #define TEXTURE_COURIER_NEW_SPACE  "b7ea800f-80b5-4882-8a2e-4833752bd9a5"
   #define TEXTURE_COURIER_NEW_BOLD_A "11d48c16-c02e-4766-9ab2-fc8b39ff1f39"
   #define TEXTURE_COURIER_NEW_BOLD_B "c290a675-7383-449a-9c77-87a5aed545de"
   #define TEXTURE_COURIER_NEW_BOLD_C "d3eb6aca-d7d1-46ad-99da-fb2320031a7f"
   #define TEXTURE_TOBETESTED         "d8bbe2e6-a679-4a34-9829-e72760e928e4"      // patriotic star in GCG
   #define TEXTURE_PURPLE_SWIRLY      "d5d22584-94a9-4cbe-89e6-a6328ef36197"      // GCG OK
   #define TEXTURE_ROSE_STEM          "d7669781-4e49-40c2-b60a-841d37b25476"      // GCG OK
   #define TEXTURE_HEART2             "5b246c26-3b16-4e22-b1e9-6c57aef64bab"      // GCG OK
   #define TEXTURE_SHOOTINGSTAR_RWB   "af254ad1-ab01-4dba-a88b-48033eebfd1b"      //GCG OK

   #define TEXTURE_THICK_BLUE_SNOWFLAKE "89d90686-76ab-408b-b0bb-fb3764e56ffd"  //GCG ok, DISC?
   //#define TEXTURE_SANNA_CONFETTI     "7dcbe5e7-cb15-4eb8-b6ec-76ad18dd13d6"  //GCG only   
   #define TEXTURE_SANNA_CONFETTI   "cf593cba-1b90-4d5e-94d9-dfc2b6370199"  //   TL and TS at least
   #define TEXTURE_OS_CONFETTI        "f3e17fa3-7116-4a64-9e41-1d0bb34cddb7"  //GCG ok; DISC?
   #define TEXTURE_HEARTS_CONFETTI    "f955120b-4a21-4a5d-acb2-43b81228160b"  //GCG only
   //#define TEXTURE_FIRE_BLOB           "d2f3b450-09b0-498f-a89f-a01ef897e396"  // ng
   //#define TEXTURE_FIRE_BLOB           "bce3af9c-0c28-4889-a4c4-764c7fec4c88" // in TL and TSAS? 
   #define TEXTURE_FIRE_BLOB           "fe7f4927-2e23-4f09-8013-6cf1c0c00213" // new upload in Sasquatch 
#elif defined SOAS
   #define TEXTURE_CLASSIC   "e51dfec9-b481-4ea0-aa67-545632d0b3fd"
   #define TEXTURE_SPIKESTAR "9fe0e79b-f810-481a-9b6f-6a6931ed50ca"
#elif defined KITELY
   #define TEXTURE_CLASSIC "663340da-e9b4-41a5-8d89-c5259b72ad8b"
#elif defined AMARYLLIS
   #define TEXTURE_CLASSIC           "9bcfe4c3-0e6a-41ad-b7ca-1a6936dfa6c0"
   #define TEXTURE_CLASSIC_THIN      "9e31a480-c4fe-4340-90ae-747abdbee6fc"
   #define TEXTURE_SPIKESTAR         "3b4d481c-a4a4-4d0c-9875-9a4ed27df9be"
   #define TEXTURE_CLASSIC2          "9e31a480-c4fe-4340-90ae-747abdbee6fc"
   #define TEXTURE_PATRIOTIC_STAR    "20bc5407-8666-4598-829e-3040d6633cea"
   #define TEXTURE_RAINBOWS          "1df76716-d4a6-4782-b21a-7164563decb6"
   #define TEXTURE_SANNA_CONFETTI    "d3c72527-71b3-4dce-940e-3b9514737b54"
   #define TEXTURE_ONE_RING          "0ccad152-7db6-4d2b-bde1-dbe37286bb6e"
   #define TEXTURE_OS_CONFETTI       "398e644d-fd55-48e2-b210-7e82ab18610b"
   #define TEXTURE_STARWHEEL         "16c953d4-7c42-466b-81fa-23d40f2f77c5"
   #define TEXTURE_FIVECONTRAILS     "7e818905-1646-42b8-a1eb-6bdab1639859"
   #define TEXTURE_WEED              "dc008585-8d63-49d7-8bdb-92b19b35928b"
   #define TEXTURE_FIRE_BLOB         "c6543159-ec2b-4252-a66d-647f228639ea"
   #define TEXTURE_DRAKES_FLAME      "a5abbdb5-ca8b-46bc-964b-32abe2451358"
   #define TEXTURE_LEAF_MONO         "b208fff8-7e29-4508-a79f-703a2d6e14b8"
#elif defined SECONDLIFE
   #define TEXTURE_CLASSIC              "6c99633c-bbe0-46f9-2633-f1cecc4e712e"
   #define TEXTURE_SPIKESTAR            "870ac25e-8c2a-6443-76a3-a63549c25695"
   #define TEXTURE_PATRIOTIC_STAR       "ffb76ef6-effb-26a0-b16f-6fb05e3f1c8b"
   #define TEXTURE_CLASSIC_THIN         "995350d9-1def-4e27-c80b-41b8e461ccd2"
   #define TEXTURE_NAUTICAL_STAR        "7d5b57ce-3869-1bd0-a242-f54b0295c95d"
   #define TEXTURE_SQUARE               "adb0e7d5-6f0c-7615-de48-d6f6a5d5803e"
   #define TEXTURE_PAWSOME              "8ebbb68b-f93c-3b4f-d8e3-42e8e38599fd"
   #define TEXTURE_DRAKES_FLAME         "0bce40f5-c202-cf82-f9fe-bd8212b60d32"
   #define TEXTURE_FIRE_BLOB            "3c73ffa8-f7f5-dc1d-02ca-77c48bf787fb"
   #define TEXTURE_SANNA_CONFETTI_ALPHA "2f3798a2-b61e-3892-f32e-50db3b9db6a7"
   #define TEXTURE_OS_CONFETTI_ALPHA    "6dd00573-7380-4a9d-8f68-872f34773aab"
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
#define COLOR_PURPLE2       "<0.69,0.05,0.79>"
#define COLOR_3             "<0.00,0.80,0.20>"
#define COLOR_HOTPINK       "<1.00,0.30,0.50>"
#define COLOR_BLUEPURPLE    "<0.70,0.00,1.00>"
#define COLOR_LIGHTBLUE     "<0.30,0.40,1.00>"
#define COLOR_BRIGHT_BLUE   "<0.30,0.30,1.00>"
//#define COLOR_BLUE_TOO    "<0.00,0.46,0.85>"
#define COLOR_LIGHTGREYBLUE "<0.47,0.68,0.77>"
#define COLOR_TEAL          "<0.22,0.80,0.80>"
#define COLOR_AQUA          "<0.50,0.86,1.00>"
#define COLOR_CYAN          "<0.00,1.00,1.00>"
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
#define COLOR_DARK_ORANGE     "<1.000, 0.353, 0.000>"
#define COLOR_AMBER           "<1.000, 0.353, 0.000>"

#if defined HYPERGRID
   #define SOUND_WHOOSH001  "a120d4b5-e56c-4f28-ac02-f606862d269e"    //GCG OK  //DG OK
   #define SOUND_CHEE       "2494e177-c350-4868-a609-d14a0d9488ea"    //DG OK
   #define SOUND_PUREBOOM   "8dac6ea6-380f-4d5e-81d7-fbf6a7ad936e"    //GCG OK   DG OK
   #define SOUND_CLANGECHO  "69f401d1-1e61-476b-99b1-dce18531996b"
   #define SOUND_BANG1      "562f55da-414d-4ae7-b89a-7648f17a836f"   //DG OK
   //#define SOUND_SILENCE    "806f9a16-5799-43cb-a8e7-4430b44b2d2e" //GCG
   #define SOUND_SILENT     "806f9a16-5799-43cb-a8e7-4430b44b2d2e" // GCG
   #define SOUND_SILENCE     "806f9a16-5799-43cb-a8e7-4430b44b2d2e" //TS
   #define SOUND_CRACKLE3S  "35eaaf68-23ff-4c6a-bf7f-7c9235d6a661"
   #define SOUND_TRIPPYBOOM "8a7ffb6a-4511-4058-b474-4543bda891b7"
   #define SOUND_SPARKLER_5 "f0b33013-a0d1-465f-8776-2de923152ca4"
   #define SOUND_LAUNCH2  "d799a73c-8afd-446b-a41b-6539c4ad92d9"  // DG ONLY SO FAR
   //#define SOUND_BEEP1    "74d66bd8-49bb-4821-a720-6a85211990e6"  //NG
   //#define SOUND_BEEP2    "3bb3db1e-fce2-4596-8bda-1872f366ae79"  //NG
   #define SOUND_BEEP1 "2d6c2c9a-75ca-467e-bd1e-e6910a8a4d9b"
   #define SOUND_BEEP2 "cba6c7c8-5a2c-40b2-bf6f-68c2e18e29c2"
#elif defined SOAS
   #define SOUND_WHOOSH001  "3a3882d0-d8a6-4e03-b440-be31c37c805d"
   #define SOUND_PUREBOOM   "bbfcb1bf-93b2-4071-832e-89492dd04d68"
#elif defined AMARYLLIS
   #define SOUND_PUREBOOM    "520c5354-db61-4ac4-9fe4-2f3753a1735f"
   #define SOUND_WHOOSH001   "48c633b4-91a3-4712-a651-35d52905b1e3"
   #define SOUND_CHEE        "8e98cc7c-85ff-4513-91a1-4b2e5ec85608"
   #define SOUND_BANG1       "41e4d1ab-4261-4651-bd0a-cf9b1a8a9836"
   #define SOUND_SPARKLER_5  "16f68c93-0017-453b-83a3-261a50ca8d10"
   #define SOUND_SILENCE     "1b54648f-7f6c-4957-a015-9b3bc3274c35"
   #define SOUND_BANG2       "5fef7055-3f3a-443e-a72d-9d47027fa108"
   #define SOUND_HOLLOWBANG1 "fb9842bb-472d-42fc-b683-ba21c73454cf"
   #define SOUND_LAUNCH1     "d6c19db6-67cd-4798-97bb-0e1ebffdb1c2"
   #define SOUND_LAUNCH2     "4399e82e-1c26-4dfe-9fb7-963baf7b4b85"
   #define SOUND_LAUNCH3     "3630a7c9-4309-491d-822c-670727c8e429"
   #define SOUND_BANG3       "e5cd5c92-e5a6-4f8c-a5d3-7e09e362a66f"
   #define SOUND_BEEP1       "9a3a5608-06d4-4e4b-a5da-15c199022c5b"
   #define SOUND_BEEP2       "576b56ef-470c-4834-8131-d6d5c1721e96"
#elif defined SECONDLIFE
   #define SOUND_PUREBOOM  "d886762c-6ba4-c341-ee0a-86a10af62aa8"
   #define SOUND_WHOOSH001 "d99e8bdc-3ce6-966c-dfe2-5d7da7711bfb"
   #define SOUND_BANG1     "ca62e9a3-8f9c-c2df-8111-34c44bccb6e1"
   #define SOUND_BEEP1     "4442266d-f362-5ab6-c4e3-365225c45ef6"
   #define SOUND_BEEP2     "d69aec0d-c967-20ba-b39f-e2f1a57af74f"
   #define SOUND_SILENCE   "72eee6ad-682c-230e-4017-fea1ce0eacc5"
#endif

// masks for encoding options into a short message
// there's probably a clever way to determine the offset
// from the mask, but why bother
#define CHANNEL_OFFSET       14
#define MULTIMODE_OFFSET      7

#define FLIGHTTIME_MASK      0x0000007F  //                              0111 1111
#define MULTIMODE_MASK       0x00000780  //                         0111 1000 0000
#define SMOKE_MASK           0x00000800  //                         1000 0000 0000
#define RIBBON_MASK          0x00001000  //                       1 0000 0000 0000
#define FLASH_MASK           0x00002000

#define CHANNEL_MASK         0x003FC000  //          0011 1111 1100 0000 0000 0000

#define LAUNCH_ALPHA_MASK    0x00800000  //          1000 0000 0000 0000 0000 0000
#define DEBUG_MASK           0x01000000  //        1 0000 0000 0000 0000 0000 0000
#define COLLISION_MASK       0x02000000  //       10 0000
#define FREEZE_MASK          0x04000000  //      100 0000
#define WIND_MASK            0x08000000  //     1000 0000
#define LOW_VELOCITY_MASK    0x10000000  //   1 0000 0000
#define FOLLOW_VELOCITY_MASK 0x20000000  //  10 0000
#define FREEZE_ON_LAUNCH_MASK 0x40000000 //100 0000

#define MODE_MULTIBURST 1

#define PARTICLE_MODE_MASK 0x6
#define MODE_ANGLE      2
#define MODE_ANGLECONE  4
#define MODE_ANOTHERPARTICLE 6

#define MAX_INT           0x80000000
// this will do for now
#define ERROR_FLAG        -89898
#define NO_VALUE -89898




#endif  /* ifndef LIB_H */

