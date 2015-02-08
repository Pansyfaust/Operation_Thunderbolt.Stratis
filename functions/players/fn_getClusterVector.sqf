/*
    Obtain the 2d movement vector of a group of players

    0: ARRAY                - array of player objects

    return: ARRAY           - vector, not normalized. the magnitude is speed
*/

private ["_list","_count","_vector"];
_list = _this select 0;
_count = count _list;
_vector = [0,0,0];

// Avoid dividing by zero later
if (_count > 0) then
{
    {
        _vector = _vector vectorAdd velocity _x;        
    } forEach _list;
    
    _vector = _vector vectorMultiply (1 / _count);
};

_vector