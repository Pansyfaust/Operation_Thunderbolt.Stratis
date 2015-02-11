private ["_group","_count"];
_group = [_this,0] call bis_fnc_param;

_count = count units _group;

_count = ceil (_count/2) - 1;
_count = _count min 3; // Only count up to platoon size

"\a3\ui_f\data\map\Markers\NATO\group_" + str _count + ".paa"