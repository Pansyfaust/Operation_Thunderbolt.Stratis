/*
    This function rearms a vehicle based on its configured magazines.
    generic script to rearm all types of vehicles.

	0: Object                 - A vehicle object

	return: NONE
*/
_vehicle = vehicle _this;
_class = configFile >> "CfgVehicles" >> typeOf _vehicle;

_vehicle setFuel 1;
_vehicle setVehicleAmmo 0;
{_vehicle addMagazine _x} count (_class call TB_fnc_getMagazines);