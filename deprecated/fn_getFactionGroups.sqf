/*
    Search through CfgGroups and return every class that is scope=2 and is of the given faction.
	TODO: add error checks and is it worth adding type filtering in this function?
	
    0: STRING		- faction name

    return: ARRAY	- array of STRING group class names
*/
private ["_faction","_baseClass","_fSide","_groupClass","_groupTypeClass", "_groupArr"];
_faction = toUpper([_this, 0, "", [""]] call BIS_fnc_param);
_groupArr = [];

_fSide = getNumber (configFile >> "CfgFactionClasses" >> _faction >> "side");
_baseClass = (configFile >> "CfgGroups");

for "_i" from 0 to (count _baseClass) - 1 do {
	_groupClass = _baseClass select _i;
	if (isClass _groupClass) then {
		if (_fSide == (getNumber (_groupClass >> "side"))) exitWith {_baseClass = _groupClass}; 
	};
};

if (isClass (_baseClass >> _faction)) then {
	_baseClass = (_baseClass >> _faction);
} else {
	//sample faction of single group to decide which group it belongs to
	//thanks BIS for calling it guerillas and not BLU_G_F (implemented workaround for now)
	if (_faction == "BLU_G_F") then {
		_baseClass = (_baseClass >> "Guerilla");
	};
};

for "_i" from 0 to (count _baseClass) - 1 do {
	_groupTypeClass = _baseClass select _i;
	if (isClass _groupTypeClass) then {
		for "_n" from 0 to (count _groupTypeClass) - 1 do {
			_groupClass = _groupTypeClass select _n;
			if (isClass _groupClass) then {
				_groupArr pushBack (configName _groupClass);
			};
		};
	};
};
_groupArr;
