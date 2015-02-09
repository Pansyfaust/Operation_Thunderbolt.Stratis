/*
    This function is used to retrieve all magazines configured on a vehicle and on all of its possible turrets.

	0: CLASS                 - A path to a sub class of CfgVehicles

	return: ARRAY            - An array of arrays containing magazine classnames
*/
_class = _this;
_mags = [_class,"magazines",[]] call BIS_fnc_returnConfigEntry;
_class = (_class >> "Turrets");
// Recursion to retrieve all magazines from turret
for "_i" from 0 to _i < count _class do
{
	_mags = _mags + ((_class select _i) call TB_fnc_getMagazines);
};
_mags