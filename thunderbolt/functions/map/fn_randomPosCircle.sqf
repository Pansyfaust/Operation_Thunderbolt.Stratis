/*
    function to generate points in a circle/hollow circle
    feel free to add more arguments
	
	TODO: switch to ENUM (arg 4 and 5)

    0: POSITION                 - center of the circle
    1: NUMBER                   - number of points to return
    2: NUMBER                   - radius of circle
    3 (Optional): NUMBER        - inner radius of circle
    4 (Optional): NUMBER        - doesnt matter/only on roads/avoid roads (0/1/2)
    5 (Optional): NUMBER        - doesnt matter/only in water/avoid water (0/1/2)

    Return: ARRAY           - array of points
*/

private["_sPos","_num","_eRadius", "_iRadius","_roadFlag", "_waterFlag", "_mPos", "_posArr", "_check"];
_sPos = [_this, 0, [0,0,0], [[]], 3] call BIS_fnc_param;
_num = [_this, 1, 0, [0]] call BIS_fnc_param;
_eRadius = [_this, 2, 0, [0]] call BIS_fnc_param;
_iRadius= [_this, 3, 0, [0]] call BIS_fnc_param;
_roadFlag = [_this, 4, 0, [0]] call BIS_fnc_param;
_waterFlag = [_this, 5, 2, [0]] call BIS_fnc_param;

_posArr = [];

while {count _posArr < _num} do {
	_mPos = [_sPos,(_iRadius + random (_eRadius - _iRadius)),random 360] call BIS_fnc_relPos;
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