HELIWP = call TB_fnc_generateWaypoints;

fnc_LoopHeli = {
    private ["_heli","_patrol","_noDAGR","_dest","_pilot","_height","_heliVel"];
    _heli = vehicle (_this select 0);
    _patrol = _this select 1;
    if (_patrol) then {_dest = _heli};
    _pilot = driver _heli;
    HeliCount = HeliCount + 1;
    
    sleep 30;
    while {!isNull group _heli} do {
        if (!canMove _heli OR !isEngineOn _heli) exitWith {};

        if (_patrol) then {
            if ([_heli, _dest] call fnc_Distance2D < 200) then {
                _noDAGR = True;
                {
                    if (toLower _x == "12rnd_pg_missiles") exitWith {_noDAGR = False};
                } forEach magazines _heli;
                if (damage _heli > 0 OR _noDAGR) then {
                    _heli call fnc_RearmHeli;
                };
                waitUntil {
                    _dest = HELIWP call BIS_fnc_selectRandom;
                    ([_heli, _dest] call fnc_Distance2D > 2000)
                };
                _dest = [_dest, random 360, 0, 500] call fnc_NearPoint;
                _heli move _dest;
                _heli setSpeedMode (["LIMITED","LIMITED","NORMAL"] call BIS_fnc_selectRandom);
                _heli setFuel 1;
            };
        };

        _height = getposATL _heli select 2;
        if (_height > 20) then {
            _heli setCombatMode "RED";
            sleep 1;
        } else {
            _heliVel = velocity _heli;
            //Can experiment with [_heli, PITCH, BANK] call BIS_fnc_setPitchBank;
            _heli setVelocity [(_heliVel select 0), (_heliVel select 1), (_heliVel select 2) + 0.05 * (20 - _height)];
            _heli setCombatMode "BLUE";
            sleep 0.01;
        };
        //hint format ["%1\n%2",getposATL _heli select 2, _heliVel select 2];
        //hint format ["%1", vectorDir _heli select 2];
    };
    _pilot setDamage 1;
    sleep random 5;
    _heli setDamage 1;

    sleep 60;
    HeliCount = HeliCount - 1;
};

fnc_getAttackHelo = {
	_helo = [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"AttackHeloClasses",[]] call BIS_fnc_returnConfigEntry;
	_helo = _helo call BIS_fnc_selectRandom;
	_helo
};

fnc_getTransportHelo = {
	_helo = [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"TransportHeloClasses",[]] call BIS_fnc_returnConfigEntry;
	_helo = _helo call BIS_fnc_selectRandom;
	_helo
};

//HELI call fnc_EquipAttackHeli;
fnc_EquipAttackHeli = {
    private "_heli";
    _heli = _this;
    _heli lock 2;
    _heli addMagazines ["12Rnd_PG_missiles", Diff_Level - 1];
    //_heli addeventhandler ["Fired",{_this spawn fnc_HeliFired}];
    _heli addeventhandler ["IncomingMissile",{_this spawn fnc_HeliFlares}];
};

fnc_HeliFired = {
    private "_heli";
    _heli = _this select 0;    
    if (_this select 1 == "LMG_Minigun_heli") then {
        _heli removeAllEventHandlers "Fired";
        _heli spawn {
            private "_tgt";
            _this setVariable ["isFiring", True, False];
            _tgt = assignedTarget _this;
            while {_this aimedAtTarget [_tgt] > 0.9} do {
                driver _this forceWeaponFire ["missiles_DAGR", "Burst"];
                HQ action ["USEWEAPON", _this, driver _this, 5];
                //why is this not burst firing?
                sleep 0.02;
            };
            sleep 0.3;
            _this addEventHandler ["Fired", {_this call fnc_HeliFired}];
        };
    };
};

/*terminate TEMP;
TEMP = [] spawn {
    while {True} do {
        TGT = assignedTarget heli1;
        if (isNull TGT) then {
            sleep 2
        } else {
            if (heli1 aimedAtTarget [TGT,"missiles_DAGR"] > 0.8) then {
                if (vehicle TGT isKindof "man") then {
                    driver heli1 forceWeaponFire ["missiles_DAGR", "Burst"]
                } else {
                    heli1 fireAtTarget [TGT,"missiles_DAGR"]
                }
            };
            if (heli1 aimedAtTarget [TGT,"LMG_Minigun_heli"] > 0.5) then {
                HQ action ["USEWEAPON", heli1, driver heli1, 5]
            };
            hintsilent format ["%1",TGT];
            sleep 0.02
        }
    }
}*/

fnc_HeliFlares = {
    private ["_heli","_tgt"];
    _heli = _this select 0;
    _tgt = _this select 2;
    _heli reveal [_tgt, 4];
    _heli doTarget _tgt;
    sleep random 0.5;
    for "_i" from 1 to 2 + round random 4 do {
        driver _heli forceWeaponFire ["CMFlareLauncher", "Burst"];
        sleep 0.1;
    };
};

fnc_RearmHeli = {
    private "_heli";
    _heli = vehicle _this;
	_heli call TB_fnc_resupplyVehicle;
    if (count ([_heli, 2000] call fnc_CheckPlayers) == 0) then {
        _heli setDamage 0;
        driver _heli setDamage 0;
    };
};

//[target obj] call fnc_SpawnHeli;
fnc_SpawnHeli = {
    private ["_spawnPos","_dir","_patrol","_tgt","_heliArray","_heli","_grp","_wp","_total_wp","_exitPos","_wp2"];

    if (isNil "_this") then {
        _spawnPos = ((random 360) call TB_fnc_offMapPos);
        _dir = [_spawnPos, Center] call fnc_DirTo;
        _patrol = True;        
    } else {
		if (typeName _this == "ARRAY") then {
			_this = _this call BIS_fnc_selectRandom;
		};
        _tgt = getposATL _this;
        _spawnPos = _tgt call TB_fnc_offMapPos;
        _dir = [_spawnPos, _tgt] call fnc_DirTo;
        _patrol = false;
    };

    //Create Kasatka
    _spawnPos = [_spawnPos, random 360, 20, 200] call fnc_NearPoint;
    _heliArray = [_spawnPos, _dir, call fnc_getAttackHelo, East] call BIS_fnc_spawnVehicle;
    
    
    _heli = _heliArray select 0;
    _heli flyInHeight 150;   
    _heli call fnc_EquipAttackHeli;
    _heli addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
    [_heli, 0.5] call fnc_ReduceDamage;
    
    {[_x, True] call fnc_SetUnit} forEach (_heliArray select 1);
    [driver _heli, 0.1] call fnc_ReduceDamage;
    
    _grp = _heliArray select 2;
    _grp setCombatMode "RED";

    if (_patrol) then {
    _wp = HELIWP call BIS_fnc_selectRandom;
    _grp move ([_wp, random 360, 0, 500] call fnc_NearPoint);
    } else {
        //Direct attack
        _wp = _grp addWaypoint [_tgt, 10];
        _wp setWaypointType "SAD";

        _exitPos = _tgt call TB_fnc_offMapPos;
        _wp2 = _grp addWaypoint [_exitPos, 200];
        _wp2 setWaypointType "MOVE";
        _wp2 setWaypointStatements ["True", "this spawn fnc_RemoveVehicle"];
        _wp2 setWaypointCompletionRadius 100;
    };

    [_heli,_patrol] spawn fnc_LoopHeli;

    //DEBUGGING
    if DEBUG then {
        //[group _heli,"ColorBlack"] execVM "scripts\debug_tracking.sqf";
        _heli execVM "scripts\debug_heli.sqf";
    };

    //Return the heli
    _grp
};

//[TARGET OBJ, heli type, patrol radius, min land dist, max land dist, patrol pos] call fnc_SpawnHeliInf;
fnc_SpawnHeliInf = {
    private ["_psn","_type","_patrolRadius","_minRadius","_maxRadius","_patrolPos","_heliType","_grp","_tgt",
             "_spawnPos","_dir","_heliArray","_heli","_heliGrp","_helipad","_wp1","_wpA","_exitPos","_wp2"];

    _psn = getposATL (_this select 0);
    _type = if (count _this > 1) then {_this select 1} else {0};
    _patrolRadius = if (count _this > 2) then {_this select 2} else {0};
    _minRadius = if (count _this > 3) then {_this select 3} else {200};
    _maxRadius = if (count _this > 4) then {_this select 4} else {350};
    _patrolPos = if (count _this > 5) then {_this select 5} else {_psn};

    _heliType = if (_type == 0) then {call fnc_getTransportHelo} else {call fnc_getAttackHelo};
    _grp = grpNull;

    for "_tries" from 1 to 20 do {
        _tgt = [_psn, random 360, _minRadius, _maxRadius] call fnc_NearPoint;

        //DEBUGGING
        //if DEBUG then {[_tgt, "mil_dot", "ColorWhite"] call fnc_DebugMarker};

        //findEmptyPosition seems to take way too long
        _tgt = _tgt isFlatEmpty [12,50,0.4,12,0,False];

        if (count _tgt == 3) exitWith {
            _spawnPos = _tgt call TB_fnc_offMapPos;
            _spawnPos = [_spawnPos, random 360, 20, 200] call fnc_NearPoint;
            _dir = [_spawnPos, _tgt] call fnc_dirTo;

            _heliArray = [_spawnPos , _dir, _heliType, East] call BIS_fnc_spawnVehicle;
            _heli = _heliArray select 0;
            _heliGrp = _heliArray select 2;

            _heli lock 2;
            _heli flyInHeight 50;
            if (_type > 0) then {_heli call fnc_EquipAttackHeli};
            _heli addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
            [_heli, 0.5] call fnc_ReduceDamage;
            _heliGrp setCombatMode "BLUE";
            _heliGrp setBehaviour "CARELESS";

            {[_x, True] call fnc_SetUnit} forEach (_heliArray select 1);
            [driver _heli, 0.01] call fnc_ReduceDamage;
        
            if (_type == 2) then {
                _grp = [[0,0,0],1,8] call fnc_CreateElite;
            } else {
                _grp = [[0,0,0],1,8] call fnc_CreateRegular;
            };

            {_x moveInCargo _heli} forEach units _grp;
        
            _helipad = createVehicle ["Land_HelipadEmpty_F",[0,0,0],[],0,"NONE"];
            _helipad setposASL _tgt;
            [_helipad,_heliGrp] spawn {
                sleep 180;
                while {!isnull (_this select 1)} do {sleep 60};
                deleteVehicle (_this select 0);
            };

            _wp1 = _heliGrp addWaypoint [_helipad, 0];
            _wp1 setWaypointType "TR UNLOAD";
            _wp1 setWaypointStatements ["True", "this flyInHeight 150; [this,False] spawn fnc_LoopHeli"];

            if (_type > 0) then {
                _wpA = _heliGrp addWaypoint [_tgt, 10];
                _wpA setWaypointType "SAD";
                _wpA setWaypointBehaviour "COMBAT";
                _wpA setWaypointCombatMode "RED";
            };

            _exitPos = _tgt call TB_fnc_offMapPos;
            _wp2 = _heliGrp addWaypoint [_exitPos, 200];
            _wp2 setWaypointType "MOVE";
            _wp2 setWaypointStatements ["True", "this spawn fnc_RemoveVehicle"];
            _wp2 setWaypointCompletionRadius 100;

            _grp enableAttack False;
            _grp setBehaviour "AWARE";

            if (_patrolRadius > 0) then {
                [_grp, _tgt, _patrolRadius] call fnc_AssignPatrol;
            } else {
                _grp spawn fnc_LoopAttack;
            };
        
            //DEBUGGING
            if DEBUG then {
                hint format ["Heli infantry spawned\nTries: %1",_tries];
                _temp = createVehicle ["Sign_Sphere100cm_F",_tgt,[],0,"NONE"];
                _temp setposASL _tgt;
                [_tgt, "mil_triangle", "ColorPink"] call fnc_DebugMarker;
            };
        };
    };

    //Returns INFANTRY group if succeded, else grpNull
    _grp
};