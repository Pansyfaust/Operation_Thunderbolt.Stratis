/*
    Biased random chances. For example:
    [["apple", 0.75], ["banana", 0.25]] call TB_fnc_weightedRandom; has a 75% chance of returning apple, 25% for banana
    [["coconut", 189], ["durian", 5.4]] call TB_fnc_weightedRandom; has a 2.777..% chance of returning durian
    [0.55, 0.45] call TB_fnc_weightedRandom; has a 55% chance of returning 0 and 45% chance of returning 1

    0: ARRAY or NUMBER          - Array of array [value, weight] or simply a weight
    1 (Optional): NUMBER        - Index to check for weight if array, if valid, the element is returned whole instead of the value

    Return: ANY                 - The random array or index if no value
*/

private ["_array","_index","_sum","_random","_weight","_return","_value"];
_array = [_this, 0, [], [[]]] call bis_fnc_param;
_index = [_this, 1, 1, [0]] call bis_fnc_param;
_sum = 0;
_weight = 0;

{
    _weight = if (typeName _x == typeName []) then {_x select _index} else {_x};
    _sum = _sum + _weight;
} count _array;

_random = random _sum;

_sum = 0;
_weight = 0;
_return = objNull;

{
    if (typeName _x == typeName []) then
    {
        _value = _x;
        _weight = _x select _index;
    }
    else
    {
        _value = _forEachIndex;
        _weight = _x;
    };
    _sum = _sum + _weight;

    if (_sum > _random) exitWith
    {
        _return = _value;
    };
} forEach _array;

_return