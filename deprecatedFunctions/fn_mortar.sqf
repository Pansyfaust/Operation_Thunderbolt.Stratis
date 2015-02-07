fnc_CleanMortar = {
    private "_mortar";
    _mortar = vehicle (_this select 0);
    _mortar setVehicleAmmo 0;
    _mortar addMagazine "8Rnd_82mm_Mo_shells";
    _mortar setVehicleAmmo random 1;
    MortarList = [MortarList, _mortar] call fnc_RemoveArrayItem;

    _mortar spawn {
        sleep 180;
        while {!(_this call fnc_DeleteUnit)} do {sleep 60};
    };

    //DEBUGGING
    //if DEBUG then {hint format ["Mortars:\n%1",MortarList]};
};

fnc_RearmMortar = {
    private "_mortar";
    _mortar = _this select 0;
    if !(someAmmo _mortar) then {
        _mortar spawn {
            sleep 30;
            _this addMagazine "8Rnd_82mm_Mo_shells";
            reload _this;
            //_this setVehicleAmmo 0.25;
        };
    };    
};

fnc_ClusterMortar = {
    private ["_shell","_psn","_vel"];
    _shell = _this select 6;
    sleep 5;
    _psn = getposASL _shell;
    _vel = velocity _shell;
    deleteVehicle _shell;
    _shell = createVehicle ["Cluster_120mm_AMOS", [-1000,-1000,1000], [], 100, "NONE"];    
    _shell setposASL _psn;
    _shell setVelocity _vel;    
};

fnc_CreateMortar = {
    private ["_points",
             "_point",
             "_spawnp",
             "_list",
             "_mortar"];

    scopeName "main";
    _points = [mortar_1,mortar_2,mortar_3,mortar_4,mortar_5,mortar_6,mortar_7,mortar_8,mortar_9,mortar_10,mortar_11,mortar_12];

    while {count _points > 0} do {
        _point = _points call BIS_fnc_selectRandom;
        _spawnp = getposATL _point;
        if (count (_spawnp nearEntities [["Man","StaticWeapon"],2]) == 0) then {            
            _list = [_spawnp,1000] call fnc_CheckPlayers;
            if ([ATLtoASL _spawnp, _list, 300] call fnc_IsHidden) then {
                _mortar = [_spawnp, random 360, "O_Mortar_01_F", East] call BIS_fnc_spawnVehicle;
                _mortar = _mortar select 0;
                _mortar setCombatMode "GREEN";
                _mortar setVehicleAmmo 0.5;
                _mortar addEventHandler ["Fired",{_this call fnc_RearmMortar}];
                _mortar addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];

                [gunner _mortar] call fnc_SetUnit;
                gunner _mortar addEventHandler ["Killed",{_this call fnc_CleanMortar}];
                MortarList set [count MortarList, _mortar];

                if (Diff_Level == 7) then {
                    _mortar addEventHandler ["Fired",{_this spawn fnc_ClusterMortar}];
                };

                //DEBUGGING
                if DEBUG then {
                    hint format ["%1",_mortar];
                    hint format ["Mortars:\n%1",MortarList];
                    [_spawnp,"mil_start","ColorRed",0.5] call fnc_DebugMarker;
                };
				
                breakTo "main";
            };
        };
        _points = [_points, _point] call fnc_RemoveArrayItem;
    };    
};

fnc_Mortar = {
    //Close:    36 to 499m, 14 to 10s, spread 7
    //Medium:   142 to ~2000m, 28 to 21s, spread 15
    //Far:      284 to ~4000m, 40 to 30s, spread 21

    private ["_enemies","_checked","_return","_mortar","_tgt","_enemy","_enemyRange","_enemyPos","_list"];
    _enemies = _this;
    _checked = [];
    _return = False;

    {
        _mortar = _x;
        _tgt = [];

        if (someAmmo _mortar) then {
            scopeName "mortar_loop";
            {
                scopeName "enemy_loop";    
                _enemy = _x;
                _enemyRange = _mortar distance _enemy;
                _enemyPos = getposATL _enemy;
    
                //Quick check if the target is close and low enough first
                if (_enemyRange <= 1800 AND _enemyPos select 2 <= 15) then {
                    if (20 / (speed _enemy max 0.01) > _mortar getArtilleryETA [_enemyPos, "8Rnd_82mm_Mo_shells"]) then {
                        if !(_enemy in _checked) then {
                            _list = (_enemyPos) nearEntities [["AllVehicles"], 100];
        
                            //DEBUGGING
                            //if DEBUG then {[format ["%1", _list],0,-(safezoneH-3.2)/2,6,0.5,0,9] spawn bis_fnc_dynamicText};
        
                            {if (side _x == East) then {breakTo "enemy_loop"}} forEach _list;
                            _checked set [count _checked,_enemy];
                        };    
                        _tgt = _enemyPos;
                        breakTo "mortar_loop"
                    };
                };
            } forEach _enemies;
            
            if (count _tgt == 3) then
            {
                _tgt = [_tgt, random 360, 0, 60, _tgt select 2, False] call fnc_NearPoint;
                _mortar doWatch _tgt;
                _mortar commandArtilleryFire [_tgt, "8Rnd_82mm_Mo_shells", 1];
                _return = True;
    
                //DEBUGGING
                /*if DEBUG then {
                    [_tgt,"mil_dot","ColorWhite",0.5] call fnc_DebugMarker;
                    hint format["%1m FIRING!", _mortar distance _tgt];
                };*/
            };
        };
    } forEach MortarList;

    //True if any mortar fired, else False
    _return
};