fnc_LoopAttack = {
    private ["_grp","_lead","_tgt"];

    _grp = _this;
    
    sleep 60;
    while {!isNull _grp} do {
        _lead = leader _grp;
        if (vehicle _lead == _lead) exitWith {};
        sleep 10;
    };
    
    while {!isNull _grp} do {
        _lead = leader _grp;
        if (count Targets == 0) exitWith {
            [_grp, getposATL _lead, 200 + random 200] call fnc_AssignPatrol;
        };    
        _tgt = [_lead, Targets] call fnc_Closest;
        if (_tgt select 1 <= 500) then {
                _grp move getposATL (_tgt select 0);
        };
        sleep 60;
    };
    
    sleep 60;
    while {!isNull _grp} do {
        _lead = leader _grp;
        if (vehicle _lead == _lead) then {
            if (_grp call fnc_DeleteInfantry) exitWith {};
        };
        sleep 60;
    };

};

//call fnc_SpawnAttack;
fnc_SpawnAttack = {
    private ["_tgt","_spawnPos","_grp"];

    _tgt = [Targets,300,600] call fnc_FindPos;
    _spawnPos = _tgt select 0;
    _grp = grpNull;

    if (count _spawnPos > 0) then {
        _tgt = _tgt select 1;
        _grp = [_spawnPos, 1, 6 + floor(random 5)] call fnc_CreateRegular;
        _grp move _tgt;

        if (random 1 < 0.5) then {_grp enableAttack False};
        _grp setBehaviour "AWARE";
        //_grp setCombatMode "RED";
        //_grp setSpeedMode "FULL";

        [_grp,_spawnPos] spawn fnc_InfKillStuck;
        _grp spawn fnc_LoopAttack;

        //DEBUGGING
        /*if DEBUG then {
            hint "attackers spawned";
            [_grp, "ColorOPFOR"] execVM "scripts\debug_tracking.sqf";
        };*/
    };

    //Returns group if succeded, else grpNull
    _grp
};