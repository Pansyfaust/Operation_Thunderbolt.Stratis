// Selected a random category defined in aiFactions from the table
private ["_table","_spawnArray"];
_table = _this select 0;
_spawnArray = [_table, 2] call TB_fnc_weightedRandom;

// Select a random vehicle/group
private ["_category","_spawnList","_spawnClassArray"];
_category = _spawnArray select 0;
_spawnList = _spawnArray select 1;
_spawnClassArray = _spawnList call BIS_fnc_selectRandom;

// Select the classname and cost
private ["_spawnClass","_spawnCost"];
_spawnClass = _spawnClassArray select 0;
_spawnCost = _spawnClassArray select 1;

// Get some information from the category
private ["_isGroup","_spawnMethods","_scripts"];
_isGroup = [_category, "isGroup", 0] call BIS_fnc_returnConfigEntry; // not used
_spawnMethods = [_category, "spawnMethods", []] call BIS_fnc_returnConfigEntry;
_scripts = [_category, "scripts", []] call BIS_fnc_returnConfigEntry;

// If we fail, return a null group
private "_grp";
_grp = grpNull;

// Spawn the group using aiSpawning classes starting from the first one
{
    private ["_method","_size","_positionFunction","_spawnFunction","_maxAttempts"];
    _method = missionConfigFile >> "CfgThunderbolt" >> "aiSpawning" >> _x;
    _size = [_method, "size"] call BIS_fnc_returnConfigEntry;
    if (typeName _size == typeName "") then {_size = call compile _size};
    _positionFunction = [_method, "positionFunction"] call BIS_fnc_returnConfigEntry;
    _spawnFunction = [_method, "spawnFunction"] call BIS_fnc_returnConfigEntry;
    _maxAttempts = [_method, "maxAttempts"] call BIS_fnc_returnConfigEntry;

    for "_i" from 1 to _maxAttempts do
    {
        private "_psn";
        _psn = _size call compile _positionFunction;
        // If we get a position, spawn
        if !(_psn isEqualTo []) exitWith
        {
            _grp = [_spawnClass, _psn] call compile _spawnFunction;
            // Pass any scripts to the created group
            {_grp spawn compile _x; true} count _scripts;
            true;
        };
    };
} count _spawnMethods;

[_grp, _spawnCost]