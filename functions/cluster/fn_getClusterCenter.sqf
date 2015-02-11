/*
    Find the mean 2d position of a cluster

    0: ARRAY                    - array of objects in the cluster

    return: POSITION 2D         - vector, not normalized. the magnitude is speed
*/

private ["_list","_count","_mean"];
_list = [_this, 0] call BIS_fnc_param;
_count = 0;
_mean = [0,0,0];

{
    _count = _count + 1;
    _mean = _mean vectorAdd getPosWorld _x;
} count _list;

// Avoid dividing by zero
if (_count > 0) then
{
    _mean = _mean vectorMultiply (1 / _count);
};

_mean resize 2; // 2D Position

_mean