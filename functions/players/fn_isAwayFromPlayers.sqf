/*
    Checks if a position or object is far enough from the players

    0: POSITION or OBJECT   - the argument to check
    1: NUMBER               - minimum distance

    return: BOOL            - true is far enough, false otherwise
*/

private ["_psn","_distance","_result"];
_psn = _this select 0;
_distance = _this select 1;
if (typeName _psn == "OBJECT") then
{
    _psn = getPosASL "OBJECT";
};

_result = true;
{
    if ((getPosASL _x) distance _psn < _distance) exitWith {_result = true};
} forEach playableUnits;

_result