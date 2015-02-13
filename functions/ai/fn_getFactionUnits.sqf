/*
    Search through CfgVehicle and CfgGroup and return every class that is scope=2
    and is part of one of the factions that the argument includes

    0: POSITION 2D          - array of STRING faction names

    return: ARRAY           - array of [[CfgGroup classes],[CfgVehicle classes]]
*/

private ["_factions"];
_factions = [_this, 0, [], [[]]] call BIS_fnc_param;