fnc_ReloadAA = {
    if (_this select 1=="launch_RPG32_F") then {
        _this select 0 addMagazine (_this select 5);
    };
};

//UNIT call fnc_EquipAA;
fnc_EquipAA = {
    private "_unit";
    _unit = _this;
    /*if(backpack _unit == "") then {
        _unit addBackpack (["B_AssaultPack_rgr","B_AssaultPack_dgtl",
                            "B_AssaultPack_blk","B_AssaultPack_cbr",
                            "B_AssaultPack_mcamo","B_Kitbag_mcamo",
                            "B_Kitbag_cbr","B_FieldPack_ocamo",
                            "B_Carryall_ocamo"] call BIS_fnc_selectRandom);
    };*/
    //V_TacVest_oli
    //H_Cap_headphones
    _unit removeWeapon "launch_RPG32_F";
    _unit removeMagazines "RPG32_F";
    _unit addMagazines [["RPG32_AA_F","RPG32_F"] call BIS_fnc_selectRandom, 2];
    _unit addWeapon "launch_RPG32_F";
    _unit removeAllEventHandlers "Fired";
    _unit addEventHandler ["Fired", {_this call fnc_ReloadAA}];
};

fnc_InfLights = {
    private "_unit";
    _unit = _this select 0;
    _unit removeAllEventHandlers "FiredNear";
    sleep 4 + random 6 - Diff_Level;
    _unit enableGunLights "forceOff";
};

fnc_InfKillStuck = {
    private ["_grp","_posn"];
    _grp = _this select 0;
    _posn = _this select 1;
    sleep 10;
    {
        if (_x distance _posn < 5) then {_x setDamage 1};
    }forEach units _grp;  
};

//UNIT call fnc_SetUnit;
fnc_SetUnit = {
    private ["_unit","_elite","_bonus","_className","_usesGL"];

    _unit = _this select 0;
    _elite = if (count _this > 1) then {_this select 1} else {False};
    _className = gettext (configFile >> "cfgVehicles" >> typeOf _unit >> "displayName");
    _usesGL = _className in ["Grenadier","Squad Leader","Team Leader"];

    if (_elite) then {
        _bonus = Diff_Level / 20;
        _unit setSkill 0.8;
		/* TODO: FIX
        if (!AI_NV AND random 8 > Diff_Level) then {
            _unit unassignItem "NVGoggles";
            _unit removeItem "NVGoggles";
        };
		*/
    } else {
        _bonus = 0;
        switch (Diff_Level) do {
            case 0: {_unit setSkill 0.5};
            case 1: {_unit setSkill 0.55};
            case 2: {_unit setSkill 0.65};
            case 3: {_unit setSkill 0.70};
            case 4: {_unit setSkill 0.75};
            default {_unit setSkill 0.8};
        };
		/* TODO: FIX
        if !(AI_NV) then {
            _unit unassignItem "NVGoggles";
            _unit removeItem "NVGoggles";
            _unit addPrimaryWeaponItem "acc_flashlight";
            _unit enableGunLights "forceOn";
            _unit addEventHandler ["FiredNear",{_this spawn fnc_InfLights}];
        };
		*/
        if (_className != "Marksman") then {
            {_unit removePrimaryWeaponItem _x} forEach ["optic_ACO_grn","optic_Holosight","optic_Arco"];
            if (random 4 > 1) then {
                _unit addPrimaryWeaponItem (["optic_ACO_grn","optic_Holosight","optic_Arco"] call BIS_fnc_selectRandom);
            };
        };
        switch (_className) do {
            case "Squad Leader": {_unit setUnitRank "SERGEANT"};
            case "Team Leader": {_unit setUnitRank "LIEUTENANT"};
            //case "Rifleman (AT)": {_unit call fnc_EquipAA};
        };
    };

    if (random 10 > Diff_Level) then {_unit enableIRLasers True};

    /*You’ll probably notice that in firefights, you are often being shot at but not killed instantly.
    This is the way we would like to go. Before, the AI was really deadly.
    This is definitely not to say that Arma 3 isn’t challenging anymore, it’s mostly less frustrating.*/
    //Oh BIS!
    _unit setSkill ["aimingAccuracy", (AI_AimAccuracy + _bonus) min 1];
    _unit setSkill ["aimingShake", (AI_AimShake + _bonus) min 1];
    _unit setSkill ["aimingSpeed", (AI_AimSpeed + _bonus) min 1];
    _unit setSkill ["spotDistance", (AI_SpotDistance + _bonus) min 1];
    _unit setSkill ["spotTime", (AI_SpotTime + _bonus) min 1];
    _unit allowFleeing 0;

    if (_usesGL) then {
        {_unit removeMagazines _x;} forEach ["1Rnd_Smoke_Grenade_shell",
                                            "1Rnd_SmokeRed_Grenade_shell",
                                            "1Rnd_SmokeGreen_Grenade_shell",
                                            "1Rnd_SmokeYellow_Grenade_shell",
                                            "1Rnd_SmokePurple_Grenade_shell",
                                            "1Rnd_SmokeBlue_Grenade_shell",
                                            "1Rnd_SmokeOrange_Grenade_shell"];
        if (random 1 < 0.1) then {
            switch (floor random 12) do {
                case 0: {_unit addMagazine "1Rnd_SmokeRed_Grenade_shell"};
                case 1: {_unit addMagazine "1Rnd_SmokeGreen_Grenade_shell"};
                case 2: {_unit addMagazine "1Rnd_SmokeYellow_Grenade_shell"};
                case 3: {_unit addMagazine "1Rnd_SmokePurple_Grenade_shell"};
                case 4: {_unit addMagazine "1Rnd_SmokeBlue_Grenade_shell"};
                case 5: {_unit addMagazine "1Rnd_SmokeOrange_Grenade_shell"};
                default {_unit addMagazine "1Rnd_Smoke_Grenade_shell"};
            };
        };
    };

	/* ACRE Dependency go home
    switch (rank _unit) do {
        case "SERGEANT": {_unit addItem "ACRE_PRC148_UHF"};
        case "LIEUTENANT": {_unit addItem "ACRE_PRC148_UHF"};
        case "CAPTAIN": {_unit addItem "ACRE_PRC152"};
        case "MAJOR": {_unit addItem "ACRE_PRC152"};
        case "COLONEL": {_unit addItem "ACRE_PRC152"};
    };
	*/

    if (daytime < TimeSunrise OR daytime > TimeSunset) then {
        if (_usesGL) then {
            //3Rnd_UGL_FlareWhite_F
            _unit addMagazines ["UGL_FlareWhite_F", 6];
            {_unit addMagazine _x} forEach ["UGL_FlareGreen_F",
                                            "UGL_FlareRed_F",
                                            "UGL_FlareYellow_F",
                                            "UGL_FlareCIR_F"];
        } else {
            for "_i" from 1 to (5 + floor(random 5)) do {
                _unit addMagazine (["Chemlight_blue",
                                    "Chemlight_green",
                                    "Chemlight_red",
                                    "Chemlight_yellow"] call BIS_fnc_selectRandom);
            };
        };
    } else {
        _unit unassignItem "NVGoggles";
        _unit removeItem "NVGoggles";
    };

    _unit addEventHandler ["Killed",{_this spawn fnc_Cleanup}];
};

//[LOCATION, spread, size of grp] call fnc_CreateRegular;
fnc_CreateRegular = {
    private ["_spawnPos","_spread","_size","_grp","_unit"];

    _spawnPos = _this select 0;
    _spread = if (count _this > 1) then {_this select 1} else {1};
    _size = if (count _this > 2) then {(_this select 2) max 1} else {6};

    _grp = createGroup East;
    _grp createUnit [["O_Soldier_SL_F",
                      "O_Soldier_TL_F",
                      "O_Soldier_F",
                      "O_Soldier_F",
                      "O_Soldier_F"] call BIS_fnc_selectRandom ,_spawnPos,[],_spread,"FORM"];
    
	_units = [(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"InfantryClasses",[]] call BIS_fnc_returnConfigEntry;
    for "_i" from 1 to (_size - 1) do {
		_unit = _units call BIS_fnc_selectRandom;
        _grp createUnit [_unit,_spawnPos,[],_spread,"FORM"];
    };

    {[_x] call fnc_SetUnit} forEach units _grp;

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

//GRP call fnc_DeleteInfantry;
fnc_DeleteInfantry = {
    private ["_grp","_grp_leader","_return","_list"];

    _grp = _this;
    _grp_leader = leader _grp;
    _return = False;

    if (alive _grp_leader) then {        
        _list = [_grp_leader, 500] call fnc_CheckPlayers;
        if (count _list == 0) then {
            _list = [_grp_leader, 1000] call fnc_CheckPlayers;
            if ([_grp_leader, _list, 100] call fnc_IsHidden) then {
                {deleteVehicle _x} forEach units _grp;
                deleteGroup _grp;
                _return = True;
            };
        };
    };

    //Returns True if deleted, False if alive
    _return
};