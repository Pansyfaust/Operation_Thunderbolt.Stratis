/*
	2D Square Bin Packing implementation, tries to compress squares into most optimized size.
	Currently only does one iteration for sake of performance.

        0: ARRAY                                                - sizes array (x,y) of squares.
       
        Return: ARRAY                                   - 2 element size array (x,y) of the square bin holding the squares.
*/

_elements = _this;
_elements = [_elements, [], {_x select 1}, "DESCEND"] call BIS_fnc_sortBy;
_leftCorners = [[0,0]];

//generate inital box height (maximum height of single object)
_yBox = (_elements select 0) select 1;

{
	_element = _x;
	_leftCorners = [_leftCorners, [], {_x select 0}, "ASCEND", {isNull _x}] call BIS_fnc_sortBy;
	for "_i" from 0 to count _leftCorners - 1 do {
		_corner = _leftCorners select _i;
		_leftCornerX = (_element select 0) + (_corner select 0);
		_leftCornerY = (_element select 1) + (_corner select 1);
		if (_leftCornerY <= _yBox ) then {
			_check = true;
			{
				if ((_x select 0 > (_corner select 0)) && {_x select 1 > _leftCornerY}) exitWith {
					_check = false;
				};
			}forEach _leftCorners;
			if (_check) exitWith {
				_leftCorners set [_i, objNull];
				_leftCorners pushBack [_corner select 0, _leftCornerY];
				_leftCorners pushBack [_leftCornerX, _corner select 1];
			};
		};
		
		//try rotating the object
		_leftCornerX = (_element select 1) + (_corner select 0);
		_leftCornerY = (_element select 0) + (_corner select 1);
		if (_leftCornerY <= _yBox) then {
			_check = true;
			{
				if ((_x select 0 > (_corner select 0)) && {_x select 1 > _leftCornerY}) exitWith {
					_check = false;
				};
			}forEach _leftCorners;
			if (_check) exitWith {
				_leftCorners set [_i, objNull];
				_leftCorners pushBack [_corner select 0, _leftCornerY];
				_leftCorners pushBack [_leftCornerX, _corner select 1];
			};
		};
	};
}forEach _elements;

_xBox = 0;
{
	_xBox = _xBox max (_x select 0);
}forEach _leftCorners;
_box = [_xBox, _yBox];
_box;