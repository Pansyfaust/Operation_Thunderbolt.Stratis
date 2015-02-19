/*
    Spawns objects at an array of points
    
    0: ARRAY                            - array of POSITION ATL or [position, dir]
    1: ARRAY                            - objects to use
    2 (Optional): SCRIPT                - if we aren't using [postion, dir] we can specify a dir, default: random 360
    
    Return: ARRAY       - all the spawned objects
*/

private ["_points","_objectTypes","_dirScript","_objects"];
_points = [_this, 0, [], [[]]] call BIS_fnc_param;  
_objectTypes = [_this, 1, [], [[]]] call BIS_fnc_param;
_dirScript = [_this, 2, {random 360}, [{}]] call BIS_fnc_param;

_objects = [];

{
    private ["_psn","_dir","_object"];
    if (count _x == 2) then
    {
        _psn = _x select 0;
        _dir = _x select 1;
    }
    else
    {
        _psn = _x;
        _dir = call _dirScript;
    };
    
    _object = createVehicle [_objectTypes call BIS_fnc_selectRandom, _x, [], 0, "NONE"]; // Replace with a weighted random system in future
    _object setDir _dir;

    _objects pushBack _object;
} count _points;

_objects