/*
	function to Check if a position is obscured from the players by terrain

    0: ARRAY		- position (ATL) to check.
	1: ARRAY		- array of units to check with.
	2: NUMBER		- radius of rays check.
	
    Return: BOOL	- true if obscured, else false.

    Check is a position is obscured from the players by terrain
    Check from the camera or aiming_axis memory point of players
    Watch out for ASL and ATL mixups
*/

_pos = [_this, 0, [0,0,0], [[]], 3] call BIS_fnc_param;

//instead of converting everytime.
_posASL = ATLToASL _pos;  

_players = [_this, 1, [], [[]]] call BIS_fnc_param;
_radius = [_this, 2, 1, [0]];
_check = true;
{
	if ((_x distance _pos) < MAXDISTANCE) then {
		if (!(terrainIntersect [getPosATL _x, _pos])) then {
			_check = lineIntersects [eyePos _x, _posASL, _x]];
			if (!_check) exitWith {};
			_dir = [_posASL, eyePos _x] call BIS_fnc_dirTo;
			for "_i" from -1 to 1 step 2 do {
				if (!(lineIntersects [eyePos _x,[_posASL, _radius,  _dir + (90 * _i)] call BIS_fnc_relPos])) exitWith {_check = false};
			};
			if (!_check) exitWith {};
		};
	};
}forEach _players;
_check

//Experiment with this
//GIZMO = [] call TB_fnc_debugGizmo; onEachFrame {GIZMO setpos (player modelToWorld (player selectionPosition "camera"))}