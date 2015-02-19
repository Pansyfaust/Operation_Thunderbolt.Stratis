/*
    function to generate points in a box/hollow box
    could be a rotated box
    feel free to add more arguments

    0: POSITION                 - center of the box
    1: NUMBER                   - number of points to return
    2: ARRAY                    - size of box
    3 (Optional): ARRAY         - inner size of box
    4 (Optional): NUMBER        - rotation of box
    5 (Optional): NUMBER        - doesnt matter/only on roads/avoid roads (0/1/2)
    6 (Optional): BOOL          - doesnt matter/only in water/avoid water (0/1/2)

    Return: ARRAY               - array of points
*/

private["_sPos","_num","_eBox", "_iBox", "_dir","_roadFlag", "_waterFlag", "_mPos", "_posArr", "_check"];
_sPos = [_this, 0, [0,0,0], [[]], 3] call BIS_fnc_param;
_num = [_this, 1, 0, [0]] call BIS_fnc_param;
_eBox = [_this, 2, [0,0], [[]],2] call BIS_fnc_param;
_iBox = [_this, 3, [0,0], [[]],2] call BIS_fnc_param;
_dir = [_this, 4, 0, [0]] call BIS_fnc_param;
_roadFlag = [_this, 5, 0, [0]] call BIS_fnc_param;
_waterFlag = [_this, 6, 2, [0]] call BIS_fnc_param;

_posArr = [];

while {count _posArr < _num} do {
	if (random 1 < 0.5) then {
		//x inital
		_mPos = [_sPos,(((_iBox select 0)/2) + random (((_eBox select 0)/2) - ((_iBox select 0)/2))), _dir + ([90,-90] call BIS_fnc_selectRandom)] call BIS_fnc_relPos;
		_mPos = [_mPos, (random (_eBox select 1)) - ((_eBox select 1)/2), _dir + ((floor (random 2))*180)] call BIS_fnc_relPos;
	} else {
		//y inital
		_mPos = [_sPos,(((_iBox select 1)/2) + random (((_eBox select 1)/2) - ((_iBox select 1)/2))),_dir + ((floor (random 2))*180)] call BIS_fnc_relPos;
		_mPos = [_mPos, (random (_eBox select 0)) - ((_eBox select 0)/2), _dir + ([90,-90] call BIS_fnc_selectRandom)] call BIS_fnc_relPos;
	};
	
	_check = switch (_roadFlag) do {
		case 1: {isOnRoad _mPos};
		case 2: {!isOnRoad _mPos};
		default {true};
	};
	if (_check) then {
		_check = switch (_waterFlag) do {
			case 1: {surfaceIsWater _mPos};
			case 2: {!surfaceIsWater _mPos};
			default {_check};
		};
	};
	if (_check) then {
		_posArr pushBack _mPos;
	};
};
_posArr