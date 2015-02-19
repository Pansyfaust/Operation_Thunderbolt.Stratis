#include "macros.hpp"

#define DEBUG // Comment out to disable debug mode

#ifdef DEBUG
    #define DEBUG_EXEC(PARAM,SCRIPT) PARAM execVM SCRIPT;
    #define DEBUG_MSG(MSG) [MSG, "TB_fnc_debugMessage"] spawn BIS_fnc_MP;
    #define DEBUG_MARKER(NAME,PSN,ICON,COL,SIZE,TEXT,LIFE) TB_debugMarker pushBack [[NAME,PSN,ICON,COL,SIZE,TEXT] call TB_fnc_debugMarker,diag_ticktime+LIFE]; 
    #define DEBUG_GIZMO(NAME,PSN,COL,LIFE) TB_debugGizmo pushBack [[NAME,PSN,COL] call TB_fnc_debugGizmo,diag_ticktime+LIFE];
    #define DEBUG_LINE3D(PSN1,PSN2,COL,LIFE) TB_debugLine3D pushBack [[PSN1,PSN2,COL],diag_ticktime+LIFE];
    #define DEBUG_ICON3D(TEX,COL,PSN,SIZE,LIFE) TB_debugIcon3D pushBack [[TEX,COL,PSN,SIZE,SIZE,0],diag_ticktime+LIFE];
    #define DEBUG_LINE(PSN1,PSN2,COL,WIDTH,LIFE) TB_debugLine pushBack [[PSN1,PSN2,COL,WIDTH] call TB_fnc_lineToRectangle,diag_ticktime+LIFE];
    #define DEBUG_ICON(TEX,COL,PSN,SIZE,LIFE) TB_debugIcon pushBack [[TEX,COL,PSN,SIZE,SIZE,0],diag_ticktime+LIFE];
    #define DEBUG_CIRCLE(PSN,SIZE,COL,FILL,LIFE) TB_debugEllipse pushBack [[PSN,SIZE,SIZE,0,COL,FILL],diag_ticktime+LIFE];
#else
    #define DEBUG_EXEC(SCRIPT)
    #define DEBUG_MSG(MSG)
    #define DEBUG_MARKER(NAME,PSN,ICON,COL,SIZE,TEXT,LIFE)
    #define DEBUG_GIZMO(NAME,PSN,COL,LIFE)
    #define DEBUG_LINE3D(PSN1,PSN2,COL,LIFE)
    #define DEBUG_ICON3D(TEX,COL,PSN,SIZE,LIFE)
    #define DEBUG_LINE(PSN1,PSN2,COL,WIDTH,LIFE)
    #define DEBUG_ICON(TEX,COL,PSN,SIZE,LIFE)
    #define DEBUG_CIRCLE(PSN,SIZE,COL,FILL,LIFE)
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

#define SPAWN_INFANTRY 0
/*#define SPAWN_RECON
#define SPAWN_SNIPER

#define SPAWN_CAR
#define SPAWN_MOTORIZED
#define SPAWN_MECHANIZED
#define SPAWN_ARMORED
#define SPAWN_HELI
#define SPAWN_MINES
#define SPAWN_NAVAL*/