#include "macros.hpp"

// Comment out to disable debug mode
//#define DEBUG


#ifdef DEBUG
    #define DEBUG_MSG(MSG) [MSG, "TB_fnc_debugMessage"] spawn BIS_fnc_MP;
    #define DEBUG_MARKER(NAME,PSN,ICON,COLOR,SIZE,TEXT) [NAME,PSN,ICON,COLOR,SIZE,TEXT] call TB_fnc_debugMarker;
    #define DEBUG_GIZMO(NAME,PSN,COLOR) [NAME,PSN,COLOR] call TB_fnc_debugGizmo;
#else
    #define DEBUG_MSG(MSG)
    #define DEBUG_MARKER(NAME,PSN,ICON,COLOR,SIZE,TEXT)
    #define DEBUG_GIZMO(NAME,PSN,COLOR)
#endif

#define PLAYER_SIDES blufor // Placeholder

#define AI_SIDES opfor, independent  // Placeholder
#define AI_SLEEP 5

#define GAME_SLEEP 30

#define MUZZLE_TYPE 101
#define OPTIC_TYPE 201
#define SIDE_TYPE 301

#define PRIMARY_WEP 0
#define SECONDARY_WEP 1
#define HANDGUN_WEP 2