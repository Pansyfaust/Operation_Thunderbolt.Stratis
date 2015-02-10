/*
	Parse enums based on base of 2 (2^x) etc.
	0: NUMBER					- the enum.
	
    Return: ARRAY				- elements in the enum.
*/
_enum = [_this, 0, 1, [0]] call BIS_fnc_param;
_enumArr = [];
while {_enum > 0} do {
	_power = floor ((ln _enum)/ln 2);
	_enumArr pushBack (2^_power);
	_enum = _enum - (2^_power);
};
_enumArr