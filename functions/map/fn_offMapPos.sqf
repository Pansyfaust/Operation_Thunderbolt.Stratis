/*
	Returns the nearest offmap position (with 10 degree inaccuracy) to a specified target/unit or just given direction.
*/
// Minimize the amount of magic numbers in this function, move some stuff to defines
// Maybe make inaccuracy an optional parameter?

private ["_size", "_center", "_dir", "_exitPos"]; 
_size = worldName call BIS_fnc_mapSize;
_center = [_size/2, _size/2];

// If arg is already a number then use that direction
if (typeName _this == "SCALAR") then
{
	_dir = _this;
}
else
{
	_dir = [_center, _this] call BIS_fnc_dirTo; // Accepts objects or position
	_dir = _dir + ((random 20) - 10);
};

_exitPos = [_center, _size * 0.6,  _dir] call BIS_fnc_relPos;

// Normalize result so it still spawns within map bounds
for "_i" from 0 to 1 do
{
	_exitPos set [_i, 0 max (_size min (_exitPos select _i))];
};
_exitPos set [2, 0];

_exitPos