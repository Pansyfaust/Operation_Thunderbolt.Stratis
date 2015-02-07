#define CARWAYPOINTS [[Car_North,95],[Car_Marina,105],[Car_KillFarm,200],[Car_Kamino,255],[Car_RuinsN,55], \
                      [Car_KaminoRuins,215],[Car_KaminoBay,320],[Car_LighthouseN,190],[Car_Airbase,105], \
                      [Car_Airbase2,10],[Car_AirbaseHill,140],[Car_AirbaseS,125],[Car_NisiBay,85], \
                      [Car_Tempest,80],[Car_Girna,135],[Car_StrogosBay,45],[Car_JayCove,60],[Car_Spartan,330], \
                      [Car_TsoukaliaN,330],[Car_LimariBay,330],[Car_Transmitter,65],[Car_TransmitterN,115]]

fnc_TaskManagerCar = {
    private ["_car","_oldPos","_driver","_tgt","_speed","_return","_dest","_velCar","_vecCar","_cargo","_dist"];

    _car = _this select 0;
    _oldPos = _this select 1;
    _tgt = effectiveCommander _car findNearestEnemy _car;
    _speed = -1;
    _return = False;

    if (isNull _tgt) then {
        if (unitReady _car) then {
            _car call fnc_RearmCar;
            while {True} do {
                _dest = getposATL ((CARWAYPOINTS call BIS_fnc_selectRandom) select 0);
                if ([_car,_dest] call fnc_Distance2D > 1000) exitWith {};
            };
            _car move _dest;
            _car setSpeedMode (["NORMAL","LIMITED","LIMITED"] call BIS_fnc_selectRandom);

            //DEBUGGING
            if DEBUG then {[_dest,"mil_destroy","ColorGreen",0.8] call fnc_DebugMarker};
        };
        
        if ([_car, Car_BRIDGE] call fnc_distance2D < 70) then {
            _car setBehaviour "ALERT";
            if (speed _car < 0.5) then {
                //_velCar = velocity _car;
                _vecCar = vectorDir _car;
                //_car setVelocity [_velCar select 0 + _vecCar select 0 * 3, _velCar select 1 + _vecCar select 1 * 3, _velCar select 2];
                _car setVelocity [(_vecCar select 0) * 3, (_vecCar select 1) * 3, 0];
                _return = True;
            };
        } else {
            _car setBehaviour "SAFE";
            if ([_oldPos, _car] call fnc_Distance2D < 1) then {_return = True};
        };
    } else {
        _car suppressFor 10;
        _cargo = assignedCargo _car;
        if (count _cargo > 0) then {
            _dist = [_tgt, _car] call fnc_Distance2D;
            if (_dist < 500) then {
                if (random _dist < 200) then {
                    {
                        _x leaveVehicle _car;
                        _x reveal [_tgt, _car knowsAbout _tgt];
                        [group _x, getposATL _tgt] spawn {
                            sleep 3;
                            (_this select 0) move (_this select 1);
                        };
                    } forEach _cargo;
                };
                _speed = [0,0,0,2,5] call BIS_fnc_selectRandom;
            };
        };
        if !(isOnRoad _car) then {_speed = 0};
    };

    _car forceSpeed _speed;

    //True if unit at same spot while not in combat, else False
    _return
};

fnc_LoopCar = {
    private ["_car","_grp","_oldPos","_stuckCount"];
    
    _car = _this;
    _grp = group driver _car;
    _oldPos = getposATL _car;
    _stuckCount = 0;
    
    CarCount = CarCount + 1;

    sleep 3;
    while {!isNull _grp AND vehicle leader _grp == _car} do {
        if ([_car, _oldPos] call fnc_TaskManagerCar) then {
            _stuckCount = _stuckCount + 1;
        } else {
            _stuckCount = 0;
        };
    
        if (_stuckCount >= 12) exitWith {
            {if (_x != gunner _car) then {doStop _x; _x leaveVehicle _car}} forEach crew _car;
    
            //DEBUGGING
            if DEBUG then {hint format ["STUCK!"]};
        };
    
        _oldPos = getposATL _car;
        sleep 5;
    };
    doStop units _grp;
    //Todo: delete the car
    
    sleep 60;
    CarCount = CarCount - 1;
};

fnc_LoopCarInf = {
    private ["_grp","_lead"];    
    _grp = _this;
    sleep 180;    
    while {!isNull _grp} do {
        _lead = leader _grp;
        if ({vehicle _x != _x} count units _grp == 0) then {
            if (_grp call fnc_DeleteInfantry) exitWith {};
        };
        sleep 120;
    };  
};

fnc_RearmCar = {
    private ["_car"];
    _car = _this;
    _car call TB_fnc_resupplyVehicle;
    if (count ([_car, 1000] call fnc_CheckPlayers) == 0) then {
        _car setDamage 0;
        {_x setDamage 0} forEach crew _car;
        if (count assignedCargo _car == 0 AND _car getVariable ["hasInfantry", false]) then {
            _car call fnc_CreateCarInf;
        };
    };
};

fnc_CarGetout = {
    private ["_unit","_car"];
    _unit = _this select 2;
    _car = _this select 0;

    _unit setBehaviour "AWARE";
    if (count crew _car == 0) then {
        _car call fnc_CleanVehicle;
        EmptyVehicles set [count EmptyVehicles, [_car, 1]];
    } else {
        if (random 1 < 0.2) then {_car fire "SmokeLauncher"};
    };
};

fnc_CarGMG = {
    private ["_car","_tgt"];
    _car = _this select 0;
    _car removeAllEventHandlers "Fired";
    _tgt = assignedTarget _car;
    for "_i" from 1 to (2 + round(random 4)) do {
        sleep 0.2;
        if (_car aimedAtTarget [_tgt] < 0.9) exitWith {};
        _car fire "GMG_40mm";
    };
    sleep 0.5;
    _car addEventHandler ["Fired", {_this spawn fnc_CarGMG}];    
};

fnc_CreateCarInf = {
    private ["_car","_grp","_classes","_unit"];
    _car = vehicle leader _this;
    _grp = createGroup East;
    _classes = [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"InfantryClasses",[]] call BIS_fnc_returnConfigEntry;

    for "_i" from 1 to (_car emptyPositions "Cargo") do {
        _unit = _grp createUnit [_classes call BIS_fnc_selectRandom,[0,0,0],[],1,"NONE"];
        _unit assignAsCargo _car;
        _unit moveInCargo _car;
        [_unit] call fnc_SetUnit;
        _unit addeventhandler ["HandleDamage", {if (_this select 4 == "") then {0} else {_this select 2}}];
    };
    _grp spawn fnc_LoopCarInf;
    _grp setBehaviour "CARELESS";
};

//call fnc_CreateCar
fnc_CreateCar = {
    private ["_points","_cars","_grp","_point","_spawnp","_nearList","_type","_car","_driver","_gunner"];

    scopeName "main";
    _points = +(_this select 0);
    _cars = if (count _this > 1) then {_this select 1} else {[(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"VehicleClasses",[]] call BIS_fnc_returnConfigEntry;};
    _car = objNull;

    while {count _points > 0} do {
        _point = floor random count _points;
        _spawnp = getposATL (_points select _point select 0);
        if (count (_spawnp nearEntities [["Man","Car_F"],4]) == 0) then {            
            _nearList = [_spawnp,1000] call fnc_CheckPlayers;
            if ([ATLToASL _spawnp,_nearList, 300] call fnc_IsHidden) then {
                _type = _cars call BIS_fnc_selectRandom;
                _car = createVehicle [_type, _spawnp, [], 0, "NONE"];
                _car setDir (_points select _point select 1);

                _grp = createGroup East;
                _driver = _grp createUnit ["O_Soldier_F",_spawnp,[],5,"NONE"];
                _driver assignAsDriver _car;
                _driver moveInDriver _car;
                _driver allowFleeing 0;

                if (_type != "O_MRAP_02_F") then {
                    _gunner = _grp createUnit ["O_Soldier_F",_spawnp,[],5,"NONE"];
                    _gunner assignAsGunner _car;
                    _gunner moveInGunner _car;
                };

                effectiveCommander _car setUnitRank "CORPORAL";
                _car addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
                _car addEventHandler ["GetOut", {_this call fnc_CarGetout}];
                if (_type == "O_Ifrit_GMG_F") then {_car addEventHandler ["Fired", {_this spawn fnc_CarGMG}]};
                _car addeventhandler ["HandleDamage", {if (_this select 4 == "") then {0} else {_this select 2}}];
                
                {
                    [_x] call fnc_SetUnit;
                    _x addeventhandler ["HandleDamage", {if (_this select 4 == "") then {0} else {_this select 2}}];
                } forEach crew _car; 

                if (_type == "O_MRAP_02_F" OR random 1 < 0.2) then {
                    _car call fnc_CreateCarInf;
                    _car setVariable ["hasInfantry", True, False];
                } else {
                    _car setVariable ["hasInfantry", False, False];
                };

                _grp spawn fnc_LoopCarInf;

                //DEBUGGING
                if DEBUG then {[_grp, "ColorPink"] execVM "scripts\debug_tracking.sqf"};

                breakTo "main";
            };
        };
        _points set [_point, objNull];
        _points = _points - [objNull];
    };

    //Returns the driver group created, else grpNull
    _car
};

//call fnc_SpawnCar;
fnc_SpawnCar = {
    private "_car";

    _car = [CARWAYPOINTS] call fnc_CreateCar;
    if (isNull _car) exitWith {};

    _car spawn fnc_LoopCar;
};