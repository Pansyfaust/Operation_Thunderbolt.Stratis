//GRP spawn fnc_LoopElite;
fnc_LoopElite = {
    private ["_grp","_lead","_list","_tgt","_behavior"];
    _grp = _this;
    EliteCount = EliteCount + 1;
    sleep 60;
    while {!isNull _grp} do {
        if ({alive _x} count units _grp > 0) then {
            _lead = leader _grp;
            _list = [_lead, 1000] call fnc_CheckPlayers;
            if (count _list < 1 AND unitReady _lead) then {
                {deleteVehicle _x} forEach units _grp;
                deleteGroup _grp;
                //DEBUGGING
                //if DEBUG then {hint "deleted"};
            } else {
                _tgt = [_grp] call fnc_ClosestTarget;
                _grp move (_tgt select 0);
                _behavior = if (_tgt select 1 > 200) then {["AWARE","GREEN"]} else {["STEALTH","YELLOW"]};
                _grp setBehaviour (_behavior select 0);
                _grp setCombatMode (_behavior select 1);
            };
        };
        sleep 60;
    };
    EliteCount = EliteCount - 1;
    hint "Elites -1";
};

//[LOCATION, spread, size of grp] call fnc_CreateElite;
fnc_CreateElite = {
    private ["_spawnPos","_spread","_size","_grp","_magazine","_magCount"];

    _spawnPos = _this select 0;
    _spread = if (count _this > 1) then {_this select 1} else {1};
    _size = if (count _this > 2) then {(_this select 2) max 4} else {4 + floor(random 3)};

    _grp = createGroup East;
    _grp createUnit ["O_Soldier_TL_F",_spawnPos,[],_spread,"FORM"];
    for "_i" from 1 to (_size - 1) do {
        _grp createUnit ["O_Soldier_F",_spawnPos,[],_spread,"FORM"];
    };

	/* AA Has been revised
    for "_i" from 1 to floor (_size / 4) do {
         ((units _grp) call BIS_fnc_selectRandom) call fnc_EquipAA;
    };
	*/
    
    {
        removeAllWeapons _x;
        removeHeadgear _x;
        removeUniform _x;
        removeVest _x;
        _x addHeadgear "H_MilCap_mcamo";
        _x addUniform "U_O_PilotCoveralls";
        _x addBackpack (["B_AssaultPack_rgr","B_AssaultPack_blk","B_AssaultPack_cbr",
                         "B_AssaultPack_mcamo","B_Kitbag_mcamo","B_Kitbag_cbr"] call BIS_fnc_selectRandom);
        _x addMagazines ["Minigrenade", 8];
        _x addWeapon "Binocular";
        _x addItem "FirstAidKit";
        _x addItem "FirstAidKit";
        if (leader _grp == _x) then {
            _x addMagazines ["1Rnd_HE_Grenade_shell", 10];
            _x addWeapon "arifle_TRG21_GL_F";
            _x addPrimaryWeaponItem "muzzle_snds_H";
        } else {
            switch (floor (random 6)) do {
                case 0: {    
                    _x addWeapon "LMG_Mk200_F";
                    _x addPrimaryWeaponItem "muzzle_snds_H_MG";                    
                };
                case 1: {    
                    _x addWeapon "srifle_EBR_F";                    
                    _x addPrimaryWeaponItem "muzzle_snds_B";
                    _x addPrimaryWeaponItem "optic_Arco";
                };
                default {    
                    _x addWeapon (["arifle_TRG20_F","arifle_TRG21_F"] call BIS_fnc_selectRandom);                    
                    _x addPrimaryWeaponItem "muzzle_snds_H";
                };
            };            
        };

        _magazine = (getArray (configFile >> "CfgWeapons" >> primaryWeapon _x >> "magazines")) select 0;
        _magCount = if  (primaryWeapon _x == "LMG_Mk200_F") then {5} else {15};
        _x addMagazines [_magazine, _magCount];
        reload _x;

        if (primaryWeapon _x != "srifle_EBR_F" AND random 10 > 1) then {
            _x addPrimaryWeaponItem (["optic_ACO_grn","optic_Hamr"] call BIS_fnc_selectRandom);
        };
        //if Use_NV then {_x addPrimaryWeaponItem "acc_pointer_IR"};
        [_x, True] call fnc_SetUnit;
    } foreach units _grp;

    _grp setFormation (["COLUMN",
                        "STAG COLUMN",
                        "WEDGE",
                        "ECH LEFT",
                        "ECH RIGHT",
                        "VEE",
                        "LINE",
                        "FILE",
                        "DIAMOND"] call BIS_fnc_selectRandom);
    
    _grp
};

//[units array] call fnc_SpawnElite;
fnc_SpawnElite = {
    private ["_list","_tgt","_spawnPos","_grp"];

    _list = if (isNil "_this") then {playableUnits} else {_this};
    _tgt = [_list,400,800] call fnc_FindPos;
    _spawnPos = _tgt select 0;
    _grp = grpNull;

    if (count _spawnPos > 0) then {
        _tgt = _tgt select 1;
        _grp = [_spawnPos] call fnc_CreateElite;
        _grp move _tgt;

        _grp enableAttack False;
        _grp setBehaviour "AWARE";
        //_grp setCombatMode "RED";
        //_grp setSpeedMode "FULL";

        [_grp,_spawnPos] spawn fnc_InfKillStuck;
        _grp spawn fnc_LoopElite;

        //DEBUGGING
        /*if DEBUG then {
            hint "elites spawned";
            [_grp, "ColorOrange"] execVM "scripts\debug_tracking.sqf";
        };*/
    };

    //Returns group if succeded, else grpNull
    _grp
};