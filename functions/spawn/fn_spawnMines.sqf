/*
    Spawns mines in a given area based on the given shape, radius, count and position.
    
    0: ARRAY            - array of POSITION
    1: ARRAY            - minetypes
    2: ARRAY            - sides/units to reveal these mines to
    
    Return: ARRAY       - all the spawned mines
*/

private ["_points","_mineTypes","_revealTo","_mines"];
_points = [_this, 0, [], [[]]] call BIS_fnc_param;  
_mineTypes = [_this, 1, [], [[]]] call BIS_fnc_param;
_revealTo = [_this, 2, [], [[]]] call BIS_fnc_param; 

_mines = [];

{
    private "_mine"];
    _mine createMine [_mineTypes call BIS_fnc_selectRandom, _x, [], 0]; // Replace with a weighted random system in future
    
    // AI will try to avoid known mines, players will see red trianges when close
    {_x revealMine _mine} count _sides;

    _mines pushBack _mine;
} count _points;

_mines