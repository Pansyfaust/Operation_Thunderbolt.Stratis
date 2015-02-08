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

#define PLAYER_SIDES blufor

#define AI_SIDES opfor, independent
#define AI_SLEEP 5

#define GAME_SLEEP 30