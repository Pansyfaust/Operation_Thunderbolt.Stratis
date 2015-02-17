#include "defines.hpp"
#define OFFSET 10
#define TEXTURE "\a3\ui_f_curator\Data\CfgCurator\entity_ca.paa"
#define MARKER "waypoint"
#define GIZMO "Sign_Sphere200cm_F"

private ["_origin","_radius","_count","_life","_oldPsn"];
_origin = [_this, 0, player, [[], objNull]] call BIS_fnc_param;
_radius = [_this, 1, 300, [0]] call BIS_fnc_param;
_count = [_this, 2, 300, [0]] call BIS_fnc_param;
_life = [_this, 3, 10e10, [0]] call BIS_fnc_param;

if (typeName _origin == "OBJECT") then
{
    _origin = _origin call TB_fnc_getPos;
};

_oldPsn = _origin;
_oldPsn set [2, (_oldPsn select 2) + OFFSET];

for "_i" from 1 to 300 do
{
    private ["_psn","_col","_life","_size"];
    _psn = [_origin, 300 * sqrt random 1, random 360] call BIS_fnc_relPos;
    _psn set [2, (_psn select 2) + OFFSET];
    _color = [random 1, random 1, random 1, 0.8];
    _life = 10e10;
    _size = 1;

    DEBUG_MARKER("DebugMarker" + str _i, _psn, MARKER, "ColorBlack", _size, "", _life)
    DEBUG_GIZMO(GIZMO, if (!surfaceIsWater _psn) then {ATLtoASL _psn} else {_psn}, _color, _life)
    DEBUG_LINE3D(_psn, _oldPsn, _color, _life)
    DEBUG_ICON3D(TEXTURE, _color, _psn, _size, _life)
    DEBUG_LINE(_psn, _oldPsn, _color, _size, _life)
    DEBUG_ICON(TEXTURE, _color, _psn, _size * 50, _life)
    DEBUG_CIRCLE(_psn, _size * 50, _color, "", _life)

    _oldPsn = _psn;
    sleep 0.01;
};

hint format [
    "Line 3D: %1\nIcon 3D: %2\nLine: %3\nIcon: %4\nEllipse: %5\n Marker%6\nGizmo: %7",
    count TB_debugLine3D,
    count TB_debugIcon3D,
    count TB_debugLine,
    count TB_debugIcon,
    count TB_debugEllipse,
    count TB_debugMarker,
    count TB_debugGizmo
]