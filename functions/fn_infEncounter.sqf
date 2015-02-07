fnc_LoopEncounter = {
    private "_grp";
    _grp = _this;
    EncounterCount = EncounterCount + 1;
    
    sleep 15;
    _grp setBehaviour "SAFE";
    sleep 60 + random 120;            
    while {!isNull _grp} do {
        if (_grp call fnc_DeleteInfantry) exitWith {};
        sleep 60;
    };
    
    sleep (7-Diff_Level) * 30;
    EncounterCount = EncounterCount - 1;
    //if DEBUG then {hint "Encounter -1"};
};

//call fnc_SpawnEncounter;
fnc_SpawnEncounter = {
    private ["_list","_spawnPos","_grp"];

    _list = if isMultiplayer then {playableUnits} else {switchableUnits};
    _mode = if (random 1 < 0.05) then {0} else {1};
    _spawnPos = ([_list,300,600,_mode] call fnc_FindPos) select 0;
    _grp = grpNull;

    if (count _spawnPos > 0) then {
        _grp = [_spawnPos, 1, 4 + floor(random 3)] call fnc_CreateRegular;        
        [_grp, _spawnPos, 100 + random 200] call fnc_AssignPatrol;

        if (random 1 < 0.9) then {_grp enableAttack False};

        //Kill any stuck guys
        _grp setBehaviour "AWARE";
        [_grp,_spawnPos] spawn fnc_InfKillStuck;

        //DEBUGGING
        /*if DEBUG then {
            hint "encounter spawned";
            [_grp,"ColorRed"] execVM "scripts\debug_tracking.sqf";
        };*/

        _grp spawn fnc_LoopEncounter;
    };

    //Returns group if succeded, else grpNull
    _grp
};