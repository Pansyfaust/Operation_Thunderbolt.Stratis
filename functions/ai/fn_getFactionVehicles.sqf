/*
    Search through CfgVehicles and return every class that is scope=2 and is of the given faction.
	Uses side caching for an integer filtering check instead of string comparison (reduces 3ms of runtime on vanilla sized cfgVehicles, more on modded game).
	TODO: add error checks and is it worth adding type filtering in this function?
	
    0: STRING		- faction name

    return: ARRAY	- array of STRING vehicle class names
*/
private ["_faction","_baseClass","_fSide","_vehicleClass","_vehicleFaction", "_vehicleArr"];
_faction = toUpper([_this, 0, "", [""]] call BIS_fnc_param);
_fSide = getNumber (configFile >> "CfgFactionClasses" >> _faction >> "side");
_vehicleArr = [];
_baseClass = (configFile >> "CfgVehicles");
for "_i" from 0 to (count _baseClass) - 1 do {
	_vehicleClass = _baseClass select _i;
	if (isClass _vehicleClass) then {
		if (_fSide == (getNumber (_vehicleClass >> "side"))) then {
			_vehicleFaction = toUpper(getText (_vehicleClass >> "faction"));
			if (_vehicleFaction == _faction) then {
				if ((getNumber (_vehicleClass >> "scope")) == 2) then {
					_vehicleArr pushBack (configName _vehicleClass);
				};
			};	
		};
	};
};
_vehicleArr;
