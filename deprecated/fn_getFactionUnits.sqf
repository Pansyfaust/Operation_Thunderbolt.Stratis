/*
    Search through CfgVehicles and CfgGroups and return every class that is scope=2
    and is part of one of the factions that the argument includes

    0: ARRAY          		- array of STRING faction names

    return: ARRAY           - array of [[CfgGroups classes],[CfgVehicles classes]]
*/

private ["_factions", "_units"];
_factions = [_this, 0, [], [[]]] call BIS_fnc_param;
_groups = [];
_vehicles = [];
{
	_groups = _groups + (_x call TB_fnc_getFactionGroups);
	_vehicles = _vehicles + (_x call TB_fnc_getFactionVehicles); 
}forEach _factions;

[_groups,_vehicles]