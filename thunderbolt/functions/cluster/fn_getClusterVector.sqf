/*
    Obtain the movement vector of a group of players

    0: ARRAY                - array of cluster objects

    return: ARRAY           - vector, not normalized. the magnitude is speed
*/

private ["_list","_count","_vector"];
_list = [_this, 0] call BIS_fnc_param;
_count = 0;
_vector = [0,0,0];

_count =
{
    _vector = _vector vectorAdd velocity _x; true
} count _list;

// Avoid dividing by zero
if (_count > 0) then
{
    _vector = _vector vectorMultiply (1 / _count);
};

_vector