_size = worldName call BIS_fnc_mapSize;
_center = [_size/2,_size/2];
_positions = selectBestPlaces [_center, _center select 0, "(1-forest)*(0-sea)", 100, (_size * _size)/1000000];
_sPos = [];
{
	_check = !surfaceIsWater (_x select 0);
	if (_check) then {
		for [{_i=0},{_i<_forEachIndex},{_i=_i+1}] do {
			if ((_x select 0) distance ((_positions select _i) select 0) < 500) exitWith {
				_check = false;
			};
		};
	};
	if (_check) then {
		_sPos set [count _sPos, _x select 0];
	};
}forEach _positions;

//debug
if DEBUG then {
	{
		(createMarker [str(_forEachIndex), _x]) setMarkerType "mil_dot";
	}forEach _sPos;
};

_sPos;