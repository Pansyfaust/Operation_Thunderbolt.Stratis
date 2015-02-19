/*
	Returns a random point on the map
*/

private ["_size", "_psn"]; 
_size = worldName call BIS_fnc_mapSize;
_psn = [random _size, random _size, 0];

_psn