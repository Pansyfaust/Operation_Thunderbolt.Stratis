/*
    splits an array of units into one array of vehicles and another array of soldiers

    0: ARRAY        - array of units to check.
    
    Return: ARRAY   - one array of soldiers (element 0) and another array of vehicles (element 1)
*/

private ["_orgArr","_splitArr"];
_orgArr = [_this, 0, [], [[]]] call BIS_fnc_param;
_splitArr = [[],[]];

{
    if (vehicle _x == _x) then
    {
        (_splitArr select 0) pushBack _x;
    }
    else
    {
        // Multiple units can be in the same vehicle! Treat those units as one vehicle
        if (!(vehicle _x in (_splitArr select 1))) then
        {
            (_splitArr select 1) pushBack (vehicle _x);
        };
    };
} count _orgArr;

_splitArr