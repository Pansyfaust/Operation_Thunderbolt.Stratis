/*
	This function rearms a vehicle based on its configured magazines.
	generic script to rearm all types of vehicles.
*/

//internal function for config magazine retrieval
fnc_getMagazines = {
	_magazines = [];
	_class = _this;
	_magazines = [_class,"magazines",[]] call BIS_fnc_returnConfigEntry;
	_class = (_class >> "Turrets");
	//recursion to retrieve all magazines from turret
	for [{_x=0},{_x< count _class},{_x=_x+1}] do {
		_magazines = _magazines + ((_class select _x) call fnc_getMagazines);
	};
	_magazines
};

_vehicle = vehicle _this;
_class = (configFile >> "CfgVehicles" >> typeOf _vehicle);

_vehicle setFuel 1;
_vehicle setVehicleAmmo 0;
{_vehicle addMagazine _x} forEach (_class call fnc_getMagazines);