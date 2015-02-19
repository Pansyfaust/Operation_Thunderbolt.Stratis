private ["_clusters","_areas","_vectors","_count"];
_clusters = [playableUnits, 50] call TB_fnc_getClusters;

_areas = [];
_vectors = [];
_count = count _clusters;
if (_count == 0) exitWith {[]};
{
    _areas pushBack [[_x] call TB_fnc_getClusterCenter, [_x] call TB_fnc_getClusterRadius];
    _vectors pushBack [];
} count _clusters;

private "_return";
_return = [];
for "_try" from 1 to 100 do
{
    private ["_i","_vector","_psn"];
    _i = floor random _count;
    _vector = _vectors select _i;
    if (_vector isEqualTo []) then
    {
        _vector = [_clusters select _i] call TB_fnc_getClusterVector;
    };
    _vector = _vector vectorMultiply 300;
    _psn = (getpos player) vectorAdd _vector;
    if ([_psn, _areas, 300] call TB_fnc_isAwayFrom &&
        {[_psn, playableUnits, 3] call TB_fnc_isObscuredPos}) exitWith
    {
        _return = _psn;
    };
};

_return