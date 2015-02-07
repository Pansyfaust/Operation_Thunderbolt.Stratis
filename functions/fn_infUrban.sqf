fnc_LoopUrbanPatrol = {
    private ["_grp","_list","_isSafe","_psn"];
    _grp = _this select 0;
    _list = _this select 1;

    _grp setCombatMode "RED";
    while {!isNull _grp} do {
        _isSafe = if (isNull (leader _grp findNearestEnemy leader _grp)) then {True} else {False};
        {
            if !(_isSafe) then {
                doStop _x;
            } else {
                if (alive _x AND speed _x < 1) then {
                    _psn = _list call BIS_fnc_selectRandom;
                    _x doMove _psn;
                };
            };
            _x forceWalk _isSafe;
        } forEach units _grp;
        sleep 10;
    };
};

fnc_EquipUrban = {
    private ["_unit","_items"];
    _unit = _this;
    _items = [];
    
    removeHeadgear _unit;
    _unit addHeadgear "H_Booniehat_khk";

    if (getText (configFile >> "cfgVehicles" >> typeOf _unit >> "displayName") != "Rifleman (Light)") then {
        _items = vestItems _unit;
        removeVest _unit;
        _unit addVest "V_TacVest_brn";
    };

    if (backpack _unit != "") then {
        if (isNil "_items") then {
            _items = backpackItems _unit;
        } else {
            {_items set [count _items, _x]} forEach backpackItems _unit;
        };
        removeBackpack _unit;
        _unit addBackpack (["B_FieldPack_oucamo","B_Carryall_oucamo"] call BIS_fnc_selectRandom);
    };
    
    {
        if (getText (configFile >> "CfgMagazines" >> _x >> "displayname") != "") then {
            _unit addMagazine _x;
        } else {
            _unit addItem _x;
        }
    } forEach _items;
};

//[LOCATION, RADIUS, number to fill, patrol chance, special camo chance, percent to fill, units to fill with] call fnc_CreateGarrison;
//[player, 100, 20, 1, 1] call fnc_CreateGarrison;
fnc_CreateGarrison = {
    private ["_psn","_radius","_count","_patrolPercent","_camoChance","_percent","_unitTypes","_buildings","_list",
             "_patrolList","_building","_i","_limit","_return","_patrolGrp","_buildPos","_unit","_grp"];

    _psn = _this select 0;
    if (typeName _psn == "OBJECT") then {_psn = getposATL _psn};
    _radius = _this select 1;
    _count = if (count _this > 2) then {_this select 2} else {10};
    _patrolPercent = if (count _this > 3) then {_this select 3} else {0.2};
    _camoChance = if (count _this > 4) then {_this select 4} else {0.2};
    _camoChance = if (random 1 < _camoChance) then {True} else {False};
    _percent = if (count _this > 5) then {_this select 5} else {1};
    _unitTypes = if (count _this > 6) then {_this select 6} else {["O_Soldier_F",
                                                                   "O_Soldier_F",
                                                                   "O_Soldier_AT_F",
                                                                   "O_Soldier_AR_F",
                                                                   "O_Soldier_AR_F",
                                                                   "O_Soldier_GL_F",
                                                                   "O_Soldier_M_F",
                                                                   "O_Medic_F",
                                                                   "O_Soldier_Repair_F",
                                                                   "O_Soldier_Lite_F",
                                                                   "O_Soldier_Exp_F"]};

    _buildings = nearestObjects [_psn, ["House"], _radius];
    _list = [];
    _patrolList = [];
    {
        _building = _x;
        _i = 0;
        
        //Don't patrol piers since they like to get stuck
        //"Land_Pier_F","Land_Pier_addon","Land_Pier_Box_F"
        if !(toLower (typeOf _building) in ["land_pier_small_f","land_nav_pier_m_f"]) then {
            while {str (_building buildingPos _i) != str [0,0,0]} do {
                _list set [count _list, _building buildingPos _i];       
                _i = _i + 1;
            };
        };
    } forEach _buildings;
    _patrolList = +_list;
    _limit = count _list;
    _limit = _limit - (_limit * _percent);

    _return = [];
    _grp = createGroup East;
    _patrolGrp = createGroup East;
    for "_men" from 1 to _count do {
        if (count _list <= _limit) exitWith {};
        _i = floor random count _list;
        _buildPos = _list select _i;
        _list set [_i, objNull];
        _list = _list - [objNull];

        if (random 1 < _patrolPercent) then {
            _unit = _patrolGrp createUnit [_unitTypes call BIS_fnc_selectRandom,[0,0,0],[],0,"NONE"];
            _unit setPosATL _buildPos;
            doStop _unit;
            _buildPos = _patrolList call BIS_fnc_selectRandom;
            _unit doMove _buildPos;
            _unit setBehaviour "SAFE";
            _unit forcespeed 2;
        } else {
            if (count units _grp >= 4) then {
                _grp enableAttack False;
                _grp = createGroup East;
            };
            _unit = _grp createUnit [_unitTypes call BIS_fnc_selectRandom,[0,0,0],[],0,"NONE"];
            _unit setPosATL _buildPos;
            _unit setUnitPos (["UP","UP","MIDDLE"] call BIS_fnc_selectRandom);
            //if (random 3 < 2) then {_unit disableAI "TARGET"};
            _unit setFormDir random 360;
            _unit setDir random 360;
            doStop _unit;
        };

        [_unit] call fnc_SetUnit;
        _unit addeventhandler ["HandleDamage", {if (_this select 4 == "") then {0} else {_this select 2}}];
        if (_camoChance) then {_unit call fnc_EquipUrban};
        _return set [count _return, _unit];
    };

    _grp enableAttack False;
    if (count units _patrolGrp > 0) then {
        [_patrolGrp, _patrolList] spawn fnc_LoopUrbanPatrol;
    } else {
        deleteGroup _patrolGrp;
    };

    //Returns list of units, else empty array
    _return
};