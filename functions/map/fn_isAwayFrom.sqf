/*
    Checks if a position is away from any points AND/OR areas

    0: POSITION 2D          - the position to check
    1: ARRAY                - array of [POSITION 2D: points, NUMBER: radius] or simply a point
    2: NUMBER               - minimum distance away from the area

    return: BOOL            - true if not near any areas, else false
*/

private ["_psn","_objects","_distance"];
_psn = [_this, 0] call BIS_fnc_param;
_objects = [_this, 1] call BIS_fnc_param;
_distance = [_this, 2] call BIS_fnc_param;

_isAway = true;

_psn resize 2; // 2D Position

{
    private ["_point","_radius"];
    if (typeName _x == typeName [])
    {
        _point = [_x, 0] call BIS_fnc_param;
        _radius = [_x, 1, 0, [0]] call BIS_fnc_param;
    }
    else
    {
        _point = _x
        _radius = 0;
    }

    if (_psn distance _point < _distance + _radius) exitWith {_isAway = false};
} count _objects;

_isAway