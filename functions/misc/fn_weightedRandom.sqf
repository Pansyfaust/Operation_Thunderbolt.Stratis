/*
    Biased random chances. For example:
    [["apple", 0.75], ["banana", 0.25]] call TB_fnc_weightedRandom has a 75% chance of returning apple, 25% for banana
    [["coconut", 189], ["durian", 5.4]] call TB_fnc_weightedRandom has a 2.777..% chance of returning durian

    0: ARRAY            - Array of array [value, weight]

    Return: ANY         - Random element
*/

private ["_array","_sum"];
_array = [_this, 0, [], [[]]] call bis_fnc_param;
_sum = 0;

{
    _sum = _sum + (_x select 1);
} count _array;

_random = random _sum;

_value = 0;
_return = objNull;
{
    _value = _value + (_x select 1);
    if (_value > _sum) exitWith
    {
        _x select 0;
    };
} count _array;

_return