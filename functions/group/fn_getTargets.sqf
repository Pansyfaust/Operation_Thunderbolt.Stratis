/*
    Returns valid targets using the nearTargets command.
    Will check if a unit is known well enough.

    1: OBJECT               - target unit (should be an AI)
    2: NUMBER               - minimum accuracy, targets with position accuracy below this value are valid
    3: NUMBER               - range to search for targets

    Return: ARRAY           - array of OBJECTS
*/

_unit = [_this, 0] call BIS_fnc_param;
_minAccuracy = [_this, 1, 0.5, [0]] call BIS_fnc_param;
_range = [_this, 2, 1000, [0]] call BIS_fnc_param;

_validTargets = [];

// Search for targets
_targets = _unit nearTargets _range;
{
    // If the target's subjective cost (threat) is positive, this unit thinks it's hostile
    // According to the biki unidentified units may have positive subjective cost but I haven't been able to replicate this with AI units
    // Check positional accuracy as well. If it's too high the unit doesn't really know where it is
    if ((_x select 3) > 0 && {(_x select 5) <= _minAccuracy}) then
    {
        _validTargets pushBack _x;
    };
} foreach _targets;

_validTargets