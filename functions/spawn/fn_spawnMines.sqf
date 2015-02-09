/*
	Spawns mines in a given area based on the given shape, radius, count and position.
	
	0: ARRAY		- center position of where to spawn mines
	1: SCALAR		- minimum spawn radius in meters
	2: SCALAR		- maximum spawn radius in meters
	3: SCALAR		- amount of mines to spawn
	
	Return: ARRAY 	- array referencing all the spawned mines

    akp: rectangular, or hollow box minefields are ok too, but can be added later
*/

_pos = [_this, 0, [0,0,0], [[]], 3] call BIS_fnc_param;  
_minR = [_this, 1, [0], 0] call BIS_fnc_param;
_maxR = [_this, 2, [0], 0] call BIS_fnc_param;
_amount = [_this, 3, [0], 0] call BIS_fnc_param;
_mineTypes = [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"MineClasses",[]] call BIS_fnc_returnConfigEntry;

_mines = [];
	for "_i" from 1 to _amount do {
		_mPos = [_pos,(_minR + random (_maxR - _minR)),random 360] call BIS_fnc_relPos;
		_mine = createMine [_mineTypes call BIS_fnc_selectRandom, _mPos, [], 0];
		//TODO: use variable or define for reveal.
		EAST revealMine _mine;
		_mines pushBack _mine;
	};
_mines;