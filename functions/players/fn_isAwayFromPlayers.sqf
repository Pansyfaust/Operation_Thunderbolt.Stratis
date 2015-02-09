/*
    Checks if a position or object is far enough from the players (or any other object)

    0: POSITION or OBJECT   - the position to check
    1: NUMBER               - minimum distance
    2 (Optional): ARRAY     - objects to check for proximity, default: all players

    return: BOOL            - true is far enough, false otherwise
*/

private ["_psn","_distance","_objects","_result"];
_psn = [_this, 0] call BIS_fnc_param;
_distance = [_this, 1] call BIS_fnc_param;
_objects = [_this, 2, playableUnits, [[]]] call BIS_fnc_param;

if (typeName _psn == "OBJECT") then
{
    _psn = getPosASL "OBJECT";
};

_result = true;
{
    if ((getPosASL _x) distance _psn < _distance) exitWith {_result = true};
} count _objects;

_result