#include "macros.hpp"

#define DEBUG // Comment out to disable debug mode

#ifdef DEBUG
    #define DEBUG_MSG(MSG) [MSG, "TB_fnc_debugMessage"] spawn BIS_fnc_MP;
    #define DEBUG_MARKER(NAME,PSN,ICON,COLOR,SIZE,TEXT) [NAME,PSN,ICON,COLOR,SIZE,TEXT] call TB_fnc_debugMarker;
    #define DEBUG_GIZMO(NAME,PSN,COLOR) [NAME,PSN,COLOR] call TB_fnc_debugGizmo;
#else
    #define DEBUG_MSG(MSG)
    #define DEBUG_MARKER(NAME,PSN,ICON,COLOR,SIZE,TEXT)
    #define DEBUG_GIZMO(NAME,PSN,COLOR)
#endif

// Script values
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

#define STATE_PATROL 0
#define STATE_ALERT 1
#define STATE_COMBAT 2

#define MINES [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"MineClasses",[]] call BIS_fnc_returnConfigEntry