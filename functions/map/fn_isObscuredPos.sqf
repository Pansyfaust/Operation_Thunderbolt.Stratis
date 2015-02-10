/*
	function to Check if a position is obscured from the players by terrain

    0: ARRAY					- position (ATL) to check.
	1: ARRAY					- array of units to check with.
	
    Return: BOOL				- true if obscured, else false.

    Check is a position is obscured from the players by terrain
    Check from the camera or aiming_axis memory point of players
    Watch out for ASL and ATL mixups
*/

_pos = [_this, 0, [0,0,0], [[]], 3] call BIS_fnc_param;

//instead of converting everytime.
_posASL = ATLToASL _pos;  

_players = [_this, 1, [], [[]]] call BIS_fnc_param;
_check = true;
{
	if ((_x distance _pos) < MAXDISTANCE) then {
		if (!(terrainIntersect [getPosATL _x, _pos])) exitWith {
			_check = lineIntersects [eyePos _x, _posASL, _x]; 
		};
	};
}forEach _players;
_check

//Experiment with this
//GIZMO = [] call TB_fnc_debugGizmo; onEachFrame {GIZMO setpos (player modelToWorld (player selectionPosition "camera"))}