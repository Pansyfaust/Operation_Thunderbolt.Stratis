/*
    Use the various boundingBox commands to find the size of the clearing required
    Use BIS_fnc_relPos and findEmptyPosition until a spot has been found
    Return empty array ([]) if no suitable spot can be found
	
	0: ARRAY						- position array of position to start search from
	1: SCALAR						- search radius in meters.
	2: ARRAY or STRING or SCALAR 	- single classname or an array of classnames, alternatively a number to represent the required clearing radius in meters.
	
	Return: ARRAY 					- 3 element position array if successful, else an empty array [] (0 elements).
*/
	
_sPos = [];
_initalPos = _this select 0;
_searchRadius = _this select 1;
_searchObject = _this select 2;
_objectRadius = 0;

switch (toUpper (typeName _searchObject)) do {
	case "ARRAY" : {
		/*
			binary tree 2d bin packing to generate a square
			calculate pythagoras from square to get radius of circle that encompasses the square
		*/
		for "_i" from 0 to count _searchObject - 1 do {
			_searchObject set [_i, (_searchObject select _i) call TB_fnc_vehicleSize];
		};
		hint str(_searchObject);
		_searchObjectSize = _searchObject call TB_fnc_pack2DBin;
		hint str(_searchObjectSize);
		for "_i" from 0 to 1 do {
			_objectRadius = _objectRadius + ((_searchObjectSize select _i)^2);
		};
		_objectRadius = sqrt(_objectRadius)/2
	};
	case "STRING" : {
		_sPos = _initalPos findEmptyPosition [0,_searchRadius,_searchObject];
	};
	case "SCALAR" : {_objectRadius = _searchObject};
	default {//implying error handling};
};
if (count _sPos < 3) then {
	_sPos = _initalPos isFlatEmpty [_objectRadius, _searchRadius, 0.7, _objectRadius*2, 0, _objectRadius < 25];
};
_sPos;