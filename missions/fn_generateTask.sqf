private ["_class","_psn","_name","_marker","_mission","_allUnits","_objectives","_grp","_types","_obj"];
_class = _this;
_return = false;

_psn = [_class,"clearSpot",[1,1]] call BIS_fnc_returnConfigEntry;
_psn = _psn call fnc_FindClearSpot;

if (count _psn == 3) then {
    _marker = [_psn] call fnc_MissionMarker;
	_name = [_class,"descClass",""] call BIS_fnc_returnConfigEntry;

    ActiveAreas set [count ActiveAreas, _psn];
    ActiveMissions = ActiveMissions + 1;
    MissionCount = MissionCount + 1;
    _mission = format ["%1:%2",_name,MissionCount];

    [true, _mission, _name , getMarkerPos _marker, "assigned"] call BIS_fnc_taskCreate;

    _allUnits = [];
    _objectives = [];

	_limit = call compile str([_class,"PatrolCount",0] call BIS_fnc_returnConfigEntry);
	for [{_x=0},{_x<_limit},{_x=_x+1}] do {
		_grp = [_psn, 25 + random 50, 4 + floor random 3] call fnc_SpawnPatrol;
		_allUnits set [count _allUnits, _grp];
	};
	
	_types = [_class,"VehicleTypes",[]] call BIS_fnc_returnConfigEntry;

	_limit = call compile ([_class,"VehicleCount",0] call BIS_fnc_returnConfigEntry);
	//hint str(_limit);
    for [{_x=0},{_x<_limit},{_x=_x+1}] do {
        _obj = createVehicle [_types call BIS_fnc_SelectRandom, _psn, [], 4, "NONE"];
        _obj addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
        _obj setDir random 360;
		_obj call compile ([_class,"VehicleInit",""] call BIS_fnc_returnConfigEntry);
        _objectives set [count _objectives, _obj];
    };

	//TODO: Upgrade
    for "_i" from 1 to (1 + floor random 3) do {
        _allUnits set [count _allUnits, createVehicle ["Chemlight_red",_psn,[],4,"NONE"]];
    };

	//Task Creation Completed.
	
	//Task status monitoring
	sleep 10;
	while {{!isNull _x} count _objectives > 0} do {
		if ({alive _x} count _objectives == 0) exitWith {};
		sleep 5;
	};

	[_mission, "SUCCEEDED"] call BIS_fnc_taskSetState;
	deleteMarker _marker;

	sleep 5;
	ActiveAreas = ActiveAreas - [_psn];
	ActiveMissions = ActiveMissions - 1;
	ObjectivesCompleted = ObjectivesCompleted + 1;

	//Find safe area to respawn
	//[] spawn fnc_FindRespawnPos;

	waitUntil {
		sleep 60;
		(count ([_psn, 800] call fnc_CheckPlayers) == 0);
	};
	{
		switch (typeName _x) do {
			case "GROUP": {{deleteVehicle _x} forEach units _x};
			case "ARRAY": {{deleteVehicle _x} forEach _x};
			case "OBJECT": {deleteVehicle _x};
		};
	} forEach _allUnits;
    _return = true;
};
//Task complete, return
_return 